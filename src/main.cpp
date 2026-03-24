#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QFileInfo>
#include <QCoreApplication>
#include <QDir>
#include <QLockFile>
#include <QMessageLogContext>
#include <QStandardPaths>
#include <QTextStream>
#include <QUrl>
#include <QWindow>
#include <QFont>
#include <QFontDatabase>
#include <QByteArray>
#include "hidmanager.h"
#include "configmanager.h"
#include "appcontroller.h"

static bool g_verboseLogging = false;

static void appMessageHandler(QtMsgType type, const QMessageLogContext &context, const QString &message)
{
    if (type == QtDebugMsg && !g_verboseLogging)
        return;

    QByteArray local = message.toLocal8Bit();
    FILE *stream = (type == QtWarningMsg || type == QtCriticalMsg || type == QtFatalMsg) ? stderr : stdout;

    switch (type) {
    case QtDebugMsg:
        fprintf(stream, "%s\n", local.constData());
        break;
    case QtInfoMsg:
        fprintf(stream, "%s\n", local.constData());
        break;
    case QtWarningMsg:
        fprintf(stream, "%s\n", local.constData());
        break;
    case QtCriticalMsg:
        fprintf(stream, "%s\n", local.constData());
        break;
    case QtFatalMsg:
        fprintf(stream, "%s\n", local.constData());
        fflush(stream);
        abort();
    }

    Q_UNUSED(context);
    fflush(stream);
}

static void printHelp()
{
    QTextStream out(stdout);
    out
        << "Darmoshark M3 " << QStringLiteral(APP_VERSION) << Qt::endl
        << Qt::endl
        << "Uso:" << Qt::endl
        << "  DarmosharkM3 [opcoes]" << Qt::endl
        << Qt::endl
        << "Opcoes:" << Qt::endl
        << "  --help, -h              Mostra esta ajuda" << Qt::endl
        << "  --version, -v           Mostra a versao do app" << Qt::endl
        << "  --verbose               Liga logs detalhados" << Qt::endl
        << "  --minimize-systray      Inicia minimizado na bandeja" << Qt::endl
        << "  --config <arquivo>      Usa um config.toml alternativo" << Qt::endl;
}

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
        "theme = \"Dark\"\n"
        "language = \"pt-BR\"\n"
        "auto_start_enabled = false\n"
        "minimize_to_tray_enabled = false\n"
        "start_minimized_enabled = false\n"
        "battery_alerts_enabled = true\n"
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
    bool startMinimizedToTray = false;
    QString customConfigPath;

    for (int i = 1; i < argc; ++i) {
        const QString argument = QString::fromLocal8Bit(argv[i]);
        if (argument == QStringLiteral("--help") || argument == QStringLiteral("-h")) {
            printHelp();
            return 0;
        }
        if (argument == QStringLiteral("--version") || argument == QStringLiteral("-v")) {
            QTextStream out(stdout);
            out << "Darmoshark M3 " << QStringLiteral(APP_VERSION) << Qt::endl;
            return 0;
        }
        if (argument == QStringLiteral("--verbose")) {
            g_verboseLogging = true;
            continue;
        }
        if (argument == QStringLiteral("--minimize-systray")) {
            startMinimizedToTray = true;
            continue;
        }
        if (argument == QStringLiteral("--config")) {
            if (i + 1 >= argc) {
                QTextStream err(stderr);
                err << "--config exige um caminho de arquivo" << Qt::endl;
                return 1;
            }
            customConfigPath = QString::fromLocal8Bit(argv[++i]);
            continue;
        }
        if (argument.startsWith(QStringLiteral("--config="))) {
            customConfigPath = argument.mid(QStringLiteral("--config=").size());
            continue;
        }
    }

    qInstallMessageHandler(appMessageHandler);

    const QByteArray platformTheme = qgetenv("QT_QPA_PLATFORMTHEME").trimmed();
    if (platformTheme == "qt6ct") {
        qunsetenv("QT_QPA_PLATFORMTHEME");
    }

    QApplication app(argc, argv);

    QFont appFont = app.font();
    if (appFont.family().trimmed().isEmpty()) {
        const QStringList families = QFontDatabase::families();
        const QString fallbackFamily = families.contains(QStringLiteral("Inter"))
            ? QStringLiteral("Inter")
            : QStringLiteral("Sans Serif");
        appFont.setFamily(fallbackFamily);
    }
    app.setFont(appFont);

    app.setOrganizationName("Darmoshark");
    app.setApplicationName("Darmoshark M3");
    app.setApplicationVersion(QStringLiteral(APP_VERSION));

    QString lockDirectory = QStandardPaths::writableLocation(QStandardPaths::RuntimeLocation);
    if (lockDirectory.isEmpty())
        lockDirectory = QDir::tempPath();

    QDir().mkpath(lockDirectory);

    QLockFile singleInstanceLock(lockDirectory + "/DarmosharkM3.lock");
    singleInstanceLock.setStaleLockTime(0);
    if (!singleInstanceLock.tryLock(100)) {
        qInfo() << "Darmoshark M3 is already running";
        return 0;
    }

    ConfigManager configManager;
    AppController appController;
    appController.setConfigManager(&configManager);
    HidManager hidManager;
    hidManager.setConfigManager(&configManager);
    appController.setHidManager(&hidManager);

    QString userConfigPath = customConfigPath.isEmpty()
        ? QDir::homePath() + "/.config/Darmoshark M3 Linux/config.toml"
        : customConfigPath;
    configManager.setSavePath(userConfigPath);
    const QString configDirectoryPath = QFileInfo(userConfigPath).absolutePath();
    const QUrl configDirectoryUrl = QUrl::fromLocalFile(configDirectoryPath);
    bool configCreatedFirstRun = false;
    bool configRecoveredFromCorruption = false;

    if (!QFile::exists(userConfigPath)) {
        configCreatedFirstRun = true;
        if (!writeDefaultConfigFile(userConfigPath)) {
            return 1;
        }
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
    engine.rootContext()->setContextProperty("appController", &appController);
    engine.rootContext()->setContextProperty("appVersion", app.applicationVersion());
    engine.rootContext()->setContextProperty("configDirectoryUrl", configDirectoryUrl);
    engine.rootContext()->setContextProperty("configCreatedFirstRun", configCreatedFirstRun);
    engine.rootContext()->setContextProperty("configRecoveredFromCorruption", configRecoveredFromCorruption);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    if (!engine.rootObjects().isEmpty()) {
        appController.setMainWindow(qobject_cast<QWindow *>(engine.rootObjects().constFirst()));
    }

    const bool shouldStartMinimized = (startMinimizedToTray || configManager.startMinimizedEnabled()) && appController.trayAvailable();

    if (shouldStartMinimized)
        appController.hideToTray(false);

    QTimer::singleShot(0, &hidManager, &HidManager::scanDevices);

    return app.exec();
}
