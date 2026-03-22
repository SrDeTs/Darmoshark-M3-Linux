import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color accent: "#6da8ff"
    property color accentSoft: "#91b8ff"
    property color border: "#2b3650"
    property color panelDeep: "#11182a"
    property color textPrimary: "#e8edf6"
    property color textSecondary: "#a1afc6"
    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"

    function rateDescription(rate) {
        if (rate === 125) return "Máximo alcance"
        if (rate === 500) return "Equilibrado"
        return "Maior resposta"
    }

    Flickable {
        anchors.fill: parent
        contentWidth: pageRoot.width
        contentHeight: contentColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: pageRoot.width
            spacing: 16

            Rectangle {
                width: parent.width
                height: 124
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#151d31" }
                    GradientStop { position: 1; color: "#11182a" }
                }
                border.color: accent
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 6

                    Text {
                        text: "REPORT RATE"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        text: "Taxa de resposta"
                        color: textPrimary
                        font.pixelSize: 24
                        font.bold: true
                        font.family: titleFont
                    }

                }
            }

            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: Math.round((parent.width - 16) * 0.62)
                    height: 430
                    radius: 24
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#151d31" }
                        GradientStop { position: 1; color: "#151d31" }
                    }
                    border.color: border
                    border.width: 1
                    clip: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        Text {
                            text: "TAXA DE ATUALIZAÇÃO (HZ)"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                        }

                        Row {
                            width: parent.width
                            spacing: 12

                            Repeater {
                                model: [125, 500, 1000]

                                delegate: Rectangle {
                                    width: Math.floor((parent.width - 24) / 3)
                                    height: 126
                                    radius: 20
                                    scale: configManager.pollingRate === modelData ? 1.012 : (hit.containsMouse ? 1.004 : 1.0)
                                    Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: configManager.pollingRate === modelData ? "#26334f" : (hit.containsMouse ? "#1b263d" : "#182235") }
                                        GradientStop { position: 1; color: configManager.pollingRate === modelData ? "#1d2f4a" : "#11192b" }
                                    }
                                    border.color: configManager.pollingRate === modelData ? accent : border
                                    border.width: configManager.pollingRate === modelData ? 1.5 : 1
                                    clip: true

                                    MouseArea {
                                        id: hit
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: configManager.setPollingRate(modelData)
                                    }

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 16
                                        spacing: 8

                                        Text {
                                            text: modelData
                                            color: configManager.pollingRate === modelData ? accent : textPrimary
                                            font.pixelSize: 28
                                            font.bold: true
                                            font.family: titleFont
                                        }

                                        Text {
                                            text: "Hz"
                                            color: textSecondary
                                            font.pixelSize: 11
                                            font.family: bodyFont
                                        }

                                        Rectangle {
                                            width: 52
                                            height: 4
                                            radius: 2
                                            color: modelData === 125 ? "#8da9ff" : (modelData === 500 ? "#7fa7ff" : accent)
                                        }

                                        Text {
                                            width: parent.width
                                            text: rateDescription(modelData)
                                            color: configManager.pollingRate === modelData ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.family: bodyFont
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 106
                            radius: 18
                            color: panelDeep
                            border.color: border
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text {
                                    text: "SELEÇÃO ATUAL"
                                    color: textSecondary
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: titleFont
                                }

                                Text {
                                    text: configManager.pollingRate + " Hz"
                                    color: textPrimary
                                    font.pixelSize: 34
                                    font.bold: true
                                    font.family: titleFont
                                }
                            }
                        }
                    }
                }

                Column {
                    width: Math.round((parent.width - 16) * 0.38)
                    spacing: 16

                    Rectangle {
                        width: parent.width
                        height: 154
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#151d31" }
                            GradientStop { position: 1; color: "#11182a" }
                        }
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: "AÇÃO DIRETA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Button {
                                text: "ENVIAR TAXA"
                                width: parent.width
                                height: 48
                                enabled: hidManager.deviceConnected
                                hoverEnabled: true
                                scale: parent.enabled && pressed ? 1.01 : (hovered ? 1.005 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                                background: Rectangle {
                                    radius: 14
                                    color: parent.enabled ? (parent.pressed ? "#6da8ff" : accent) : "#39435c"
                                    border.color: parent.enabled ? accent : "#5a6480"
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: parent.enabled ? "#e8edf6" : "#a1afc6"
                                    font.bold: true
                                    font.family: titleFont
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: hidManager.applySettings(configManager.pollingRate)
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 124
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#151d31" }
                            GradientStop { position: 1; color: "#11182a" }
                        }
                        border.color: accentSoft
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "OBSERVAÇÃO"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                        }
                    }
                }
            }
        }
    }
}
