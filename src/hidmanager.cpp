#include "hidmanager.h"
#include "mouseprotocol.h"
#include <QDebug>
#include <QTimer>

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
            qDebug() << "Successfully opened device at path:" << path;
            break;
        }
    }
    
    hid_free_enumeration(devs);

    if (m_device) {
        m_currentPid = pid;
        hid_set_nonblocking(m_device, 1);
        qDebug() << "Successfully connected to" << QString::number(vid, 16) << ":" << QString::number(pid, 16);
        emit deviceConnectedChanged();
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
        m_currentPid = 0;
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

void HidManager::applyButtonRemap(const QVariantList &mapping) {
    if (!m_device) return;
    
    std::vector<uint8_t> mapVec;
    for (const QVariant &v : mapping) {
        mapVec.push_back(static_cast<uint8_t>(v.toInt()));
    }
    
    auto packet = DarmosharkProtocol::createRemapPacket(mapVec);
    sendConfigPacket(QByteArray(reinterpret_cast<const char*>(packet.data()), packet.size()));
    qDebug() << "Applied button remapping:" << mapping;
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

void HidManager::pollStatus()
{
    if (!m_device) {
        scanDevices(); // Try to auto-reconnect
        return;
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

    // Read response (non-blocking)
    unsigned char readBuf[65];
    int res = hid_read(m_device, readBuf, 65);
    if (res > 0) {
        // Log raw response for debugging
        QString hex;
        for (int i = 0; i < qMin(res, 16); ++i) hex += QString("%1 ").arg(readBuf[i], 2, 16, QChar('0'));
        qDebug() << "HID Status Response:" << hex.trimmed();

        // Compx/Darmoshark status response:
        // If starting with 0x54, it's a specific status report (likely wireless)
        // If 0x04 0x11, it's a standard Compx status report
        if (readBuf[0] == 0x54 || (readBuf[0] == 0x04 && readBuf[1] == 0x11)) {
            int newBattery = readBuf[5];
            // In 0x04 0x11: [4] = charging (0x01).
            // In 0x54: [4] is usually 0x00 in wireless, 0x01 in wired/charging.
            bool newCharging = (readBuf[4] == 0x01);
            
            if (newBattery >= 0 && newBattery <= 100) {
                if (newBattery != m_batteryLevel) {
                    m_batteryLevel = newBattery;
                    emit batteryLevelChanged();
                }
                if (newCharging != m_isCharging) {
                    m_isCharging = newCharging;
                    emit batteryLevelChanged();
                }
            }
        }
    }
}
