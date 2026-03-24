#include "hidmanager.h"
#include "configmanager.h"
#include "mouseprotocol.h"
#include <QDebug>
#include <QRegularExpression>
#include <QThread>
#include <QTimer>
#include <algorithm>
#include <libusb-1.0/libusb.h>

HidManager::HidManager(QObject *parent) : QObject(parent)
{
    if (hid_init() != 0) {
        qWarning() << "Failed to initialize hidapi";
    }
    
    m_pollTimer = new QTimer(this);
    m_pollTimer->setInterval(2000); // Poll every 2 seconds
    connect(m_pollTimer, &QTimer::timeout, this, &HidManager::pollStatus);
    m_pollTimer->start(); // Always run to allow auto-reconnect
}

HidManager::~HidManager()
{
    disconnectDevice();
    hid_exit();
}

void HidManager::setConfigManager(ConfigManager *configManager)
{
    m_configManager = configManager;
}

void HidManager::scanDevices()
{
    struct hid_device_info *devs, *cur_dev;
    devs = hid_enumerate(0x248a, 0x0); // Enumerate all 248a devices
    cur_dev = devs;
    
    bool found = false;
    while (cur_dev) {
        qDebug() << "Found device:" << QString::fromWCharArray(cur_dev->product_string) 
                 << "VID:" << QString::number(cur_dev->vendor_id, 16) 
                 << "PID:" << QString::number(cur_dev->product_id, 16);
        
        // Check if it's a known PID
        if (cur_dev->product_id == 0xff12 || cur_dev->product_id == 0xff30 || 
            cur_dev->product_id == 0xff31 || cur_dev->product_id == 0xff10 || 
            cur_dev->product_id == 0xff18) {
            
            if (!m_device) {
                connectDevice(cur_dev->vendor_id, cur_dev->product_id);
                found = true;
                break;
            }
        }
        cur_dev = cur_dev->next;
    }
    hid_free_enumeration(devs);
}

bool HidManager::connectDevice(unsigned short vid, unsigned short pid)
{
    disconnectDevice();
    
    // Some devices have multiple interfaces. We need to find the configuration interface.
    // Usually it's interface 1 for Compx controllers in 2.4G mode.
    struct hid_device_info *devs, *cur_dev;
    devs = hid_enumerate(vid, pid);
    if (!devs) return false;

    // Try interfaces in order of preference based on original driver config.xml
    // MI_01 for Wireless (FF30/FF31), MI_02 for Wired (FF12)
    QList<QString> candidatePaths;
    cur_dev = devs;
    while (cur_dev) {
        qDebug() << "Interface found:" << cur_dev->interface_number 
                 << "Usage Page:" << QString::number(cur_dev->usage_page, 16) 
                 << "Path:" << cur_dev->path;
        
        QString p = QString::fromLatin1(cur_dev->path);
        int targetInterface = (pid == 0xff12) ? 2 : 1; // MI_02 for Wired, MI_01 for Wireless
        
        if (cur_dev->interface_number == targetInterface) {
            candidatePaths.prepend(p); // Highest preference
        } else if (cur_dev->interface_number > 0) {
            candidatePaths.append(p); // Secondary preference
        }
        cur_dev = cur_dev->next;
    }
    
    for (const QString &path : candidatePaths) {
        qDebug() << "Attempting to open path:" << path;
        m_device = hid_open_path(path.toLatin1().constData());
        if (m_device) {
            m_devicePath = path;
            qDebug() << "Successfully opened device at path:" << path;
            break;
        }
    }
    
    hid_free_enumeration(devs);

    if (m_device) {
        m_currentPid = pid;
        hid_set_nonblocking(m_device, 1);
        m_versionInfoAttemptedForCurrentConnection = false;
        m_versionInfoRefreshInProgress = false;
        qDebug() << "Successfully connected to" << QString::number(vid, 16) << ":" << QString::number(pid, 16);
        emit deviceConnectedChanged();
        pollStatus();
        return true;
    } else {
        qWarning() << "Failed to open device" << QString::number(vid, 16) << ":" << QString::number(pid, 16)
                  << ". (Make sure udev rules are applied or use sudo for testing)";
    }
    return false;
}

