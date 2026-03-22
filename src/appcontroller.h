#pragma once

#include <QObject>

class QSystemTrayIcon;
class QMenu;
class QWindow;

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool trayAvailable READ trayAvailable CONSTANT)

public:
    explicit AppController(QObject *parent = nullptr);
    ~AppController() override;

    bool trayAvailable() const;
    void setMainWindow(QWindow *window);

    Q_INVOKABLE void hideToTray();
    Q_INVOKABLE void showMainWindow();
    Q_INVOKABLE void quitApplication();

private:
    QSystemTrayIcon *m_trayIcon = nullptr;
    QMenu *m_trayMenu = nullptr;
    QWindow *m_mainWindow = nullptr;
};
