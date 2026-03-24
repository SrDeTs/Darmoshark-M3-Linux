#pragma once

#include <QObject>
#include <QString>

class QSystemTrayIcon;
class QMenu;
class QWindow;
class QAction;
class ConfigManager;
class HidManager;
class QMediaPlayer;
class QAudioOutput;

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool trayAvailable READ trayAvailable CONSTANT)
    Q_PROPERTY(bool uiSuspended READ uiSuspended NOTIFY uiSuspendedChanged)

public:
    explicit AppController(QObject *parent = nullptr);
    ~AppController() override;

    bool trayAvailable() const;
    bool uiSuspended() const;
    void setMainWindow(QWindow *window);
    void setConfigManager(ConfigManager *configManager);
    void setHidManager(HidManager *hidManager);

    Q_INVOKABLE void hideToTray(bool notify = true);
    Q_INVOKABLE void showMainWindow();
    Q_INVOKABLE void quitApplication();

private:
    QString trText(const QString &key) const;
    void refreshTrayTexts();
    void setUiSuspended(bool suspended);
    void handleBatteryStateChanged();
    void resetBatteryNotificationState();
    void playBatterySound(int percentage);
    void notifyBatteryEvent(const QString &messageKey, int percentage);
    bool canNotifyBatteryEvent(int code) const;

    QSystemTrayIcon *m_trayIcon = nullptr;
    QMenu *m_trayMenu = nullptr;
    QWindow *m_mainWindow = nullptr;
    QAction *m_showAction = nullptr;
    QAction *m_quitAction = nullptr;
    ConfigManager *m_configManager = nullptr;
    HidManager *m_hidManager = nullptr;
    QMediaPlayer *m_batteryPlayer = nullptr;
    QAudioOutput *m_batteryAudioOutput = nullptr;
    int m_lastBatteryAlertThreshold = -1;
    int m_lastKnownBatteryLevel = -1;
    bool m_lastKnownCharging = false;
    bool m_fullBatteryNotified = false;
    bool m_batteryBaselineInitialized = false;
    int m_lastBatteryNotificationCode = -1;
    qint64 m_lastBatteryNotificationAtMs = 0;
    bool m_uiSuspended = false;

signals:
    void uiSuspendedChanged();
};
