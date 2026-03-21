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

    function homeIcon(kind) {
        if (kind === "battery") return "▣"
        if (kind === "connection") return "◌"
        if (kind === "quick") return "⌕"
        return "↗"
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
                height: 232
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#131917" }
                    GradientStop { position: 1; color: "#0b0f0e" }
                }
                border.color: accent
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 18

                    Rectangle {
                        width: 208
                        height: 192
                        radius: 22
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#1a2120" }
                            GradientStop { position: 1; color: "#111715" }
                        }
                        border.color: accent
                        border.width: 1
                        clip: true

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/images/m3_device_mouse.png"
                            width: 152
                            height: 152
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
                            font.pixelSize: 28
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            width: parent.width
                            text: "Visão geral do mouse. DPI, report rate e LOD já estão fechados."
                            color: "#a5b0ad"
                            font.pixelSize: 11
                            font.family: bodyFont
                            wrapMode: Text.WordWrap
                        }

                        Row {
                            spacing: 10

                            Rectangle {
                                width: 116
                                height: 34
                                radius: 17
                                gradient: Gradient {
                                    GradientStop { position: 0; color: hidManager.deviceConnected ? "#103b33" : "#342020" }
                                    GradientStop { position: 1; color: hidManager.deviceConnected ? "#0f2f29" : "#241616" }
                                }
                                border.color: hidManager.deviceConnected ? accent : danger
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: hidManager.deviceConnected ? "Ativo" : "Sem link"
                                    color: hidManager.deviceConnected ? accent : danger
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.family: titleFont
                                }
                            }

                            Rectangle {
                                width: 136
                                height: 34
                                radius: 17
                                gradient: Gradient {
                                    GradientStop { position: 0; color: "#1a2321" }
                                    GradientStop { position: 1; color: "#121816" }
                                }
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
                            height: 78
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
                                    border.color: accent
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: "M3"
                                        color: accent
                                        font.pixelSize: 22
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }

                                Column {
                                    width: parent.width - 82
                                    spacing: 4

                                    Text {
                                        text: "Estado validado"
                                        color: accent
                                        font.pixelSize: 12
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "As páginas principais já estão separadas por feature."
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
                        height: 256
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#171e1c" }
                            GradientStop { position: 1; color: "#0f1312" }
                        }
                        border.color: accent
                        border.width: 1
                        clip: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 12

                        Row {
                            spacing: 8

                            Rectangle {
                                width: 18
                                height: 18
                                radius: 6
                                color: "#18211f"
                                border.color: border
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: homeIcon("battery")
                                    color: accent
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }

                            Text {
                                text: "ESTADO DO SISTEMA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }
                        }

                        Row {
                            width: parent.width
                            spacing: 12

                            Rectangle {
                                width: Math.floor((parent.width - 24) / 3)
                                height: 94
                                radius: 18
                                gradient: Gradient {
                                    GradientStop { position: 0; color: "#151c1a" }
                                    GradientStop { position: 1; color: "#0f1312" }
                                }
                                border.color: accentSoft
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 6

                                    Text {
                                        text: "BATERIA"
                                        color: "#b0b8b6"
                                        font.pixelSize: 10
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        text: hidManager.batteryLevel + "%"
                                        color: textPrimary
                                        font.pixelSize: 28
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }
                            }

                            Rectangle {
                                width: Math.floor((parent.width - 24) / 3)
                                height: 94
                                radius: 18
                                gradient: Gradient {
                                    GradientStop { position: 0; color: "#151c1a" }
                                    GradientStop { position: 1; color: "#0f1312" }
                                }
                                border.color: accentSoft
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 6

                                    Text {
                                        text: "CONEXÃO"
                                        color: "#b0b8b6"
                                        font.pixelSize: 10
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        text: hidManager.deviceConnected ? "Ativa" : "Sem link"
                                        color: hidManager.deviceConnected ? accent : danger
                                        font.pixelSize: 28
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }
                            }

                            Rectangle {
                                width: Math.floor((parent.width - 24) / 3)
                                height: 94
                                radius: 18
                                gradient: Gradient {
                                    GradientStop { position: 0; color: "#151c1a" }
                                    GradientStop { position: 1; color: "#0f1312" }
                                }
                                border.color: accentSoft
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 6

                                    Text {
                                        text: "MODO"
                                        color: "#b0b8b6"
                                        font.pixelSize: 10
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        text: connectionLabel(hidManager.connectionMode)
                                        color: textPrimary
                                        font.pixelSize: 20
                                        font.bold: true
                                        font.family: titleFont
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }

                        Rectangle {
                        width: parent.width
                        height: 122
                        radius: 18
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#121816" }
                            GradientStop { position: 1; color: "#0c1010" }
                        }
                        border.color: accent
                        border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                            Text {
                                text: "Status do trabalho"
                                color: "#b0b8b6"
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "A interface foi reconstruída com hierarquia fixa e sem vazamento de blocos."
                                color: textPrimary
                                font.pixelSize: 13
                                font.bold: true
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                            }

                                Text {
                                width: parent.width
                                text: "Próximo passo: botões, macro e ajuste fino."
                                color: accent
                                font.pixelSize: 11
                                font.family: bodyFont
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
                        height: 120
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#131917" }
                            GradientStop { position: 1; color: "#0e1211" }
                        }
                        border.color: accent
                        border.width: 1
                        clip: true
                        scale: scanHit.containsMouse ? 1.01 : 1.0
                        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Row {
                                spacing: 8

                                Rectangle {
                                    width: 18
                                    height: 18
                                    radius: 6
                                    color: "#18211f"
                                    border.color: border
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: homeIcon("quick")
                                        color: accent
                                        font.pixelSize: 10
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }

                                Text {
                                    text: "AÇÃO RÁPIDA"
                                    color: "#b0b8b6"
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: titleFont
                                }
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
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 124
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#161c1a" }
                            GradientStop { position: 1; color: "#101514" }
                        }
                        border.color: accentSoft
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Row {
                                spacing: 8

                                Rectangle {
                                    width: 18
                                    height: 18
                                    radius: 6
                                    color: "#18211f"
                                    border.color: border
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: homeIcon("connection")
                                        color: accent
                                        font.pixelSize: 10
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }

                                Text {
                                    text: "GUIA RÁPIDA"
                                    color: "#b0b8b6"
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: titleFont
                                }
                            }

                            Text {
                                width: parent.width
                                text: "1. DPI, report rate e LOD estão fechados.\n2. Botões e macro ficam para a próxima frente.\n3. O shell foi organizado por feature."
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
                height: 76
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#131917" }
                    GradientStop { position: 1; color: "#0b0f0e" }
                }
                border.color: accent
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
                                    color: "#b0b8b6"
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: titleFont
                                }

                                Text {
                                    width: parent.width
                                    text: "A UI está organizada por feature para manter consistência visual."
                                    color: textPrimary
                                    font.pixelSize: 13
                                    font.bold: true
                                    font.family: titleFont
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
                            font.family: titleFont
                        }
                    }
                }
            }
        }
    }
}
