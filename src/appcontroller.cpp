#include "appcontroller.h"
#include "configmanager.h"

#include <QApplication>
#include <QAction>
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

    m_showAction = m_trayMenu->addAction(QString());
    m_quitAction = m_trayMenu->addAction(QString());

    connect(m_showAction, &QAction::triggered, this, &AppController::showMainWindow);
    connect(m_quitAction, &QAction::triggered, this, &AppController::quitApplication);
    connect(m_trayIcon, &QSystemTrayIcon::activated, this, [this](QSystemTrayIcon::ActivationReason reason) {
        if (reason == QSystemTrayIcon::Trigger || reason == QSystemTrayIcon::DoubleClick)
            showMainWindow();
    });

    m_trayIcon->setContextMenu(m_trayMenu);
    refreshTrayTexts();
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

void AppController::setConfigManager(ConfigManager *configManager)
{
    if (m_configManager == configManager)
        return;

    m_configManager = configManager;
    if (m_configManager) {
        connect(m_configManager, &ConfigManager::configChanged, this, &AppController::refreshTrayTexts, Qt::UniqueConnection);
    }

    refreshTrayTexts();
}

void AppController::hideToTray(bool notify)
{
    if (!m_mainWindow)
        return;

    m_mainWindow->hide();

    if (m_trayIcon && notify) {
        m_trayIcon->showMessage(
            QStringLiteral("Darmoshark M3"),
            trText(QStringLiteral("tray.message")),
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

QString AppController::trText(const QString &key) const
{
    const QString language = m_configManager ? m_configManager->language() : QStringLiteral("pt-BR");
    const bool english = language == QStringLiteral("en-US");

    if (key == QStringLiteral("tray.open"))
        return english ? QStringLiteral("Open") : QStringLiteral("Abrir");
    if (key == QStringLiteral("tray.quit"))
        return english ? QStringLiteral("Quit") : QStringLiteral("Sair");
    if (key == QStringLiteral("tray.message"))
        return english
            ? QStringLiteral("The app is still running in the system tray.")
            : QStringLiteral("O app ainda está em execução na bandeja do sistema.");

    return key;
}

void AppController::refreshTrayTexts()
{
    if (!m_trayMenu)
        return;

    if (m_showAction)
        m_showAction->setText(trText(QStringLiteral("tray.open")));

    if (m_quitAction)
        m_quitAction->setText(trText(QStringLiteral("tray.quit")));
}