void HidManager::disconnectDevice()
{
    if (m_device) {
        hid_close(m_device);
        m_device = nullptr;
        m_devicePath.clear();
        m_currentPid = 0;
        m_recentBatterySamples.clear();
        const bool batteryStateChanged = (m_batteryLevel != -1) || m_isCharging;
        m_batteryLevel = -1;
        m_isCharging = false;
        m_versionInfoAttemptedForCurrentConnection = false;
        m_versionInfoRefreshInProgress = false;
        clearVersionInfo();
        if (batteryStateChanged)
            emit batteryLevelChanged();
        emit deviceConnectedChanged();
    }
}

QString HidManager::connectionMode() const
{
    if (!m_device) return "Disconnected";
    if (m_currentPid == 0xff12) return "Wired";
    if (m_currentPid == 0xff30 || m_currentPid == 0xff31) return "2.4G Wireless";
    return "Unknown";
}

void HidManager::writeReport(const QByteArray &data)
{
    if (!m_device) return;
    
    // Log raw data being written
    QString hex;
    for (int i = 0; i < data.size(); ++i) hex += QString("%1 ").arg((unsigned char)data[i], 2, 16, QChar('0'));
    qDebug() << "Writing HID report:" << hex.trimmed();

    // hid_write handles report ID as the first byte
    int res = hid_write(m_device, reinterpret_cast<const unsigned char*>(data.data()), data.size());
    qDebug() << "hid_write returned:" << res;
    if (res < 0) {
        qWarning() << "Error writing HID report:" << QString::fromWCharArray(hid_error(m_device));
    }
}

static void logHexBuffer(const char *label, const unsigned char *data, int len)
{
    QString hex;
    for (int i = 0; i < len; ++i) {
        hex += QString("%1 ").arg(data[i], 2, 16, QChar('0'));
    }
    qDebug() << label << hex.trimmed();
}

void HidManager::sendFeatureReport(const QByteArray &data)
{
    if (!m_device) return;

    QByteArray buffer = data;
    int res = hid_send_feature_report(
        m_device,
        reinterpret_cast<const unsigned char*>(buffer.data()),
        buffer.size()
    );

    logHexBuffer("Sending feature report:", reinterpret_cast<const unsigned char*>(buffer.data()), buffer.size());
    qDebug() << "hid_send_feature_report returned:" << res;
    if (res < 0) {
        qWarning() << "Error sending feature report:" << QString::fromWCharArray(hid_error(m_device));
        qWarning() << "Falling back to hid_write";
        writeReport(data);
    }
}

void HidManager::sendConfigPacket(const QByteArray &data)
{
    if (!m_device) return;

    const bool wiredMode = (m_currentPid == 0xff12);
    qDebug() << "Sending config packet using hid_send_feature_report for" << (wiredMode ? "USB" : "2.4G");
    sendFeatureReport(data);
}

