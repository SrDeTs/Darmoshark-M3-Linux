#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <toml++/toml.hpp>

class ConfigManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList dpiStages READ dpiStages NOTIFY dpiStagesChanged)
    Q_PROPERTY(int dpiCurrentStage READ dpiCurrentStage WRITE setDpiCurrentStage NOTIFY configChanged)
    Q_PROPERTY(int pollingRate READ pollingRate WRITE setPollingRate NOTIFY configChanged)
    Q_PROPERTY(bool rippleEnabled READ rippleEnabled WRITE setRippleEnabled NOTIFY configChanged)
    Q_PROPERTY(bool motionSyncEnabled READ motionSyncEnabled WRITE setMotionSyncEnabled NOTIFY configChanged)
    Q_PROPERTY(bool angleSnapEnabled READ angleSnapEnabled WRITE setAngleSnapEnabled NOTIFY configChanged)
    Q_PROPERTY(bool liftOffHigh READ liftOffHigh WRITE setLiftOffHigh NOTIFY configChanged)
    Q_PROPERTY(bool scrollNormal READ scrollNormal WRITE setScrollNormal NOTIFY configChanged)
    Q_PROPERTY(bool esportsOpen READ esportsOpen WRITE setESportsOpen NOTIFY configChanged)
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY configChanged)
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY configChanged)
    Q_PROPERTY(bool autoStartEnabled READ autoStartEnabled WRITE setAutoStartEnabled NOTIFY configChanged)
    Q_PROPERTY(bool minimizeToTrayEnabled READ minimizeToTrayEnabled WRITE setMinimizeToTrayEnabled NOTIFY configChanged)
    Q_PROPERTY(bool startMinimizedEnabled READ startMinimizedEnabled WRITE setStartMinimizedEnabled NOTIFY configChanged)

public:
    explicit ConfigManager(QObject *parent = nullptr);

    Q_INVOKABLE bool loadConfig(const QString &path);
    Q_INVOKABLE bool saveConfig();
    Q_INVOKABLE void setSavePath(const QString &path);
    Q_INVOKABLE bool resetToDefaults();

    QVariantList dpiStages() const;
    int dpiCurrentStage() const;
    int pollingRate() const;
    bool rippleEnabled() const;
    bool motionSyncEnabled() const;
    bool angleSnapEnabled() const;
    bool liftOffHigh() const;
    bool scrollNormal() const;
    bool esportsOpen() const;
    QString theme() const;
    QString language() const;
    bool autoStartEnabled() const;
    bool minimizeToTrayEnabled() const;
    bool startMinimizedEnabled() const;

    Q_INVOKABLE void setDpiCurrentStage(int stage);
    Q_INVOKABLE void setPollingRate(int rate);
    Q_INVOKABLE void setRippleEnabled(bool enabled);
    Q_INVOKABLE void setMotionSyncEnabled(bool enabled);
    Q_INVOKABLE void setAngleSnapEnabled(bool enabled);
    Q_INVOKABLE void setLiftOffHigh(bool high);
    Q_INVOKABLE void setScrollNormal(bool normal);
    Q_INVOKABLE void setESportsOpen(bool open);
    Q_INVOKABLE void setTheme(const QString &theme);
    Q_INVOKABLE void setLanguage(const QString &language);
    Q_INVOKABLE bool setAutoStartEnabled(bool enabled);
    Q_INVOKABLE void setMinimizeToTrayEnabled(bool enabled);
    Q_INVOKABLE void setStartMinimizedEnabled(bool enabled);
    Q_INVOKABLE void setDpiValue(int index, int value);
    Q_INVOKABLE void setDpiColor(int index, const QString &color);

signals:
    void dpiStagesChanged();
    void configChanged();

private:
    void ensureUiTable();
    void ensureDpiTable();
    bool updateAutostartFile(bool enabled);

    toml::table m_config;
    QString m_savePath;
};
