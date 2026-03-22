#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QFileInfo>
#include <QCoreApplication>
#include <QDir>
#include <QTextStream>
#include "hidmanager.h"
#include "configmanager.h"

static QString defaultConfigText()
{
    return QStringLiteral(
        "# Darmoshark M3 Configuration\n"
        "\n"
        "[device]\n"
        "name = \"Darmoshark M3\"\n"
        "vid = 0x248A\n"
        "pid = 0xFF12\n"
        "\n"
        "[dpi]\n"
        "current_stage = 1\n"
        "stages = [400, 800, 1600, 3200, 4800]\n"
        "\n"
        "[ui]\n"
        "polling_rate = 1000\n"
        "ripple_enabled = false\n"
        "motion_sync_enabled = true\n"
        "angle_snap_enabled = false\n"
        "lift_off_high = false\n"
        "scroll_normal = true\n"
        "esports_open = false\n"
        "\n"
        "[buttons]\n"
        "left = \"Left-Click\"\n"
        "right = \"Right-Click\"\n"
        "middle = \"Middle-Click\"\n"
        "forward = \"Forward\"\n"
        "backward = \"Backward\"\n"
    );
}

static bool writeDefaultConfigFile(const QString &path)
{
    QDir().mkpath(QFileInfo(path).absolutePath());

    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        qWarning() << "Failed to create default config:" << path;
        return false;
    }

    QTextStream out(&file);
    out << defaultConfigText();
    return true;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("Darmoshark");
    app.setApplicationName("Darmoshark M3 Configurator");

    HidManager hidManager;
    hidManager.scanDevices(); // Scan and auto-connect on startup
    ConfigManager configManager;

    QString userConfigPath = QDir::homePath() + "/.config/Darmoshark M3 Linux/config.toml";
    configManager.setSavePath(userConfigPath);
    bool configRecoveredFromCorruption = false;

    if (!QFile::exists(userConfigPath) && !writeDefaultConfigFile(userConfigPath)) {
        return 1;
    }

    if (!configManager.loadConfig(userConfigPath)) {
        configRecoveredFromCorruption = true;
        if (!writeDefaultConfigFile(userConfigPath) || !configManager.loadConfig(userConfigPath)) {
            qWarning() << "Unable to initialize user config";
            return 1;
        }
    }

    configManager.saveConfig();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("hidManager", &hidManager);
    engine.rootContext()->setContextProperty("configManager", &configManager);
    engine.rootContext()->setContextProperty("configRecoveredFromCorruption", configRecoveredFromCorruption);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
