#include <QObject>
#include <QStringList>
#include <QVariantList>
#include <QTimer>
#include <hidapi/hidapi.h>

class HidManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool deviceConnected READ isDeviceConnected NOTIFY deviceConnectedChanged)
    Q_PROPERTY(QString connectionMode READ connectionMode NOTIFY deviceConnectedChanged)
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)
    Q_PROPERTY(bool isCharging READ isCharging NOTIFY batteryLevelChanged)

public:
    explicit HidManager(QObject *parent = nullptr);
    ~HidManager();

    bool isDeviceConnected() const { return m_device != nullptr; }
    QString connectionMode() const;
    int batteryLevel() const { return m_batteryLevel; }
    bool isCharging() const { return m_isCharging; }

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
    Q_INVOKABLE void applyLiftOffDistance(bool low);
    Q_INVOKABLE void applyScrollDirection(bool forward);
    Q_INVOKABLE void applyESportsMode(bool open);

signals:
    void deviceConnectedChanged();
    void batteryLevelChanged();
    void deviceFound(const QString &name, int vid, int pid);

private slots:
    void pollStatus();

private:
    hid_device *m_device = nullptr;
    QTimer *m_pollTimer = nullptr;
    unsigned short m_currentPid = 0;
    int m_batteryLevel = 100;
    bool m_isCharging = false;
};
