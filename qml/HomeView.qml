import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: homeRoot
    clip: true

    property color accent: "#00f5d4"
    property color accentSoft: "#13c9af"
    property color panel: "#111614"
    property color panelAlt: "#151b19"
    property color panelDeep: "#0d1110"
    property color border: "#2a3331"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"
    property color danger: "#ff6b6b"

    function connectionLabel(mode) {
        if (!mode || mode.length === 0)
            return "Desconhecido"
        if (mode === "2.4G Wireless")
            return "Sem fio 2.4G"
        if (mode === "Wired")
            return "Cabo"
        return mode
    }

    Flickable {
        anchors.fill: parent
        contentWidth: homeRoot.width
        contentHeight: contentColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        Column {
            id: contentColumn
            width: homeRoot.width
            spacing: 16

            Rectangle {
                width: parent.width
                height: 248
                radius: 24
                color: panel
                border.color: border
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 18

                    Rectangle {
                        width: 220
                        height: 208
                        radius: 22
                        color: panelAlt
                        border.color: border
                        border.width: 1
                        clip: true

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/images/m3_device_mouse.png"
                            width: 164
                            height: 164
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                    }

                    Column {
                        width: parent.width - 260
                        spacing: 10

                        Text {
                            text: "Darmoshark M3"
                            color: textPrimary
                            font.pixelSize: 34
                            font.bold: true
                        }

                        Text {
                            width: parent.width
                            text: "Painel consolidado do mouse. O hardware já está falando o mesmo protocolo do software Windows para DPI e polling rate."
                            color: textSecondary
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                        }

                        Row {
                            spacing: 10

                            Rectangle {
                                width: 116
                                height: 34
                                radius: 17
                                color: hidManager.deviceConnected ? "#103b33" : "#2b1717"
                                border.color: hidManager.deviceConnected ? accent : danger
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: hidManager.deviceConnected ? "Conectado" : "Sem mouse"
                                    color: hidManager.deviceConnected ? accent : danger
                                    font.pixelSize: 11
                                    font.bold: true
                                }
                            }

                            Rectangle {
                                width: 136
                                height: 34
                                radius: 17
                                color: "#18211f"
                                border.color: border
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: connectionLabel(hidManager.connectionMode)
                                    color: textPrimary
                                    font.pixelSize: 11
                                    font.bold: true
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 86
                            radius: 18
                            color: panelDeep
                            border.color: border
                            border.width: 1
                            clip: true

                            Row {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12

                                Rectangle {
                                    width: 70
                                    height: parent.height - 28
                                    radius: 16
                                    color: "#1b2421"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "M3"
                                        color: accent
                                        font.pixelSize: 24
                                        font.bold: true
                                    }
                                }

                                Column {
                                    width: parent.width - 82
                                    spacing: 4

                                    Text {
                                        text: "Fluxo validado"
                                        color: accent
                                        font.pixelSize: 12
                                        font.bold: true
                                    }

                                    Text {
                                        width: parent.width
                                        text: "DPI e polling rate já estão alinhados com a captura do driver original."
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

            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: Math.round((parent.width - 16) * 0.58)
                    height: 276
                    radius: 24
                    color: panelAlt
                    border.color: border
                    border.width: 1
                    clip: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 14

                        Text {
                            text: "ESTADO DO SISTEMA"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                        }

                        Row {
                            width: parent.width
                            spacing: 12

                            Rectangle {
                                width: Math.floor((parent.width - 24) / 3)
                                height: 98
                                radius: 18
                                color: "#101614"
                                border.color: border
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 6

                                    Text {
                                        text: "BATERIA"
                                        color: textSecondary
                                        font.pixelSize: 10
                                        font.bold: true
                                    }

                                    Text {
                                        text: hidManager.batteryLevel + "%"
                                        color: textPrimary
                                        font.pixelSize: 28
                                        font.bold: true
                                    }
                                }
                            }

                            Rectangle {
                                width: Math.floor((parent.width - 24) / 3)
                                height: 98
                                radius: 18
                                color: "#101614"
                                border.color: border
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 6

                                    Text {
                                        text: "CONEXÃO"
                                        color: textSecondary
                                        font.pixelSize: 10
                                        font.bold: true
                                    }

                                    Text {
                                        text: hidManager.deviceConnected ? "Ativa" : "Sem link"
                                        color: hidManager.deviceConnected ? accent : danger
                                        font.pixelSize: 28
                                        font.bold: true
                                    }
                                }
                            }

                            Rectangle {
                                width: Math.floor((parent.width - 24) / 3)
                                height: 98
                                radius: 18
                                color: "#101614"
                                border.color: border
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 6

                                    Text {
                                        text: "MODO"
                                        color: textSecondary
                                        font.pixelSize: 10
                                        font.bold: true
                                    }

                                    Text {
                                        text: connectionLabel(hidManager.connectionMode)
                                        color: textPrimary
                                        font.pixelSize: 20
                                        font.bold: true
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 122
                            radius: 18
                            color: panelDeep
                            border.color: border
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text {
                                    text: "Status do trabalho"
                                    color: textSecondary
                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Text {
                                    width: parent.width
                                    text: "A interface foi reconstruída com hierarquia fixa, sem blocos vazando para fora do card."
                                    color: textPrimary
                                    font.pixelSize: 14
                                    font.bold: true
                                    wrapMode: Text.WordWrap
                                }

                                Text {
                                    width: parent.width
                                    text: "Próximo passo: botões, macro e polimento fino."
                                    color: accentSoft
                                    font.pixelSize: 11
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }
                }

                Column {
                    width: Math.round((parent.width - 16) * 0.42)
                    spacing: 16

                    Rectangle {
                        width: parent.width
                        height: 128
                        radius: 24
                        color: panel
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "AÇÃO RÁPIDA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                            }

                            Button {
                                text: "PROCURAR DISPOSITIVOS"
                                width: parent.width
                                height: 44
                                hoverEnabled: true

                                background: Rectangle {
                                    radius: 14
                                    color: parent.pressed ? "#0d332c" : "#11342d"
                                    border.color: accent
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: accent
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: hidManager.scanDevices()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 132
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
                                text: "GUIA RÁPIDA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                            }

                            Text {
                                width: parent.width
                                text: "1. DPI e polling rate já funcionam.\n2. Agora falta fechar botões e macro.\n3. O shell foi redesenhado do zero."
                                color: textPrimary
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                                lineHeight: 1.2
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 84
                radius: 24
                color: panel
                border.color: border
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 16

                    Column {
                        width: parent.width - 170
                        spacing: 4

                        Text {
                            text: "STATUS FINAL"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                        }

                        Text {
                            width: parent.width
                            text: "A UI está sendo refeita do zero para manter consistência visual e reduzir comportamento quebrado."
                            color: textPrimary
                            font.pixelSize: 14
                            font.bold: true
                            wrapMode: Text.WordWrap
                        }
                    }

                    Rectangle {
                        width: 130
                        height: 40
                        radius: 20
                        color: "#0f2320"
                        border.color: accent
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "READY"
                            color: accent
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
