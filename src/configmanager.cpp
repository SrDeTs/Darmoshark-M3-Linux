#include "configmanager.h"
#include <fstream>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QTextStream>
#include <QString>
#include <QVariantList>
#include <QVariantMap>
#include <QCoreApplication>
#include <QStandardPaths>
#include <string>

ConfigManager::ConfigManager(QObject *parent)
    : QObject(parent)
{
}

static toml::table buildDefaultConfig()
{
    toml::table config;

    toml::table device;
    device.insert_or_assign(std::string("name"), std::string("Darmoshark M3"));
    device.insert_or_assign(std::string("vid"), (int64_t)0x248A);
    device.insert_or_assign(std::string("pid"), (int64_t)0xFF12);

    toml::table dpi;
    dpi.insert_or_assign(std::string("current_stage"), (int64_t)1);
    dpi.insert_or_assign(std::string("stages"), toml::array{ 400, 800, 1600, 3200, 4800 });

    toml::table ui;
    ui.insert_or_assign(std::string("polling_rate"), (int64_t)1000);
    ui.insert_or_assign(std::string("ripple_enabled"), false);
    ui.insert_or_assign(std::string("motion_sync_enabled"), true);
    ui.insert_or_assign(std::string("angle_snap_enabled"), false);
    ui.insert_or_assign(std::string("lift_off_high"), false);
    ui.insert_or_assign(std::string("scroll_normal"), true);
    ui.insert_or_assign(std::string("esports_open"), false);
    ui.insert_or_assign(std::string("theme"), std::string("Dark"));
    ui.insert_or_assign(std::string("language"), std::string("pt-BR"));
    ui.insert_or_assign(std::string("auto_start_enabled"), false);
    ui.insert_or_assign(std::string("minimize_to_tray_enabled"), false);

    toml::table buttons;
    buttons.insert_or_assign(std::string("left"), std::string("Left-Click"));
    buttons.insert_or_assign(std::string("right"), std::string("Right-Click"));
    buttons.insert_or_assign(std::string("middle"), std::string("Middle-Click"));
    buttons.insert_or_assign(std::string("forward"), std::string("Forward"));
    buttons.insert_or_assign(std::string("backward"), std::string("Backward"));

    config.insert_or_assign(std::string("device"), std::move(device));
    config.insert_or_assign(std::string("dpi"), std::move(dpi));
    config.insert_or_assign(std::string("ui"), std::move(ui));
    config.insert_or_assign(std::string("buttons"), std::move(buttons));

    return config;
}

static toml::array *ensureStageConfigsArray(toml::table &config)
{
    auto *dpiTable = config["dpi"].as_table();
    if (!dpiTable) {
        config.insert_or_assign(std::string("dpi"), toml::table{});
        dpiTable = config["dpi"].as_table();
    }

    auto *stageConfigs = (*dpiTable)["stage_configs"].as_array();
    if (stageConfigs)
        return stageConfigs;

    toml::array migratedConfigs;
    auto *legacyStages = (*dpiTable)["stages"].as_array();
    if (legacyStages) {
        for (auto &item : *legacyStages) {
            toml::table stageConfig;
            stageConfig.insert_or_assign(
                std::string("value"),
                item.as_integer() ? item.as_integer()->get() : static_cast<int64_t>(0)
            );
            stageConfig.insert_or_assign(std::string("color"), std::string("#ffffff"));
            migratedConfigs.push_back(std::move(stageConfig));
        }
    }

    dpiTable->insert_or_assign(std::string("stage_configs"), std::move(migratedConfigs));
    return (*dpiTable)["stage_configs"].as_array();
}

static QString desktopEntryTemplate()
{
    return QStringLiteral(
        "[Desktop Entry]\n"
        "Type=Application\n"
        "Name=Darmoshark M3\n"
        "Comment=Configure Darmoshark M3 series mice on Linux\n"
        "Exec=DarmosharkM3\n"
        "Icon=com.darmoshark.m3\n"
        "Terminal=false\n"
        "Categories=Settings;Utility;\n"
        "StartupNotify=true\n"
    );
}

static QString resolveInstalledDesktopEntryPath()
{
    const QString desktopFileName = QStringLiteral("com.darmoshark.m3.desktop");
    const QStringList appLocations = QStandardPaths::standardLocations(QStandardPaths::ApplicationsLocation);

    for (const QString &location : appLocations) {
        const QString candidate = QDir(location).filePath(desktopFileName);
        if (QFile::exists(candidate))
            return candidate;
    }

    const QStringList fallbackLocations = {
        QStringLiteral("/usr/local/share/applications"),
        QStringLiteral("/usr/share/applications")
    };

    for (const QString &location : fallbackLocations) {
        const QString candidate = QDir(location).filePath(desktopFileName);
        if (QFile::exists(candidate))
            return candidate;
    }

    return QString();
}