void HidManager::refreshVersionInfo()
{
    if (!m_device) {
        clearVersionInfo();
        return;
    }

    if (m_versionInfoRefreshInProgress)
        return;

    const bool wiredMode = (m_currentPid == 0xff12);
    if (!wiredMode && m_versionInfoAttemptedForCurrentConnection && m_firmwareVersion != QStringLiteral("N/D"))
        return;

    m_versionInfoRefreshInProgress = true;
    m_versionInfoAttemptedForCurrentConnection = true;

    QString firmwareVersion = QStringLiteral("N/D");
    QString rfVersion = QStringLiteral("N/D");
    const QString modeKey = versionCacheModeKey();

    if (m_configManager && !wiredMode) {
        const QString cachedFirmwareVersion = m_configManager->cachedFirmwareVersion(0x248a, m_currentPid, modeKey);
        if (cachedFirmwareVersion != QStringLiteral("N/D")) {
            firmwareVersion = cachedFirmwareVersion;
            const QString cachedRfVersion = m_configManager->cachedRfVersion(0x248a, m_currentPid, modeKey, cachedFirmwareVersion);
            if (cachedRfVersion != QStringLiteral("N/D"))
                rfVersion = cachedRfVersion;

            if (rfVersion != QStringLiteral("N/D")) {
                qDebug() << "Using cached version info:" << firmwareVersion << rfVersion;
                setVersionInfo(firmwareVersion, rfVersion);
                m_versionInfoRefreshInProgress = false;
                return;
            }
        }
    }

    if (wiredMode) {
        for (int attempt = 0; attempt < 6; ++attempt) {
            unsigned char buffer[21] = {0};
            buffer[0] = 0x51;

            const int res = hid_get_feature_report(m_device, buffer, sizeof(buffer));
            if (res <= 0) {
                qWarning() << "hid_get_feature_report(0x51) failed:" << res;
                break;
            }

            const QString version = parseVersionResponse(buffer, res);
            if (version.isEmpty()) {
                QThread::msleep(20);
                continue;
            }

            qDebug() << "Version response from report 0x51:" << version;
            if (version.startsWith(QLatin1Char('e'), Qt::CaseInsensitive)) {
                rfVersion = version;
            } else {
                firmwareVersion = version;
            }

            if (firmwareVersion != QStringLiteral("N/D") && rfVersion != QStringLiteral("N/D"))
                break;

            QThread::msleep(20);
        }
    }

    if ((firmwareVersion == QStringLiteral("N/D") || rfVersion == QStringLiteral("N/D"))
        && !m_devicePath.isEmpty()) {
        const bool wasPolling = m_pollTimer && m_pollTimer->isActive();
        if (wasPolling)
            m_pollTimer->stop();

        hid_close(m_device);
        m_device = nullptr;

        const bool libusbReadOk = readVersionInfoViaLibusb(firmwareVersion, rfVersion);
        const bool reopenOk = reopenHidDevice();
        if (!reopenOk) {
            qWarning() << "Failed to reopen HID device after libusb version read";
        } else if (libusbReadOk) {
            qDebug() << "Version info read via libusb:" << firmwareVersion << rfVersion;
        }

        if (wasPolling && m_pollTimer)
            m_pollTimer->start();
    }

    if (firmwareVersion == QStringLiteral("N/D") && rfVersion == QStringLiteral("N/D")) {
        qWarning() << "Unable to read version info from connected device";
    }

    if (m_configManager && !wiredMode) {
        if (firmwareVersion != QStringLiteral("N/D")) {
            m_configManager->rememberFirmwareVersion(0x248a, m_currentPid, modeKey, firmwareVersion);
        } else {
            const QString cachedFirmwareVersion = m_configManager->cachedFirmwareVersion(0x248a, m_currentPid, modeKey);
            if (cachedFirmwareVersion != QStringLiteral("N/D")) {
                qDebug() << "Using cached firmware version:" << cachedFirmwareVersion;
                firmwareVersion = cachedFirmwareVersion;
            }
        }

        if (firmwareVersion != QStringLiteral("N/D") && rfVersion != QStringLiteral("N/D")) {
            m_configManager->rememberRfVersion(0x248a, m_currentPid, modeKey, firmwareVersion, rfVersion);
        } else if (firmwareVersion != QStringLiteral("N/D")) {
            const QString cachedRfVersion = m_configManager->cachedRfVersion(0x248a, m_currentPid, modeKey, firmwareVersion);
            if (cachedRfVersion != QStringLiteral("N/D")) {
                qDebug() << "Using cached RF version:" << cachedRfVersion;
                rfVersion = cachedRfVersion;
            }
        }
    }

    setVersionInfo(firmwareVersion, rfVersion);
    m_versionInfoRefreshInProgress = false;
}

bool HidManager::reopenHidDevice()
{
    if (m_device || m_devicePath.isEmpty())
        return m_device != nullptr;

    m_device = hid_open_path(m_devicePath.toLatin1().constData());
    if (!m_device)
        return false;

    hid_set_nonblocking(m_device, 1);
    return true;
}

QString HidManager::versionCacheModeKey() const
{
    if (m_currentPid == 0xff12)
        return QStringLiteral("wired");
    if (m_currentPid == 0xff30 || m_currentPid == 0xff31)
        return QStringLiteral("2.4g");
    return QStringLiteral("unknown");
}

void HidManager::applyDpi(const QVariantList &stages, int current_stage)
{
    if (!m_device) return;

    QStringList stageValues;
    for (const QVariant &v : stages) {
        stageValues << QString::number(v.toMap()["value"].toInt());
    }

    if (stageValues.isEmpty()) {
        qWarning() << "Skipping DPI apply: no stages available";
        return;
    }

    int stageNumber = current_stage;
    if (stageNumber < 0) stageNumber = 0;
    if (stageNumber >= stageValues.size()) stageNumber = stageValues.size() - 1;

    qDebug() << "Applying DPI packet with stages:" << stageValues
             << "current_stage:" << stageNumber;

    const bool wiredMode = (m_currentPid == 0xff12);
    auto packet = DarmosharkProtocol::createDpiPacket(stageValues, stageNumber, wiredMode);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    sendConfigPacket(data);
}

