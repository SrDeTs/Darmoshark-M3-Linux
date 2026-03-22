import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color cardColor: "#191a1a"
    property color cardBorder: "#1f2020"
    property color fieldColor: "#2b2c2c"
    property color textPrimary: "#e7e5e5"
    property color textSecondary: "#a1afc6"
    property color textMuted: "#8b8f98"
    property color accent: "#a7c8ff"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    property bool autoStartEnabled: false
    property bool minimizeToTrayEnabled: false
    property string selectedLanguage: "English"

    Rectangle {
        width: 360
        height: 470
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 90
        radius: 28
        color: cardColor
        border.color: cardBorder
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 0

            Text {
                text: "General Settings"
                color: textPrimary
                font.pixelSize: 24
                font.family: titleFont
                font.weight: Font.Medium
            }

            Item { Layout.preferredHeight: 24 }

            Text {
                text: "App Updates"
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 6 }

            Text {
                Layout.fillWidth: true
                text: "App updates and release reminders will be added in a future update."
                color: textMuted
                font.pixelSize: 13
                font.family: bodyFont
                wrapMode: Text.WordWrap
            }

            Item { Layout.preferredHeight: 24 }

            Text {
                text: "Language"
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 10 }

            ComboBox {
                id: languageSelector
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                model: ["English"]
                currentIndex: 0

                background: Rectangle {
                    radius: 12
                    color: fieldColor
                }

                contentItem: Text {
                    leftPadding: 14
                    rightPadding: 32
                    text: languageSelector.displayText
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Item { Layout.preferredHeight: 28 }

            Text {
                text: "Startup settings"
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 18 }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Auto-Start"
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                }

                Item { Layout.fillWidth: true }

                Switch {
                    checked: autoStartEnabled
                    onToggled: autoStartEnabled = checked
                }
            }

            Item { Layout.preferredHeight: 10 }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Minimize to Tray"
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                }

                Item { Layout.fillWidth: true }

                Switch {
                    checked: minimizeToTrayEnabled
                    onToggled: minimizeToTrayEnabled = checked
                }
            }

            Item { Layout.fillHeight: true }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                text: "Reset to Factory Defaults"

                background: Rectangle {
                    radius: 12
                    color: fieldColor
                }

                contentItem: Text {
                    text: parent.text
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: titleFont
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
