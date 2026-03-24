#pragma once

#include <QObject>
#include <QString>

class QSystemTrayIcon;
class QMenu;
class QWindow;
class QAction;
class ConfigManager;

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool trayAvailable READ trayAvailable CONSTANT)

public:
    explicit AppController(QObject *parent = nullptr);
    ~AppController() override;

    bool trayAvailable() const;
    void setMainWindow(QWindow *window);
    void setConfigManager(ConfigManager *configManager);

    Q_INVOKABLE void hideToTray(bool notify = true);
    Q_INVOKABLE void showMainWindow();
    Q_INVOKABLE void quitApplication();

private:
    QString trText(const QString &key) const;
    void refreshTrayTexts();

    QSystemTrayIcon *m_trayIcon = nullptr;
    QMenu *m_trayMenu = nullptr;
    QWindow *m_mainWindow = nullptr;
    QAction *m_showAction = nullptr;
    QAction *m_quitAction = nullptr;
    ConfigManager *m_configManager = nullptr;
};