void HidManager::applySettings(int pollingRate)
{
    const bool wiredMode = (m_currentPid == 0xff12);
    auto packet = DarmosharkProtocol::createPollingRatePacket(pollingRate, wiredMode);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    sendConfigPacket(data);
}

void HidManager::applyMotionSync(bool enabled)
{
    const bool wiredMode = (m_currentPid == 0xff12);
    auto packet = DarmosharkProtocol::createMotionSyncPacket(enabled, wiredMode);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    qDebug() << "Applying Motion Sync:" << enabled << "wiredMode:" << wiredMode;
    sendConfigPacket(data);
}

void HidManager::applyAngleSnap(bool enabled)
{
    const bool wiredMode = (m_currentPid == 0xff12);
    auto packet = DarmosharkProtocol::createAngleSnapPacket(enabled, wiredMode);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    qDebug() << "Applying Angle Snap:" << enabled << "wiredMode:" << wiredMode;
    sendConfigPacket(data);
}

void HidManager::applyRipple(bool enabled)
{
    const bool wiredMode = (m_currentPid == 0xff12);
    auto packet = DarmosharkProtocol::createRipplePacket(enabled, wiredMode);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    qDebug() << "Applying Ripple:" << enabled << "wiredMode:" << wiredMode;
    sendConfigPacket(data);
}

void HidManager::applyLiftOffDistance(bool low)
{
    if (!m_device) return;

    auto packet = DarmosharkProtocol::createLiftOffDistancePacket(low);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    qDebug() << "Applying Lift Off Distance:" << (low ? "Low" : "High");
    sendConfigPacket(data);
}

void HidManager::applyScrollDirection(bool forward)
{
    if (!m_device) return;

    const bool wiredMode = (m_currentPid == 0xff12);
    auto packet = DarmosharkProtocol::createScrollDirectionPacket(forward, wiredMode);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    qDebug() << "Applying Scroll Direction:" << (forward ? "Forward" : "Reverse")
             << "wiredMode:" << wiredMode;
    sendFeatureReport(data);
}

void HidManager::applyESportsMode(bool open)
{
    if (!m_device) return;

    const bool wiredMode = (m_currentPid == 0xff12);
    auto packet = DarmosharkProtocol::createESportsModePacket(open, wiredMode);
    QByteArray data(reinterpret_cast<const char*>(packet.data()), packet.size());

    qDebug() << "Applying E-Sports Mode:" << (open ? "Open" : "Close")
             << "wiredMode:" << wiredMode;
    sendConfigPacket(data);
}

void HidManager::pollStatus()
{
    if (!m_device) {
        scanDevices(); // Try to auto-reconnect
        return;
    }

    if (m_currentPid == 0xff30 || m_currentPid == 0xff31) {
        int wirelessBattery = -1;
        bool wirelessCharging = m_isCharging;
        if (requestWirelessStatus(wirelessBattery, wirelessCharging)) {
            bool changed = false;

            if (wirelessBattery >= 0) {
                const int newBattery = stabilizedBatteryLevel(wirelessBattery);
                if (newBattery != m_batteryLevel) {
                    m_batteryLevel = newBattery;
                    changed = true;
                }
            }

            if (wirelessCharging != m_isCharging) {
                m_isCharging = wirelessCharging;
                changed = true;
            }

            if (changed)
                emit batteryLevelChanged();
            return;
        }
    }

    // Send status request (Compx standard: 04 11 02 02 ...)
    unsigned char buf[65] = {0};
    buf[0] = 0x04;
    buf[1] = 0x11;
    buf[2] = 0x02;
    buf[3] = 0x02;
    // ... rest zero
    
    int bytesWritten = hid_write(m_device, buf, 65);
    if (bytesWritten < 0) {
        qWarning() << "Device disconnected based on write error";
        disconnectDevice();
        return;
    }

    int latestBattery = -1;
    bool latestCharging = m_isCharging;

    for (int attempt = 0; attempt < 3; ++attempt) {
        unsigned char readBuf[65] = {0};
        const int res = (attempt == 0)
            ? hid_read_timeout(m_device, readBuf, sizeof(readBuf), 45)
            : hid_read(m_device, readBuf, sizeof(readBuf));

        if (res < 0) {
            qWarning() << "Device disconnected based on read error";
            disconnectDevice();
            return;
        }

        if (res == 0)
            continue;

        QString hex;
        for (int i = 0; i < qMin(res, 16); ++i)
            hex += QString("%1 ").arg(readBuf[i], 2, 16, QChar('0'));
        qDebug() << "HID Status Response:" << hex.trimmed();

        int parsedBattery = -1;
        bool parsedCharging = false;
        if (parseBatteryStatusReport(readBuf, res, parsedBattery, parsedCharging)) {
            latestBattery = parsedBattery;
            latestCharging = parsedCharging;
        }
    }

    if (latestBattery < 0)
        return;

    const int newBattery = stabilizedBatteryLevel(latestBattery);
    bool changed = false;

    if (newBattery != m_batteryLevel) {
        m_batteryLevel = newBattery;
        changed = true;
    }

    if (latestCharging != m_isCharging) {
        m_isCharging = latestCharging;
        changed = true;
    }

    if (changed)
        emit batteryLevelChanged();
}

