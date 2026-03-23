import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

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

    component SettingsComboBox: ComboBox {
        id: comboRoot
        Layout.fillWidth: true
        Layout.preferredHeight: 40

        delegate: ItemDelegate {
            width: ListView.view ? ListView.view.width : comboRoot.width
            height: 40
            highlighted: comboRoot.highlightedIndex === index
            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0
            background: Rectangle {
                color: highlighted ? Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.12) : "transparent"
                radius: 10
            }
            contentItem: Text {
                leftPadding: 12
                rightPadding: 12
                text: modelData
                color: textPrimary
                font.pixelSize: 14
                font.family: bodyFont
                verticalAlignment: Text.AlignVCenter
            }
        }

        indicator: Canvas {
            x: comboRoot.width - width - 14
            y: (comboRoot.height - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            onPaint: {
                context.reset()
                context.moveTo(1, 1)
                context.lineTo(width / 2, height - 1)
                context.lineTo(width - 1, 1)
                context.lineWidth = 1.6
                context.strokeStyle = textSecondary
                context.stroke()
            }
        }

        contentItem: Text {
            leftPadding: 14
            rightPadding: 34
            text: comboRoot.displayText
            color: textPrimary
            font.pixelSize: 14
            font.family: bodyFont
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            radius: 12
            color: fieldColor
            border.color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.04)
            border.width: 1
        }

        popup: Popup {
            y: comboRoot.height + 8
            width: comboRoot.width
            padding: 0
            implicitHeight: contentItem.implicitHeight
            clip: true
            background: Rectangle {
                radius: 14
                color: "#202223"
                border.color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.06)
                border.width: 1
            }
            contentItem: Item {
                implicitHeight: popupList.implicitHeight + 12

                ListView {
                    id: popupList
                    anchors.fill: parent
                    anchors.margins: 6
                    clip: true
                    implicitHeight: contentHeight
                    spacing: 4
                    model: comboRoot.popup.visible ? comboRoot.delegateModel : null
                    currentIndex: comboRoot.highlightedIndex
                }
            }
        }
    }

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
        height: 520
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 32
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

            Item { Layout.preferredHeight: 22 }

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

            Item { Layout.preferredHeight: 22 }

            Text {
                text: "Language"
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 10 }

            SettingsComboBox {
                id: languageSelector
                model: ["English"]
                currentIndex: Math.max(0, model.indexOf(configManager.language))

                onActivated: configManager.setLanguage(languageSelector.currentText)
            }

            Item { Layout.preferredHeight: 18 }

            Text {
                text: "Theme"
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 10 }

            SettingsComboBox {
                id: themeSelector
                model: ["Dark", "White"]
                currentIndex: Math.max(0, model.indexOf(configManager.theme))

                onActivated: configManager.setTheme(themeSelector.currentText)
            }

            Item { Layout.preferredHeight: 24 }

            Text {
                text: "Startup settings"
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 14 }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                Text {
                    text: "Auto-Start"
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                    verticalAlignment: Text.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Switch {
                    checked: configManager.autoStartEnabled
                    onToggled: configManager.setAutoStartEnabled(checked)
                }
            }

            Item { Layout.preferredHeight: 12 }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                Text {
                    text: "Minimize to Tray"
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                    verticalAlignment: Text.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Switch {
                    checked: configManager.minimizeToTrayEnabled
                    onToggled: configManager.setMinimizeToTrayEnabled(checked)
                }
            }

            Item { Layout.fillHeight: true; Layout.minimumHeight: 20 }

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

        onVisibleChanged: {
            if (Window.window)
                Window.window.modalBlurActive = visible
        }

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
