import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "idiomas/I18n.js" as I18n

Item {
    id: pageRoot
    clip: true

    property color cardColor: "#191a1a"
    property color cardBorder: "#1f2020"
    property color sectionColor: "#2b2c2c"
    property color textPrimary: "#f4f7ff"
    property color textSecondary: "#b2bdd1"
    property color textMuted: "#8f9ab0"
    property color accent: "#9dc0ff"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    ListModel {
        id: sensorOptions
        ListElement {
            title: ""
            statusOn: "On"
            statusOff: "Off"
            description: ""
        }
        ListElement {
            title: ""
            statusOn: "On"
            statusOff: "Off"
            description: ""
        }
        ListElement {
            title: ""
            statusOn: "On"
            statusOff: "Off"
            description: ""
        }
    }

    function optionTitle(index) {
        if (index === 0)
            return I18n.tr(configManager.language, "sensor.ripple")
        if (index === 1)
            return I18n.tr(configManager.language, "sensor.motion_sync")
        return I18n.tr(configManager.language, "sensor.angle_snap")
    }

    function optionDescription(index) {
        if (index === 0)
            return I18n.tr(configManager.language, "sensor.ripple_desc")
        if (index === 1)
            return I18n.tr(configManager.language, "sensor.motion_sync_desc")
        return I18n.tr(configManager.language, "sensor.angle_snap_desc")
    }

    function optionEnabled(index) {
        if (index === 0)
            return configManager.rippleEnabled
        if (index === 1)
            return configManager.motionSyncEnabled
        return configManager.angleSnapEnabled
    }

    function setOptionEnabled(index, checked) {
        if (index === 0) {
            configManager.setRippleEnabled(checked)
            if (typeof hidManager !== "undefined")
                hidManager.applyRipple(checked)
            return
        }
        if (index === 1) {
            configManager.setMotionSyncEnabled(checked)
            if (typeof hidManager !== "undefined")
                hidManager.applyMotionSync(checked)
            return
        }
        configManager.setAngleSnapEnabled(checked)
        if (typeof hidManager !== "undefined")
            hidManager.applyAngleSnap(checked)
    }

    Column {
        anchors.left: parent.left
        anchors.leftMargin: 48
        anchors.top: parent.top
        anchors.topMargin: 160
        spacing: 14

        Repeater {
            model: sensorOptions

            delegate: Rectangle {
                width: 230
                height: 122
                radius: 24
                color: cardColor
                border.color: cardBorder
                border.width: 2

                Column {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: pageRoot.optionTitle(index)
                        color: textPrimary
                        font.pixelSize: 20
                        font.family: titleFont
                        font.weight: Font.Medium
                    }

                    RowLayout {
                        width: parent.width
                        spacing: 12

                        SettingsSwitch {
                            checked: pageRoot.optionEnabled(index)
                            Layout.alignment: Qt.AlignVCenter
                            onToggled: pageRoot.setOptionEnabled(index, checked)
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: pageRoot.optionEnabled(index) ? I18n.tr(configManager.language, "esports.on") : I18n.tr(configManager.language, "esports.off")
                            color: pageRoot.optionEnabled(index) ? textPrimary : textMuted
                            font.pixelSize: 14
                            font.family: bodyFont
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }
            }
        }
    }

    Column {
        anchors.right: parent.right
        anchors.rightMargin: 56
        anchors.top: parent.top
        anchors.topMargin: 160
        spacing: 14

        Repeater {
            model: sensorOptions

            delegate: Rectangle {
                width: 230
                height: 122
                radius: 24
                color: cardColor
                border.color: cardBorder
                border.width: 2

                Column {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.topMargin: 14
                    anchors.bottomMargin: 14
                    spacing: 8

                    Text {
                        text: I18n.tr(configManager.language, "common.how_it_works")
                        color: textPrimary
                        font.pixelSize: 16
                        font.family: titleFont
                        font.weight: Font.Medium
                    }

                    Text {
                        width: parent.width
                        text: pageRoot.optionDescription(index)
                        color: textSecondary
                        font.pixelSize: 12
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                        lineHeight: 1.2
                    }
                }
            }
        }
    }
}