bool HidManager::parseBatteryStatusReport(const unsigned char *buffer, int length, int &batteryLevel, bool &charging) const
{
    if (!buffer || length < 6)
        return false;

    const bool isWirelessStatus = (buffer[0] == 0x54);
    const bool isCompxStatus = (length >= 6 && buffer[0] == 0x04 && buffer[1] == 0x11);
    if (!isWirelessStatus && !isCompxStatus)
        return false;

    const int rawBattery = static_cast<int>(buffer[5]);
    if (rawBattery < 0 || rawBattery > 100)
        return false;

    batteryLevel = rawBattery;
    charging = (buffer[4] == 0x01);
    return true;
}

bool HidManager::parseWirelessStatusReport(const unsigned char *buffer, int length, int &batteryLevel, bool &charging) const
{
    if (!buffer || length < 3)
        return false;

    if (buffer[0] != 0x54)
        return false;

    // Captured from the original Windows software on the wireless interface:
    // 54 e2 01 01 00 44 ...
    //                     ^^ battery percentage, descending over time.
    if (buffer[1] == 0xE2) {
        if (length < 6)
            return false;

        const int rawBattery = static_cast<int>(buffer[5]);
        if (rawBattery < 0 || rawBattery > 100)
            return false;

        batteryLevel = rawBattery;
        charging = false;
        return true;
    }

    // Report 0xE4 appears to carry status/charge state notifications.
    if (buffer[1] == 0xE4) {
        const int state = static_cast<int>(buffer[2]);
        charging = (state == 0x01);
        batteryLevel = -1;
        return true;
    }

    return false;
}

bool HidManager::requestWirelessStatus(int &batteryLevel, bool &charging)
{
    if (!m_device)
        return false;

    unsigned char query[21] = {0};
    query[0] = 0x51;
    query[1] = 0x0C;
    query[2] = 0x02;

    const int sendRes = hid_send_feature_report(m_device, query, sizeof(query));
    if (sendRes < 0) {
        qWarning() << "Wireless status query failed:" << QString::fromWCharArray(hid_error(m_device));
        return false;
    }

    bool gotAnyStatus = false;

    for (int attempt = 0; attempt < 8; ++attempt) {
        unsigned char readBuf[64] = {0};
        const int res = hid_read_timeout(m_device, readBuf, sizeof(readBuf), 25);

        if (res < 0) {
            qWarning() << "Wireless status read failed:" << QString::fromWCharArray(hid_error(m_device));
            return false;
        }

        if (res == 0)
            continue;

        int parsedBattery = -1;
        bool parsedCharging = charging;
        if (parseWirelessStatusReport(readBuf, res, parsedBattery, parsedCharging)) {
            QString hex;
            for (int i = 0; i < res; ++i)
                hex += QString("%1 ").arg(readBuf[i], 2, 16, QChar('0'));
            qDebug() << "Wireless status report:" << hex.trimmed();

            charging = parsedCharging;
            gotAnyStatus = true;

            if (parsedBattery >= 0) {
                batteryLevel = parsedBattery;
                return true;
            }
        }
    }

    return gotAnyStatus;
}