bool ConfigManager::loadConfig(const QString &path)
{
    try {
        m_config = toml::parse_file(path.toStdString());
        emit dpiStagesChanged();
        emit configChanged();
        return true;
    } catch (const toml::parse_error &err) {
        qWarning() << "Failed to load config:" << err.description().data();
        return false;
    }
}

bool ConfigManager::saveConfig()
{
    if (m_savePath.isEmpty()) {
        qWarning() << "Cannot save config: no save path set";
        return false;
    }

    QFileInfo info(m_savePath);
    QDir dir = info.dir();
    if (!dir.exists()) {
        if (!QDir().mkpath(dir.absolutePath())) {
            qWarning() << "Cannot create config directory:" << dir.absolutePath();
            return false;
        }
    }

    std::ofstream file(m_savePath.toStdString());
    if (file.is_open()) {
        file << m_config;
        return true;
    }
    return false;
}

void ConfigManager::setSavePath(const QString &path)
{
    m_savePath = path;
}

bool ConfigManager::resetToDefaults()
{
    m_config = buildDefaultConfig();
    emit dpiStagesChanged();
    emit configChanged();
    return saveConfig();
}

void ConfigManager::ensureDpiTable()
{
    if (!m_config["dpi"].as_table()) {
        m_config.insert_or_assign(std::string("dpi"), toml::table{});
    }
}

void ConfigManager::ensureUiTable()
{
    if (!m_config["ui"].as_table()) {
        m_config.insert_or_assign(std::string("ui"), toml::table{});
    }
}

QVariantList ConfigManager::dpiStages() const
{
    QVariantList list;
    auto stageConfigs = m_config["dpi"]["stage_configs"].as_array();
    
    QStringList defaultColors = {"#ff0000", "#0000ff", "#00ff00", "#ff00ff", "#00ffff", "#ffff00", "#ffaa00"};
    
    if (stageConfigs) {
        int i = 0;
        for (auto& node : *stageConfigs) {
            auto* table = node.as_table();
            if (table) {
                QVariantMap map;
                map["value"] = (int)(*table)["value"].as_integer()->value_or((int64_t)0);
                if (auto colorStr = (*table)["color"].as_string()) {
                    map["color"] = QString::fromStdString(colorStr->get());
                } else {
                    map["color"] = defaultColors.value(i % defaultColors.size());
                }
                list << map;
                i++;
            }
        }
    } else {
        // Fallback to legacy stages if stage_configs doesn't exist yet
        auto stages = m_config["dpi"]["stages"].as_array();
        if (stages) {
            int i = 0;
            for (auto& node : *stages) {
                QVariantMap map;
                map["value"] = (int)node.as_integer()->value_or((int64_t)0);
                map["color"] = defaultColors.value(i % defaultColors.size());
                list << map;
                i++;
            }
        }
    }
    return list;
}

int ConfigManager::dpiCurrentStage() const
{
    auto *dpiTable = m_config["dpi"].as_table();
    if (!dpiTable) return 0;

    auto *stageNode = (*dpiTable)["current_stage"].as_integer();
    if (!stageNode) return 0;

    int oneBased = (int)stageNode->value_or((int64_t)1);
    return qMax(0, oneBased - 1);
}

int ConfigManager::pollingRate() const
{
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return 1000;

    auto *node = (*uiTable)["polling_rate"].as_integer();
    return node ? (int)node->value_or((int64_t)1000) : 1000;
}

bool ConfigManager::rippleEnabled() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["ripple_enabled"].as_boolean() : nullptr;
    return node ? node->value_or(false) : false;
}

bool ConfigManager::motionSyncEnabled() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["motion_sync_enabled"].as_boolean() : nullptr;
    return node ? node->value_or(true) : true;
}

bool ConfigManager::angleSnapEnabled() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["angle_snap_enabled"].as_boolean() : nullptr;
    return node ? node->value_or(false) : false;
}

bool ConfigManager::liftOffHigh() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["lift_off_high"].as_boolean() : nullptr;
    return node ? node->value_or(false) : false;
}

bool ConfigManager::scrollNormal() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["scroll_normal"].as_boolean() : nullptr;
    return node ? node->value_or(true) : true;
}

bool ConfigManager::esportsOpen() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["esports_open"].as_boolean() : nullptr;
    return node ? node->value_or(false) : false;
}

QString ConfigManager::theme() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["theme"].as_string() : nullptr;
    return node ? QString::fromStdString(node->get()) : QStringLiteral("Dark");
}

QString ConfigManager::language() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["language"].as_string() : nullptr;
    if (!node)
        return QStringLiteral("pt-BR");

    const QString value = QString::fromStdString(node->get());
    if (value == QStringLiteral("English") || value == QStringLiteral("en-US") || value == QStringLiteral("Inglês"))
        return QStringLiteral("en-US");
    if (value == QStringLiteral("Português (Brasil)") || value == QStringLiteral("Portuguese (Brazil)") || value == QStringLiteral("pt-BR"))
        return QStringLiteral("pt-BR");
    return QStringLiteral("pt-BR");
}

