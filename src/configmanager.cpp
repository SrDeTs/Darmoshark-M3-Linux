#include "configmanager.h"
#include <fstream>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QVariantList>
#include <QVariantMap>
#include <string>

ConfigManager::ConfigManager(QObject *parent)
    : QObject(parent)
{
}

bool ConfigManager::loadConfig(const QString &path)
{
    try {
        m_config = toml::parse_file(path.toStdString());
        emit dpiStagesChanged();
        return true;
    } catch (const toml::parse_error &err) {
        qWarning() << "Failed to load config:" << err.description().data();
        return false;
    }
}

bool ConfigManager::saveConfig(const QString &path)
{
    std::ofstream file(path.toStdString());
    if (file.is_open()) {
        file << m_config;
        return true;
    }
    return false;
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

void ConfigManager::setDpiValue(int index, int value)
{
    auto stageConfigs = m_config["dpi"]["stage_configs"].as_array();
    if (!stageConfigs) {
        // Migrate legacy to new format if needed
        toml::array legArr;
        auto legacyStages = m_config["dpi"]["stages"].as_array();
        if (legacyStages) {
            for (auto& item : *legacyStages) {
                toml::table t;
                t.insert_or_assign(std::string("value"), item.as_integer() ? item.as_integer()->get() : (int64_t)0);
                t.insert_or_assign(std::string("color"), std::string("#ffffff"));
                legArr.push_back(std::move(t));
            }
        }
        m_config["dpi"].as_table()->insert_or_assign(std::string("stage_configs"), std::move(legArr));
        stageConfigs = m_config["dpi"]["stage_configs"].as_array();
    }

    if (stageConfigs && index >= 0 && index < (int)stageConfigs->size()) {
        auto* table = (*stageConfigs)[index].as_table();
        if (table) {
            table->insert_or_assign(std::string("value"), (int64_t)value);
            emit dpiStagesChanged();
        }
    }
}

void ConfigManager::setDpiColor(int index, const QString &color)
{
    auto stageConfigs = m_config["dpi"]["stage_configs"].as_array();
    if (stageConfigs && index >= 0 && index < (int)stageConfigs->size()) {
        auto* table = (*stageConfigs)[index].as_table();
        if (table) {
            table->insert_or_assign(std::string("color"), color.toStdString());
            emit dpiStagesChanged();
        }
    }
}
