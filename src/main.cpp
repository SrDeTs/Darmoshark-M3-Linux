#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QCoreApplication>
#include "hidmanager.h"
#include "configmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("Darmoshark");
    app.setApplicationName("Darmoshark M3 Configurator");

    HidManager hidManager;
    hidManager.scanDevices(); // Scan and auto-connect on startup
    ConfigManager configManager;
    QString configPath = "config.toml";
    if (!QFile::exists(configPath)) {
        // Try application dir
        configPath = QCoreApplication::applicationDirPath() + "/config.toml";
    }
    if (!QFile::exists(configPath)) {
        // Try parent of application dir (common for build folder runs)
        configPath = QCoreApplication::applicationDirPath() + "/../config.toml";
    }
    
    configManager.loadConfig(configPath);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("hidManager", &hidManager);
    engine.rootContext()->setContextProperty("configManager", &configManager);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