bool ConfigManager::autoStartEnabled() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["auto_start_enabled"].as_boolean() : nullptr;
    return node ? node->value_or(false) : false;
}

bool ConfigManager::minimizeToTrayEnabled() const
{
    auto *uiTable = m_config["ui"].as_table();
    auto *node = uiTable ? (*uiTable)["minimize_to_tray_enabled"].as_boolean() : nullptr;
    return node ? node->value_or(false) : false;
}

void ConfigManager::setDpiCurrentStage(int stage)
{
    ensureDpiTable();
    auto *dpiTable = m_config["dpi"].as_table();
    if (!dpiTable) return;
    int stored = qMax(1, stage + 1);
    dpiTable->insert_or_assign(std::string("current_stage"), (int64_t)stored);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setPollingRate(int rate)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("polling_rate"), (int64_t)rate);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setRippleEnabled(bool enabled)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("ripple_enabled"), enabled);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setMotionSyncEnabled(bool enabled)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("motion_sync_enabled"), enabled);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setAngleSnapEnabled(bool enabled)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("angle_snap_enabled"), enabled);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setLiftOffHigh(bool high)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("lift_off_high"), high);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setScrollNormal(bool normal)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    qDebug() << "ConfigManager::setScrollNormal" << normal;
    uiTable->insert_or_assign(std::string("scroll_normal"), normal);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setESportsOpen(bool open)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("esports_open"), open);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setTheme(const QString &theme)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("theme"), theme.toStdString());
    emit configChanged();
    saveConfig();
}

void ConfigManager::setLanguage(const QString &language)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;

    QString normalized = QStringLiteral("pt-BR");
    if (language == QStringLiteral("English") || language == QStringLiteral("en-US") || language == QStringLiteral("Inglês")) {
        normalized = QStringLiteral("en-US");
    } else if (language == QStringLiteral("Português (Brasil)") || language == QStringLiteral("Portuguese (Brazil)") || language == QStringLiteral("pt-BR")) {
        normalized = QStringLiteral("pt-BR");
    }

    uiTable->insert_or_assign(std::string("language"), normalized.toStdString());
    emit configChanged();
    saveConfig();
}

bool ConfigManager::updateAutostartFile(bool enabled)
{
    const QString autostartDir = QDir::homePath() + QStringLiteral("/.config/autostart");
    const QString desktopFilePath = autostartDir + QStringLiteral("/com.darmoshark.m3.desktop");

    if (!enabled) {
        if (QFile::exists(desktopFilePath))
            return QFile::remove(desktopFilePath);
        return true;
    }

    if (!QDir().mkpath(autostartDir))
        return false;

    QFile file(desktopFilePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text))
        return false;

    QTextStream out(&file);
    const QString installedDesktopEntryPath = resolveInstalledDesktopEntryPath();
    if (!installedDesktopEntryPath.isEmpty()) {
        QFile desktopEntryFile(installedDesktopEntryPath);
        if (desktopEntryFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
            out << desktopEntryFile.readAll();
            if (!out.atEnd())
                out << "\n";
        } else {
            out << desktopEntryTemplate();
        }
    } else {
        out << desktopEntryTemplate();
    }

    out << "X-GNOME-Autostart-enabled=true\n";
    return true;
}

bool ConfigManager::setAutoStartEnabled(bool enabled)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return false;
    if (!updateAutostartFile(enabled))
        return false;
    uiTable->insert_or_assign(std::string("auto_start_enabled"), enabled);
    emit configChanged();
    return saveConfig();
}

void ConfigManager::setMinimizeToTrayEnabled(bool enabled)
{
    ensureUiTable();
    auto *uiTable = m_config["ui"].as_table();
    if (!uiTable) return;
    uiTable->insert_or_assign(std::string("minimize_to_tray_enabled"), enabled);
    emit configChanged();
    saveConfig();
}

void ConfigManager::setDpiValue(int index, int value)
{
    auto *stageConfigs = ensureStageConfigsArray(m_config);

    if (stageConfigs && index >= 0 && index < (int)stageConfigs->size()) {
        auto* table = (*stageConfigs)[index].as_table();
        if (table) {
            table->insert_or_assign(std::string("value"), (int64_t)value);
            emit dpiStagesChanged();
            saveConfig();
        }
    }
}

void ConfigManager::setDpiColor(int index, const QString &color)
{
    auto *stageConfigs = ensureStageConfigsArray(m_config);
    if (stageConfigs && index >= 0 && index < (int)stageConfigs->size()) {
        auto* table = (*stageConfigs)[index].as_table();
        if (table) {
            table->insert_or_assign(std::string("color"), color.toStdString());
            emit dpiStagesChanged();
            saveConfig();
        }
    }
}
