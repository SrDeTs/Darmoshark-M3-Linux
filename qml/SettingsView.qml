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

    function applyFactoryReset() {
        if (!configManager.resetToDefaults())
            return

        if (typeof hidManager !== "undefined" && hidManager.deviceConnected) {
            hidManager.applyDpi(configManager.dpiStages, configManager.dpiCurrentStage)
            hidManager.applySettings(configManager.pollingRate)
            hidManager.applyRipple(configManager.rippleEnabled)
            hidManager.applyMotionSync(configManager.motionSyncEnabled)
            hidManager.applyAngleSnap(configManager.angleSnapEnabled)
            hidManager.applyLiftOffDistance(!configManager.liftOffHigh)
            hidManager.applyScrollDirection(configManager.scrollNormal)
            hidManager.applyESportsMode(configManager.esportsOpen)
        }
    }

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

                onClicked: resetConfirmPopup.open()
            }
        }
    }

    Popup {
        id: resetConfirmPopup
        anchors.centerIn: Overlay.overlay
        width: 360
        height: 220
        modal: true
        focus: true
        padding: 0
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        enter: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 160; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale"; from: 0.94; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
            }
        }

        exit: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 120; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale"; from: 1.0; to: 0.96; duration: 120; easing.type: Easing.OutCubic }
            }
        }

        background: Rectangle {
            radius: 24
            color: cardColor
            border.color: cardBorder
            border.width: 2
        }

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 0

            Text {
                text: "Resetar configurações?"
                color: textPrimary
                font.pixelSize: 24
                font.family: titleFont
                font.weight: Font.Medium
            }

            Item { Layout.preferredHeight: 14 }

            Text {
                Layout.fillWidth: true
                text: "Isso vai restaurar DPI, polling rate e outras opções para os valores padrão."
                color: textSecondary
                font.pixelSize: 14
                font.family: bodyFont
                wrapMode: Text.WordWrap
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    text: "Cancelar"

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

                    onClicked: resetConfirmPopup.close()
                }

                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    text: "Confirmar"

                    background: Rectangle {
                        radius: 12
                        color: accent
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#101114"
                        font.pixelSize: 14
                        font.family: titleFont
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        resetConfirmPopup.close()
                        pageRoot.applyFactoryReset()
                    }
                }
            }
        }
    }
}
