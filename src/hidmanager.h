#include <QObject>
#include <QStringList>
#include <QVariantList>
#include <QTimer>
#include <QVector>
#include <hidapi/hidapi.h>

class HidManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool deviceConnected READ isDeviceConnected NOTIFY deviceConnectedChanged)
    Q_PROPERTY(QString connectionMode READ connectionMode NOTIFY deviceConnectedChanged)
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)
    Q_PROPERTY(bool batteryKnown READ batteryKnown NOTIFY batteryLevelChanged)
    Q_PROPERTY(bool isCharging READ isCharging NOTIFY batteryLevelChanged)
    Q_PROPERTY(QString firmwareVersion READ firmwareVersion NOTIFY versionInfoChanged)
    Q_PROPERTY(QString rfVersion READ rfVersion NOTIFY versionInfoChanged)

public:
    explicit HidManager(QObject *parent = nullptr);
    ~HidManager();

    bool isDeviceConnected() const { return m_device != nullptr; }
    QString connectionMode() const;
    int batteryLevel() const { return m_batteryLevel; }
    bool batteryKnown() const { return m_batteryLevel >= 0; }
    bool isCharging() const { return m_isCharging; }
    QString firmwareVersion() const { return m_firmwareVersion; }
    QString rfVersion() const { return m_rfVersion; }

    Q_INVOKABLE void scanDevices();
    Q_INVOKABLE bool connectDevice(unsigned short vid, unsigned short pid);
    Q_INVOKABLE void disconnectDevice();
    Q_INVOKABLE void writeReport(const QByteArray &data);
    Q_INVOKABLE void sendFeatureReport(const QByteArray &data);
    Q_INVOKABLE void sendConfigPacket(const QByteArray &data);
    
    Q_INVOKABLE void applyDpi(const QVariantList &stages, int current_stage);
    Q_INVOKABLE void applySettings(int pollingRate);
    Q_INVOKABLE void applyMotionSync(bool enabled);
    Q_INVOKABLE void applyAngleSnap(bool enabled);
    Q_INVOKABLE void applyRipple(bool enabled);
    Q_INVOKABLE void applyLiftOffDistance(bool low);
    Q_INVOKABLE void applyScrollDirection(bool forward);
    Q_INVOKABLE void applyESportsMode(bool open);
    Q_INVOKABLE void refreshVersionInfo();

signals:
    void deviceConnectedChanged();
    void batteryLevelChanged();
    void versionInfoChanged();
    void deviceFound(const QString &name, int vid, int pid);

private slots:
    void pollStatus();

private:
    bool parseBatteryStatusReport(const unsigned char *buffer, int length, int &batteryLevel, bool &charging) const;
    bool parseWirelessStatusReport(const unsigned char *buffer, int length, int &batteryLevel, bool &charging) const;
    bool requestWirelessStatus(int &batteryLevel, bool &charging);
    int stabilizedBatteryLevel(int rawLevel);
    void clearVersionInfo();
    void setVersionInfo(const QString &firmwareVersion, const QString &rfVersion);
    QString parseVersionResponse(const unsigned char *buffer, int length) const;
    bool readVersionInfoViaLibusb(QString &firmwareVersion, QString &rfVersion) const;
    bool reopenHidDevice();

    hid_device *m_device = nullptr;
    QTimer *m_pollTimer = nullptr;
    QString m_devicePath;
    unsigned short m_currentPid = 0;
    int m_batteryLevel = -1;
    bool m_isCharging = false;
    QVector<int> m_recentBatterySamples;
    QString m_firmwareVersion = QStringLiteral("N/D");
    QString m_rfVersion = QStringLiteral("N/D");
};
