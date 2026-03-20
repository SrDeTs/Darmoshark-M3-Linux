import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: settingsRoot
    clip: true

    property color accent: "#00f5d4"
    property color panel: "#111614"
    property color panelAlt: "#151b19"
    property color panelDeep: "#0d1110"
    property color border: "#2a3331"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"

    QtObject {
        id: pollingRateGroup
        property int currentValue: 1000
    }

    function rateDescription(rate) {
        if (rate === 125)
            return "Máximo alcance"
        if (rate === 500)
            return "Equilibrado"
        return "Maior resposta"
    }

    function connectionLabel() {
        if (!hidManager.connectionMode || hidManager.connectionMode.length === 0)
            return "Desconhecido"
        return hidManager.connectionMode === "2.4G Wireless" ? "Sem fio 2.4G"
             : hidManager.connectionMode === "Wired" ? "Cabo"
             : hidManager.connectionMode
    }

    Flickable {
        anchors.fill: parent
        contentWidth: settingsRoot.width
        contentHeight: contentColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: settingsRoot.width
            spacing: 16

            Rectangle {
                width: parent.width
                height: 88
                radius: 24
                color: panel
                border.color: border
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 14

                    Column {
                        width: parent.width - 170
                        spacing: 4

                        Text {
                            text: "RESPOSTA E TAXA"
                            color: textPrimary
                            font.pixelSize: 25
                            font.bold: true
                        }

                        Text {
                            text: "Somente o polling rate está confirmado no protocolo capturado."
                            color: textSecondary
                            font.pixelSize: 11
                        }
                    }

                    Rectangle {
                        width: 142
                        height: 42
                        radius: 21
                        color: "#103b33"
                        border.color: accent
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: connectionLabel()
                            color: accent
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: Math.round((parent.width - 16) * 0.62)
                    height: 552
                    radius: 24
                    color: panelAlt
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
                        }

                        Row {
                            width: parent.width
                            spacing: 12

                            Repeater {
                                model: [125, 500, 1000]

                                delegate: Rectangle {
                                    width: Math.floor((parent.width - 24) / 3)
                                    height: 132
                                    radius: 20
                                    color: pollingRateGroup.currentValue === modelData ? "#103b33" : panelDeep
                                    border.color: pollingRateGroup.currentValue === modelData ? accent : border
                                    border.width: pollingRateGroup.currentValue === modelData ? 1.5 : 1
                                    clip: true

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: pollingRateGroup.currentValue = modelData
                                    }

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 16
                                        spacing: 8

                                        Text {
                                            text: modelData
                                            color: pollingRateGroup.currentValue === modelData ? accent : textPrimary
                                            font.pixelSize: 30
                                            font.bold: true
                                        }

                                        Text {
                                            text: "Hz"
                                            color: textSecondary
                                            font.pixelSize: 11
                                        }

                                        Rectangle {
                                            width: 52
                                            height: 4
                                            radius: 2
                                            color: modelData === 125 ? "#ff6b6b" : (modelData === 500 ? "#5b8dff" : accent)
                                        }

                                        Text {
                                            width: parent.width
                                            text: rateDescription(modelData)
                                            color: pollingRateGroup.currentValue === modelData ? accent : textSecondary
                                            font.pixelSize: 10
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 116
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
                                }

                                Text {
                                    text: pollingRateGroup.currentValue + " Hz"
                                    color: textPrimary
                                    font.pixelSize: 34
                                    font.bold: true
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 150
                            radius: 18
                            color: panelDeep
                            border.color: border
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text {
                                    text: "NOTA"
                                    color: textSecondary
                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Text {
                                    width: parent.width
                                    text: "Polling rate foi capturado do driver original e validado em USB/2.4G. Outros ajustes foram ocultados para evitar ruído visual."
                                    color: textPrimary
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
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
                        height: 172
                        radius: 24
                        color: panel
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: "APLICAÇÃO DIRETA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                            }

                            Text {
                                width: parent.width
                                text: "O valor selecionado é enviado direto para o mouse quando você clica em aplicar."
                                color: textPrimary
                                font.pixelSize: 14
                                font.bold: true
                                wrapMode: Text.WordWrap
                            }

                            Button {
                                text: "APLICAR"
                                width: parent.width
                                height: 48
                                enabled: hidManager.deviceConnected

                                background: Rectangle {
                                    radius: 14
                                    color: parent.enabled ? (parent.pressed ? "#00c5a5" : accent) : "#2d3635"
                                    border.color: parent.enabled ? accent : "#4a5452"
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: parent.enabled ? "#071412" : "#7d8785"
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: hidManager.applySettings(pollingRateGroup.currentValue)
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 188
                        radius: 24
                        color: panelAlt
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "ESTADO ATUAL"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                            }

                            Text {
                                width: parent.width
                                text: connectionLabel()
                                color: textPrimary
                                font.pixelSize: 22
                                font.bold: true
                            }

                            Text {
                                width: parent.width
                                text: "Dispositivo conectado: " + (hidManager.deviceConnected ? "sim" : "não")
                                color: hidManager.deviceConnected ? accent : "#c95f5f"
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: border
                            }

                            Text {
                                width: parent.width
                                text: "A interface foi enxugada para deixar somente o que existe de fato no protocolo."
                                color: textSecondary
                                font.pixelSize: 11
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
