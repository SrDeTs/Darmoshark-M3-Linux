import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components"
import "idiomas/I18n.js" as I18n

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
    property var languageItems: [
        { value: "pt-BR", label: I18n.tr(configManager.language, "settings.language_pt_br") },
        { value: "en-US", label: I18n.tr(configManager.language, "settings.language_en_us") }
    ]
    property var themeItems: [
        { value: "Dark", label: I18n.tr(configManager.language, "settings.theme_dark") },
        { value: "White", label: I18n.tr(configManager.language, "settings.theme_white") }
    ]

    component SettingsComboBox: ComboBox {
        id: comboRoot
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        textRole: "label"

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
                text: typeof modelData === "object" ? modelData[comboRoot.textRole] : modelData
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

            function positionToRectangle() {
                return Qt.rect(0, 0, 0, 0)
            }
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
        width: 430
        height: 620
        anchors.left: parent.left
        anchors.leftMargin: 240
        anchors.top: parent.top
        anchors.topMargin: 185
        radius: 28
        color: cardColor
        border.color: cardBorder
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            anchors.topMargin: 24
            anchors.bottomMargin: 32
            spacing: 0

            Text {
                text: I18n.tr(configManager.language, "settings.general")
                color: textPrimary
                font.pixelSize: 24
                font.family: titleFont
                font.weight: Font.Medium
            }

            Item { Layout.preferredHeight: 22 }

            Text {
                text: I18n.tr(configManager.language, "settings.app_updates")
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 6 }

            Text {
                Layout.fillWidth: true
                text: I18n.tr(configManager.language, "settings.app_updates_desc")
                color: textMuted
                font.pixelSize: 13
                font.family: bodyFont
                wrapMode: Text.WordWrap
            }

            Item { Layout.preferredHeight: 22 }

            Text {
                text: I18n.tr(configManager.language, "settings.language")
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 10 }

            SettingsComboBox {
                id: languageSelector
                model: pageRoot.languageItems
                currentIndex: I18n.languageCode(configManager.language) === "en-US" ? 1 : 0

                onActivated: function(index) {
                    configManager.setLanguage(pageRoot.languageItems[index].value)
                }
            }

            Item { Layout.preferredHeight: 18 }

            Text {
                text: I18n.tr(configManager.language, "settings.theme")
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 10 }

            SettingsComboBox {
                id: themeSelector
                model: pageRoot.themeItems
                currentIndex: configManager.theme === "White" ? 1 : 0

                onActivated: function(index) {
                    configManager.setTheme(pageRoot.themeItems[index].value)
                }
            }

            Item { Layout.preferredHeight: 24 }

            Text {
                text: I18n.tr(configManager.language, "settings.startup")
                color: textPrimary
                font.pixelSize: 16
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 14 }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                Text {
                    text: I18n.tr(configManager.language, "settings.auto_start")
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                    verticalAlignment: Text.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                SettingsSwitch {
                    checked: configManager.autoStartEnabled
                    onToggled: configManager.setAutoStartEnabled(checked)
                }
            }

            Item { Layout.preferredHeight: 12 }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                Text {
                    text: I18n.tr(configManager.language, "settings.minimize_to_tray")
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                    verticalAlignment: Text.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                SettingsSwitch {
                    checked: configManager.minimizeToTrayEnabled
                    onToggled: configManager.setMinimizeToTrayEnabled(checked)
                }
            }

            Item { Layout.preferredHeight: 12 }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                Text {
                    text: I18n.tr(configManager.language, "settings.start_minimized")
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                    verticalAlignment: Text.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                SettingsSwitch {
                    checked: configManager.startMinimizedEnabled
                    onToggled: configManager.setStartMinimizedEnabled(checked)
                }
            }

            Item { Layout.preferredHeight: 12 }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                Text {
                    text: I18n.tr(configManager.language, "settings.battery_alerts")
                    color: textPrimary
                    font.pixelSize: 14
                    font.family: bodyFont
                    verticalAlignment: Text.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                SettingsSwitch {
                    checked: configManager.batteryAlertsEnabled
                    onToggled: configManager.setBatteryAlertsEnabled(checked)
                }
            }

            Item { Layout.fillHeight: true; Layout.minimumHeight: 12 }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                text: I18n.tr(configManager.language, "settings.reset")

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

        onVisibleChanged: function() {
            if (pageRoot.Window.window)
                pageRoot.Window.window.modalBlurActive = visible
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
                text: I18n.tr(configManager.language, "settings.reset_title")
                color: textPrimary
                font.pixelSize: 24
                font.family: titleFont
                font.weight: Font.Medium
            }

            Item { Layout.preferredHeight: 14 }

            Text {
                Layout.fillWidth: true
                text: I18n.tr(configManager.language, "settings.reset_desc")
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
                    text: I18n.tr(configManager.language, "settings.cancel")

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
                    text: I18n.tr(configManager.language, "settings.confirm")

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