int HidManager::stabilizedBatteryLevel(int rawLevel)
{
    m_recentBatterySamples.append(rawLevel);
    while (m_recentBatterySamples.size() > 3)
        m_recentBatterySamples.removeFirst();

    QVector<int> sorted = m_recentBatterySamples;
    std::sort(sorted.begin(), sorted.end());
    return sorted.at(sorted.size() / 2);
}

void HidManager::clearVersionInfo()
{
    setVersionInfo(QStringLiteral("N/D"), QStringLiteral("N/D"));
}

void HidManager::setVersionInfo(const QString &firmwareVersion, const QString &rfVersion)
{
    if (m_firmwareVersion == firmwareVersion && m_rfVersion == rfVersion)
        return;

    m_firmwareVersion = firmwareVersion;
    m_rfVersion = rfVersion;
    emit versionInfoChanged();
}

QString HidManager::parseVersionResponse(const unsigned char *buffer, int length) const
{
    if (!buffer || length <= 0)
        return QString();

    QByteArray normalized;
    normalized.reserve(length);

    for (int i = 0; i < length; ++i) {
        const unsigned char ch = buffer[i];
        const bool allowed = (ch >= '0' && ch <= '9')
            || (ch >= 'a' && ch <= 'z')
            || (ch >= 'A' && ch <= 'Z')
            || ch == '.'
            || ch == '-';

        normalized.append(allowed ? static_cast<char>(ch) : ' ');
    }

    static const QRegularExpression versionPattern(QStringLiteral("([A-Za-z]?\\.?\\d+(?:\\.\\d+)+(?:[A-Za-z](?:-?\\d+)?|-\\d+)?)"));
    const QString text = QString::fromLatin1(normalized);
    QRegularExpressionMatchIterator it = versionPattern.globalMatch(text);
    QString bestMatch;

    while (it.hasNext()) {
        const QRegularExpressionMatch match = it.next();
        const QString candidate = match.captured(1).trimmed();
        if (candidate.length() < 5)
            continue;

        if (bestMatch.isEmpty() || candidate.length() > bestMatch.length())
            bestMatch = candidate;
    }

    return bestMatch;
}

