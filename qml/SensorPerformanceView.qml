import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

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
            title: "Ripple"
            statusOn: "On"
            statusOff: "Off"
            description: "Reduz pequenas vibracoes do sensor em movimentos finos."
        }
        ListElement {
            title: "Motion Sync"
            statusOn: "On"
            statusOff: "Off"
            description: "Sincroniza melhor os dados do sensor com os relatorios enviados."
        }
        ListElement {
            title: "Angle Snap"
            statusOn: "On"
            statusOff: "Off"
            description: "Ajuda a corrigir linhas retas automaticamente em movimentos diagonais."
        }
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
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 96
        spacing: 14

        Row {
            spacing: 14

            Repeater {
                model: sensorOptions

                delegate: Rectangle {
                    width: 196
                    height: 132
                    radius: 24
                    color: cardColor
                    border.color: cardBorder
                    border.width: 2

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        Text {
                            text: model.title
                            color: textPrimary
                            font.pixelSize: 20
                            font.family: titleFont
                            font.weight: Font.Medium
                        }

                        RowLayout {
                            width: parent.width
                            spacing: 12

                            Switch {
                                checked: pageRoot.optionEnabled(index)
                                Layout.alignment: Qt.AlignVCenter
                                onToggled: pageRoot.setOptionEnabled(index, checked)
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: pageRoot.optionEnabled(index) ? model.statusOn : model.statusOff
                                color: pageRoot.optionEnabled(index) ? textPrimary : textMuted
                                font.pixelSize: 14
                                font.family: bodyFont
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: 72
                            height: 26
                            radius: 13
                            color: pageRoot.optionEnabled(index) ? Qt.rgba(157 / 255, 192 / 255, 255 / 255, 0.16) : sectionColor
                            border.color: pageRoot.optionEnabled(index)
                                          ? Qt.rgba(157 / 255, 192 / 255, 255 / 255, 0.26)
                                          : "transparent"
                            border.width: pageRoot.optionEnabled(index) ? 1 : 0

                            Text {
                                anchors.centerIn: parent
                                text: pageRoot.optionEnabled(index) ? "Ativado" : "Desligado"
                                color: pageRoot.optionEnabled(index) ? accent : textSecondary
                                font.pixelSize: 11
                                font.family: bodyFont
                            }
                        }
                    }
                }
            }
        }

        Row {
            spacing: 14

            Repeater {
                model: sensorOptions

                delegate: Rectangle {
                    width: 196
                    height: 108
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
                            text: "Como funciona"
                            color: textPrimary
                            font.pixelSize: 16
                            font.family: titleFont
                            font.weight: Font.Medium
                        }

                        Text {
                            width: parent.width
                            text: model.description
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
}
