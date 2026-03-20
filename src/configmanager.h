#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <toml++/toml.hpp>

class ConfigManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList dpiStages READ dpiStages NOTIFY dpiStagesChanged)

public:
    explicit ConfigManager(QObject *parent = nullptr);

    Q_INVOKABLE bool loadConfig(const QString &path);
    Q_INVOKABLE bool saveConfig(const QString &path);

    QVariantList dpiStages() const;
    Q_INVOKABLE void setDpiValue(int index, int value);
    Q_INVOKABLE void setDpiColor(int index, const QString &color);

signals:
    void dpiStagesChanged();

private:
    toml::table m_config;
};
