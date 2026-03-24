#include "appcontroller.h"
#include "configmanager.h"
#include "hidmanager.h"

#include <QApplication>
#include <QAction>
#include <QAudioOutput>
#include <QIcon>
#include <QMediaPlayer>
#include <QMenu>
#include <QSystemTrayIcon>
#include <QDateTime>
#include <QUrl>
#include <QWindow>

AppController::AppController(QObject *parent)
    : QObject(parent)
{
    m_batteryAudioOutput = new QAudioOutput(this);
    m_batteryAudioOutput->setVolume(1.0f);
    m_batteryPlayer = new QMediaPlayer(this);
    m_batteryPlayer->setAudioOutput(m_batteryAudioOutput);

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

void AppController::setHidManager(HidManager *hidManager)
{
    if (m_hidManager == hidManager)
        return;

    if (m_hidManager) {
        disconnect(m_hidManager, nullptr, this, nullptr);
    }

    m_hidManager = hidManager;
    resetBatteryNotificationState();

    if (m_hidManager) {
        connect(m_hidManager, &HidManager::batteryLevelChanged, this, &AppController::handleBatteryStateChanged, Qt::UniqueConnection);
        connect(m_hidManager, &HidManager::deviceConnectedChanged, this, [this]() {
            if (!m_hidManager || !m_hidManager->isDeviceConnected())
                resetBatteryNotificationState();
        }, Qt::UniqueConnection);
    }
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
    if (key == QStringLiteral("battery.low"))
        return english
            ? QStringLiteral("Mouse battery at %1%.")
            : QStringLiteral("Bateria do mouse em %1%.");
    if (key == QStringLiteral("battery.full"))
        return english
            ? QStringLiteral("Mouse fully charged.")
            : QStringLiteral("O mouse foi carregado completamente.");

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

void AppController::handleBatteryStateChanged()
{
    if (!m_hidManager || !m_configManager || !m_configManager->batteryAlertsEnabled())
        return;

    if (!m_hidManager->isDeviceConnected() || !m_hidManager->batteryKnown())
        return;

    const int batteryLevel = m_hidManager->batteryLevel();
    const bool charging = m_hidManager->isCharging();

    if (!m_batteryBaselineInitialized) {
        m_batteryBaselineInitialized = true;
        m_lastKnownBatteryLevel = batteryLevel;
        m_lastKnownCharging = charging;
        m_fullBatteryNotified = charging && batteryLevel >= 100;

        if (!charging) {
            if (batteryLevel <= 10) {
                m_lastBatteryAlertThreshold = 10;
            } else if (batteryLevel <= 30) {
                m_lastBatteryAlertThreshold = 30;
            } else if (batteryLevel <= 50) {
                m_lastBatteryAlertThreshold = 50;
            }
        }
        return;
    }

    if (charging && batteryLevel >= 100 && !m_fullBatteryNotified && canNotifyBatteryEvent(100)) {
        notifyBatteryEvent(QStringLiteral("battery.full"), 100);
        m_fullBatteryNotified = true;
    }

    if (!charging && batteryLevel <= 95)
        m_fullBatteryNotified = false;

    if (charging) {
        if (batteryLevel > 50)
            m_lastBatteryAlertThreshold = -1;
    } else {
        int threshold = -1;
        if (batteryLevel <= 10) {
            threshold = 10;
        } else if (batteryLevel <= 30) {
            threshold = 30;
        } else if (batteryLevel <= 50) {
            threshold = 50;
        }

        if (batteryLevel > 50) {
            m_lastBatteryAlertThreshold = -1;
        } else if (threshold != -1
                   && (m_lastBatteryAlertThreshold == -1 || threshold < m_lastBatteryAlertThreshold)
                   && canNotifyBatteryEvent(threshold)) {
            notifyBatteryEvent(QStringLiteral("battery.low"), threshold);
            m_lastBatteryAlertThreshold = threshold;
        }
    }

    m_lastKnownBatteryLevel = batteryLevel;
    m_lastKnownCharging = charging;
}

void AppController::resetBatteryNotificationState()
{
    m_lastBatteryAlertThreshold = -1;
    m_lastKnownBatteryLevel = -1;
    m_lastKnownCharging = false;
    m_fullBatteryNotified = false;
    m_batteryBaselineInitialized = false;
    m_lastBatteryNotificationCode = -1;
    m_lastBatteryNotificationAtMs = 0;
}

void AppController::playBatterySound(int percentage)
{
    if (!m_batteryPlayer)
        return;

    QString source;
    switch (percentage) {
    case 10:
        source = QStringLiteral("qrc:/sons/Bateria/Bateria-10%.mp3");
        break;
    case 30:
        source = QStringLiteral("qrc:/sons/Bateria/Bateria-30%.mp3");
        break;
    case 50:
        source = QStringLiteral("qrc:/sons/Bateria/Bateria-50%.mp3");
        break;
    case 100:
        source = QStringLiteral("qrc:/sons/Bateria/Bateria-100%.mp3");
        break;
    default:
        return;
    }

    m_batteryPlayer->stop();
    m_batteryPlayer->setSource(QUrl(source));
    m_batteryPlayer->play();
}

void AppController::notifyBatteryEvent(const QString &messageKey, int percentage)
{
    playBatterySound(percentage);
    m_lastBatteryNotificationCode = percentage;
    m_lastBatteryNotificationAtMs = QDateTime::currentMSecsSinceEpoch();

    if (!m_trayIcon)
        return;

    QString message = trText(messageKey);
    if (message.contains(QStringLiteral("%1")))
        message = message.arg(percentage);

    m_trayIcon->showMessage(
        QStringLiteral("Darmoshark M3"),
        message,
        QSystemTrayIcon::Information,
        3000
    );
}

bool AppController::canNotifyBatteryEvent(int code) const
{
    constexpr qint64 cooldownMs = 120000;
    const qint64 now = QDateTime::currentMSecsSinceEpoch();
    if (m_lastBatteryNotificationCode != code)
        return true;
    return (now - m_lastBatteryNotificationAtMs) >= cooldownMs;
}
