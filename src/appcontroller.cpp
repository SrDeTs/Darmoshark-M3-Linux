#include "appcontroller.h"

#include <QApplication>
#include <QIcon>
#include <QMenu>
#include <QSystemTrayIcon>
#include <QWindow>

AppController::AppController(QObject *parent)
    : QObject(parent)
{
    if (!QSystemTrayIcon::isSystemTrayAvailable())
        return;

    m_trayIcon = new QSystemTrayIcon(QIcon(QStringLiteral(":/images/LogoDarmoshark.png")), this);
    m_trayMenu = new QMenu();

    auto *showAction = m_trayMenu->addAction(QStringLiteral("Open"));
    auto *quitAction = m_trayMenu->addAction(QStringLiteral("Quit"));

    connect(showAction, &QAction::triggered, this, &AppController::showMainWindow);
    connect(quitAction, &QAction::triggered, this, &AppController::quitApplication);
    connect(m_trayIcon, &QSystemTrayIcon::activated, this, [this](QSystemTrayIcon::ActivationReason reason) {
        if (reason == QSystemTrayIcon::Trigger || reason == QSystemTrayIcon::DoubleClick)
            showMainWindow();
    });

    m_trayIcon->setContextMenu(m_trayMenu);
    m_trayIcon->show();
}

AppController::~AppController() = default;

bool AppController::trayAvailable() const
{
    return m_trayIcon != nullptr;
}

void AppController::setMainWindow(QWindow *window)
{
    m_mainWindow = window;
}

void AppController::hideToTray()
{
    if (!m_mainWindow)
        return;

    m_mainWindow->hide();

    if (m_trayIcon) {
        m_trayIcon->showMessage(
            QStringLiteral("Darmoshark M3"),
            QStringLiteral("The app is still running in the system tray."),
            QSystemTrayIcon::Information,
            2500
        );
    }
}

void AppController::showMainWindow()
{
    if (!m_mainWindow)
        return;

    m_mainWindow->show();
    m_mainWindow->raise();
    m_mainWindow->requestActivate();
}

void AppController::quitApplication()
{
    QApplication::quit();
}
