import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color panel: "#10192c"
    property color panelSoft: "#151d31"
    property color panelLine: "#39527f"
    property color panelLineSoft: "#2a3550"
    property color accent: "#6da8ff"
    property color accentSoft: "#91b8ff"
    property color textPrimary: "#e8edf6"
    property color textSecondary: "#a1afc6"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    function rateDescription(rate) {
        if (rate === 125) return "Máximo alcance"
        if (rate === 500) return "Equilibrado"
        return "Maior resposta"
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 14

            Rectangle {
                width: parent.width
                height: 92
                radius: 18
                color: panel
                border.color: panelLine
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: "REPORT RATE"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                            letterSpacing: 1.1
                        }

                        Text {
                            text: "Taxa de resposta"
                            color: textPrimary
                            font.pixelSize: 23
                            font.bold: true
                            font.family: titleFont
                        }
                    }

                    Rectangle {
                        width: 124
                        height: 34
                        radius: 17
                        color: Qt.rgba(109, 168, 255, 0.12)
                        border.color: Qt.rgba(109, 168, 255, 0.45)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: configManager.pollingRate + " Hz"
                            color: accent
                            font.pixelSize: 14
                            font.family: titleFont
                            font.bold: true
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 18
                    color: panel
                    border.color: panelLine
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "TAXA DE ATUALIZAÇÃO (HZ)"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                            letterSpacing: 0.6
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Repeater {
                                model: [125, 500, 1000]

                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 98
                                    radius: 16
                                    color: configManager.pollingRate === modelData ? Qt.rgba(109, 168, 255, 0.22) : panelSoft
                                    border.color: configManager.pollingRate === modelData ? accent : panelLineSoft
                                    border.width: configManager.pollingRate === modelData ? 2 : 1
                                    scale: hit.containsMouse ? 1.01 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                                    MouseArea {
                                        id: hit
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: configManager.setPollingRate(modelData)
                                    }

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 14
                                        spacing: 5

                                        Text {
                                            text: modelData
                                            color: configManager.pollingRate === modelData ? accent : textPrimary
                                            font.pixelSize: 24
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
                                            width: 44
                                            height: 4
                                            radius: 2
                                            color: configManager.pollingRate === modelData ? accent : panelLineSoft
                                        }

                                        Text {
                                            text: rateDescription(modelData)
                                            color: configManager.pollingRate === modelData ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.family: bodyFont
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 98
                            radius: 16
                            color: panelSoft
                            border.color: panelLineSoft
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 6

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
                                    font.pixelSize: 32
                                    font.bold: true
                                    font.family: titleFont
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 410
                    Layout.fillHeight: true
                    spacing: 12

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 152
                        radius: 18
                        color: panel
                        border.color: panelLine
                        border.width: 1

                        ColumnLayout {
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
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                enabled: hidManager.deviceConnected
                                hoverEnabled: true
                                scale: pressed ? 0.99 : (hovered ? 1.005 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                                background: Rectangle {
                                    radius: 14
                                    color: parent.enabled ? (parent.pressed ? "#5f95ec" : accent) : panelSoft
                                    border.color: parent.enabled ? Qt.rgba(145, 184, 255, 0.5) : panelLineSoft
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: parent.enabled ? "#f3f7ff" : textSecondary
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
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 18
                        color: panel
                        border.color: panelLineSoft
                        border.width: 1

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

                            Text {
                                text: "A taxa é aplicada direto no mouse e preservada no arquivo do usuário."
                                color: textPrimary
                                font.pixelSize: 13
                                font.family: bodyFont
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
