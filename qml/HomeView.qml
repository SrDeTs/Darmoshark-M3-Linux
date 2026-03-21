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
    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"

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
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: homeRoot.width
            spacing: 16

            Rectangle {
                width: parent.width
                height: 92
                radius: 22
                color: "#101514"
                border.color: border
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Column {
                        width: parent.width - 170
                        spacing: 4

                        Text {
                            text: "Início"
                            color: textPrimary
                            font.pixelSize: 24
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            text: "Visão geral do mouse"
                            color: textSecondary
                            font.pixelSize: 11
                            font.family: bodyFont
                        }
                    }

                    Rectangle {
                        width: 132
                        height: 34
                        radius: 17
                        gradient: Gradient {
                            GradientStop { position: 0; color: hidManager.deviceConnected ? "#103b33" : "#342020" }
                            GradientStop { position: 1; color: hidManager.deviceConnected ? "#0f2f29" : "#241616" }
                        }
                        border.color: hidManager.deviceConnected ? accent : danger
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: hidManager.deviceConnected ? "ONLINE" : "SEM LINK"
                            color: hidManager.deviceConnected ? accent : danger
                            font.pixelSize: 11
                            font.bold: true
                            font.family: titleFont
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 240
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#141918" }
                    GradientStop { position: 1; color: "#0c100f" }
                }
                border.color: accent
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 18

                    Rectangle {
                        width: 190
                        height: parent.height - 36
                        radius: 20
                        color: "#151b19"
                        border.color: "#2f3836"
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/images/m3_device_mouse.png"
                            width: 128
                            height: 128
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                    }

                    Column {
                        width: parent.width - 208
                        spacing: 10

                        Text {
                            text: "Darmoshark M3"
                            color: textPrimary
                            font.pixelSize: 26
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            width: parent.width
                            text: "DPI, report rate, LOD e sensor performance já estão organizados por página."
                            color: textSecondary
                            font.pixelSize: 11
                            font.family: bodyFont
                            wrapMode: Text.WordWrap
                        }

                        Row {
                            spacing: 10

                            Rectangle {
                                width: 112
                                height: 34
                                radius: 17
                                color: "#0f2320"
                                border.color: accent
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: hidManager.deviceConnected ? "Ativo" : "Sem link"
                                    color: accent
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: titleFont
                                }
                            }

                            Rectangle {
                                width: 136
                                height: 34
                                radius: 17
                                color: "#121816"
                                border.color: accentSoft
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: connectionLabel(hidManager.connectionMode)
                                    color: accentSoft
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: titleFont
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 90
                            radius: 16
                            color: panelDeep
                            border.color: border
                            border.width: 1

                            Row {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12

                                Rectangle {
                                    width: 66
                                    height: parent.height - 28
                                    radius: 14
                                    color: "#151d1b"
                                    border.color: accent
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: "M3"
                                        color: accent
                                        font.pixelSize: 20
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }

                                Column {
                                    width: parent.width - 80
                                    spacing: 4

                                    Text {
                                        text: "Shell organizado"
                                        color: accent
                                        font.pixelSize: 12
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "A navegação está separada por feature para evitar blocos misturados."
                                        color: textSecondary
                                        font.pixelSize: 11
                                        font.family: bodyFont
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
                    height: 160
                    radius: 20
                    color: panel
                    border.color: border
                    border.width: 1
                    clip: true

                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Rectangle {
                            width: Math.floor((parent.width - 24) / 3)
                            height: parent.height - 32
                            radius: 16
                            color: "#101513"
                            border.color: accentSoft
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 6

                                Text { text: "BATERIA"; color: textSecondary; font.pixelSize: 10; font.bold: true; font.family: titleFont }
                                Text { text: hidManager.batteryLevel + "%"; color: textPrimary; font.pixelSize: 28; font.bold: true; font.family: titleFont }
                            }
                        }

                        Rectangle {
                            width: Math.floor((parent.width - 24) / 3)
                            height: parent.height - 32
                            radius: 16
                            color: "#101513"
                            border.color: accentSoft
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 6

                                Text { text: "CONEXÃO"; color: textSecondary; font.pixelSize: 10; font.bold: true; font.family: titleFont }
                                Text { text: hidManager.deviceConnected ? "Ativa" : "Sem link"; color: hidManager.deviceConnected ? accent : danger; font.pixelSize: 28; font.bold: true; font.family: titleFont }
                            }
                        }

                        Rectangle {
                            width: Math.floor((parent.width - 24) / 3)
                            height: parent.height - 32
                            radius: 16
                            color: "#101513"
                            border.color: accentSoft
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 6

                                Text { text: "MODO"; color: textSecondary; font.pixelSize: 10; font.bold: true; font.family: titleFont }
                                Text { text: connectionLabel(hidManager.connectionMode); color: textPrimary; font.pixelSize: 18; font.bold: true; font.family: titleFont; wrapMode: Text.WordWrap }
                            }
                        }
                    }
                }

                Column {
                    width: Math.round((parent.width - 16) * 0.42)
                    spacing: 16

                    Rectangle {
                        width: parent.width
                        height: 160
                        radius: 20
                        color: panel
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: "AÇÃO RÁPIDA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Button {
                                id: scanHit
                                text: "ESCANEAR DISPOSITIVOS"
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
                                    font.family: titleFont
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: hidManager.scanDevices()
                            }

                            Text {
                                width: parent.width
                                text: "Atualiza a conexão sem abrir outra tela."
                                color: textSecondary
                                font.pixelSize: 11
                                font.family: bodyFont
                                wrapMode: Text.WordWrap
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 160
                        radius: 20
                        color: panel
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
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "1. Abra a página de feature.\n2. Ajuste o valor.\n3. Envie direto ao mouse."
                                color: textPrimary
                                font.pixelSize: 12
                                font.family: bodyFont
                                wrapMode: Text.WordWrap
                                lineHeight: 1.2
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 64
                radius: 20
                color: panelDeep
                border.color: accent
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Column {
                        width: parent.width - 150
                        spacing: 4

                        Text {
                            text: "STATUS FINAL"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            width: parent.width
                            text: "A interface está organizada por feature e sem blocos mortos."
                            color: textPrimary
                            font.pixelSize: 12
                            font.bold: true
                            font.family: titleFont
                            wrapMode: Text.WordWrap
                        }
                    }

                    Rectangle {
                        width: 120
                        height: 34
                        radius: 17
                        color: "#0f2320"
                        border.color: accent
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "READY"
                            color: accent
                            font.pixelSize: 11
                            font.bold: true
                            font.family: titleFont
                        }
                    }
                }
            }
        }
    }
}