bool HidManager::readVersionInfoViaLibusb(QString &firmwareVersion, QString &rfVersion) const
{
    libusb_context *context = nullptr;
    if (libusb_init(&context) != 0)
        return false;

    libusb_device_handle *handle = libusb_open_device_with_vid_pid(context, 0x248a, m_currentPid);
    if (!handle) {
        libusb_exit(context);
        return false;
    }

    const bool wiredMode = (m_currentPid == 0xff12);
    const uint16_t reportValue = static_cast<uint16_t>((3u << 8) | 0x51u);
    const uint16_t firmwareReportValue = static_cast<uint16_t>((3u << 8) | 0x82u);
    const uint16_t interfaceNumber = static_cast<uint16_t>(wiredMode ? 2 : 1);
    const unsigned char requestType = 0xA1;
    const unsigned char setRequestType = 0x21;
    const unsigned char interruptInEndpoint = static_cast<unsigned char>(wiredMode ? 0x82 : 0x84);
    const int interfaceIndex = static_cast<int>(interfaceNumber);
    bool detachedKernelDriver = false;
    bool success = false;

    const int kernelActive = libusb_kernel_driver_active(handle, interfaceIndex);
    if (kernelActive == 1) {
        const int detachRes = libusb_detach_kernel_driver(handle, interfaceIndex);
        if (detachRes == 0) {
            detachedKernelDriver = true;
        } else {
            qWarning() << "libusb_detach_kernel_driver failed:" << detachRes;
        }
    }

    const int claimRes = libusb_claim_interface(handle, interfaceIndex);
    if (claimRes != 0) {
        qWarning() << "libusb_claim_interface failed:" << claimRes;
        if (detachedKernelDriver)
            libusb_attach_kernel_driver(handle, interfaceIndex);
        libusb_close(handle);
        libusb_exit(context);
        return false;
    }

    if (firmwareVersion == QStringLiteral("N/D") && wiredMode) {
        const QList<QByteArray> firmwareReports = {
            QByteArray::fromHex("8201080000000300ffff00000000"),
            QByteArray::fromHex("8201080000000300000001000000"),
            QByteArray::fromHex("8201080000000300010000000000")
        };

        for (const QByteArray &report : firmwareReports) {
            const int transferred = libusb_control_transfer(
                handle,
                setRequestType,
                0x09,
                firmwareReportValue,
                interfaceNumber,
                reinterpret_cast<unsigned char *>(const_cast<char *>(report.constData())),
                report.size(),
                1000
            );

            if (transferred < 0) {
                qWarning() << "libusb SET_REPORT(0x82) failed:" << transferred;
                continue;
            }

            QThread::msleep(20);
        }

        for (int attempt = 0; attempt < 8; ++attempt) {
            unsigned char interruptBuffer[64] = {0};
            int actualLength = 0;
            const int interruptRes = libusb_interrupt_transfer(
                handle,
                interruptInEndpoint,
                interruptBuffer,
                sizeof(interruptBuffer),
                &actualLength,
                100
            );

            if (interruptRes != 0 || actualLength <= 0)
                continue;

            if (interruptBuffer[0] != 0x84)
                continue;

            const QString version = parseVersionResponse(interruptBuffer, actualLength);
            if (version.isEmpty())
                continue;

            firmwareVersion = version;
            success = true;
            qDebug() << "Firmware version response from libusb interrupt sequence:" << firmwareVersion;
            break;
        }
    }

    if (!wiredMode) {
        unsigned char queryBuffer[21] = {0};
        queryBuffer[0] = 0x51;
        queryBuffer[1] = 0x0c;
        queryBuffer[2] = 0x02;

        const int queryTransferred = libusb_control_transfer(
            handle,
            setRequestType,
            0x09,
            reportValue,
            interfaceNumber,
            queryBuffer,
            sizeof(queryBuffer),
            1000
        );
        if (queryTransferred < 0) {
            qWarning() << "libusb SET_REPORT(0x51 version query) failed:" << queryTransferred;
        } else {
            for (int attempt = 0; attempt < 12; ++attempt) {
                unsigned char interruptBuffer[64] = {0};
                int actualLength = 0;
                const int interruptRes = libusb_interrupt_transfer(
                    handle,
                    interruptInEndpoint,
                    interruptBuffer,
                    sizeof(interruptBuffer),
                    &actualLength,
                    120
                );

                if (interruptRes != 0 || actualLength <= 0)
                    continue;

                const QString version = parseVersionResponse(interruptBuffer, actualLength);
                if (version.isEmpty()) {
                    QThread::msleep(8);
                    continue;
                }

                firmwareVersion = version;
                success = true;
                qDebug() << "Firmware version response from wireless interrupt sequence:" << firmwareVersion;
                break;
            }
        }
    } else {
        unsigned char setBuffer[21] = {0};
        setBuffer[0] = 0x51;
        setBuffer[1] = 0x04;
        setBuffer[2] = 0xaa;
        const int setTransferred = libusb_control_transfer(
            handle,
            setRequestType,
            0x09,
            reportValue,
            interfaceNumber,
            setBuffer,
            sizeof(setBuffer),
            1000
        );
        if (setTransferred < 0)
            qWarning() << "libusb SET_REPORT(0x51) failed:" << setTransferred;

        for (int attempt = 0; attempt < 6; ++attempt) {
            unsigned char buffer[21] = {0};
            const int transferred = libusb_control_transfer(
                handle,
                requestType,
                0x01,
                reportValue,
                interfaceNumber,
                buffer,
                sizeof(buffer),
                1000
            );

            if (transferred <= 0) {
                qWarning() << "libusb GET_REPORT(0x51) failed:" << transferred;
                QThread::msleep(20);
                continue;
            }

            const QString version = parseVersionResponse(buffer, transferred);
            if (version.isEmpty()) {
                QThread::msleep(20);
                continue;
            }

            if (version.startsWith(QLatin1Char('e'), Qt::CaseInsensitive)) {
                rfVersion = version;
            } else {
                firmwareVersion = version;
            }

            success = true;
            if (firmwareVersion != QStringLiteral("N/D") && rfVersion != QStringLiteral("N/D"))
                break;

            QThread::msleep(20);
        }
    }

    libusb_release_interface(handle, interfaceIndex);
    if (detachedKernelDriver)
        libusb_attach_kernel_driver(handle, interfaceIndex);

    libusb_close(handle);
    libusb_exit(context);
    return success;
}
