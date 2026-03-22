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
    property color textPrimary: "#e8edf6"
    property color textSecondary: "#a1afc6"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.implicitHeight + 40
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        ColumnLayout {
            id: contentColumn
            width: Math.min(pageRoot.width - 48, 1080)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 18
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                radius: 24
                color: panel
                border.color: panelLine
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 8

                    Text {
                        text: "Configurações"
                        color: textPrimary
                        font.pixelSize: 30
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        text: "Ações rápidas do aplicativo e informações do perfil local."
                        color: textSecondary
                        font.pixelSize: 14
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: width >= 920 ? 2 : 1
                columnSpacing: 16
                rowSpacing: 16

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 230
                    radius: 22
                    color: panel
                    border.color: panelLine
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12

                        Text {
                            text: "Dispositivo"
                            color: accent
                            font.pixelSize: 12
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            text: "Conexão: " + hidManager.connectionMode
                            color: textPrimary
                            font.pixelSize: 15
                            font.family: bodyFont
                        }

                        Text {
                            text: "Bateria: " + hidManager.batteryLevel + "%"
                            color: textPrimary
                            font.pixelSize: 15
                            font.family: bodyFont
                        }

                        Text {
                            text: hidManager.isCharging ? "Status: carregando" : "Status: pronto"
                            color: textPrimary
                            font.pixelSize: 15
                            font.family: bodyFont
                        }

                        Item { Layout.fillHeight: true }

                        Button {
                            text: "Procurar dispositivo"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 46

                            background: Rectangle {
                                radius: 14
                                color: panelSoft
                                border.color: panelLineSoft
                                border.width: 1
                            }

                            contentItem: Text {
                                text: parent.text
                                color: textPrimary
                                font.family: titleFont
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: hidManager.scanDevices()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 230
                    radius: 22
                    color: panel
                    border.color: panelLine
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12

                        Text {
                            text: "Perfil local"
                            color: accent
                            font.pixelSize: 12
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            text: "Polling rate: " + configManager.pollingRate + " Hz"
                            color: textPrimary
                            font.pixelSize: 15
                            font.family: bodyFont
                        }

                        Text {
                            text: "DPI ativo: " + (configManager.dpiStages[configManager.dpiCurrentStage] ? configManager.dpiStages[configManager.dpiCurrentStage].value : "-")
                            color: textPrimary
                            font.pixelSize: 15
                            font.family: bodyFont
                        }

                        Text {
                            text: "E-Sports: " + (configManager.esportsOpen ? "ligado" : "desligado")
                            color: textPrimary
                            font.pixelSize: 15
                            font.family: bodyFont
                        }

                        Item { Layout.fillHeight: true }

                        Button {
                            text: "Abrir pasta da config"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 46

                            background: Rectangle {
                                radius: 14
                                color: panelSoft
                                border.color: panelLineSoft
                                border.width: 1
                            }

                            contentItem: Text {
                                text: parent.text
                                color: textPrimary
                                font.family: titleFont
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: Qt.openUrlExternally(configDirectoryUrl)
                        }
                    }
                }
            }
        }
    }
}
