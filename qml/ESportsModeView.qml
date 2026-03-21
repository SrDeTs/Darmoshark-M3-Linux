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

    QtObject { id: esportsGroup; property bool open: false }

    function modeTitle() {
        return esportsGroup.open ? "Open" : "Close"
    }

    function modeDescription() {
        return esportsGroup.open ? "Modo de resposta rápida" : "Modo padrão"
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
                        text: "E-SPORTS MODE"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        text: "Modo especial"
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
                    height: 244
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
                        spacing: 12

                        Text {
                            text: "SELEÇÃO DO BLOCO"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                        }

                        Row {
                            width: parent.width
                            spacing: 12

                            Rectangle {
                                width: Math.floor((parent.width - 12) / 2)
                                height: 150
                                radius: 20
                                scale: esportsGroup.open ? 1.012 : 1.0
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                gradient: Gradient {
                                    GradientStop { position: 0; color: esportsGroup.open ? "#26334f" : "#182235" }
                                    GradientStop { position: 1; color: esportsGroup.open ? "#1d2f4a" : "#11192b" }
                                }
                                border.color: esportsGroup.open ? accent : border
                                border.width: esportsGroup.open ? 1.5 : 1
                                clip: true

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: esportsGroup.open = true
                                }

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 8

                                    Row {
                                        spacing: 8

                                        Rectangle {
                                            width: 18
                                            height: 18
                                            radius: 9
                                            color: esportsGroup.open ? accent : "#202a42"
                                            border.color: esportsGroup.open ? accent : border
                                            border.width: 1
                                        }

                                        Text {
                                            text: "OPEN"
                                            color: esportsGroup.open ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                            font.family: titleFont
                                        }
                                    }

                                    Text {
                                        text: "Resposta rápida"
                                        color: textPrimary
                                        font.pixelSize: 30
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "Ativa o modo especial"
                                        color: textSecondary
                                        font.pixelSize: 11
                                        font.family: bodyFont
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            Rectangle {
                                width: Math.floor((parent.width - 12) / 2)
                                height: 150
                                radius: 20
                                scale: !esportsGroup.open ? 1.012 : 1.0
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                gradient: Gradient {
                                    GradientStop { position: 0; color: !esportsGroup.open ? "#26334f" : "#182235" }
                                    GradientStop { position: 1; color: !esportsGroup.open ? "#1d2f4a" : "#11192b" }
                                }
                                border.color: !esportsGroup.open ? accent : border
                                border.width: !esportsGroup.open ? 1.5 : 1
                                clip: true

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: esportsGroup.open = false
                                }

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 8

                                    Row {
                                        spacing: 8

                                        Rectangle {
                                            width: 18
                                            height: 18
                                            radius: 9
                                            color: !esportsGroup.open ? accent : "#202a42"
                                            border.color: !esportsGroup.open ? accent : border
                                            border.width: 1
                                        }

                                        Text {
                                            text: "CLOSE"
                                            color: !esportsGroup.open ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                            font.family: titleFont
                                        }
                                    }

                                    Text {
                                        text: "Modo padrão"
                                        color: textPrimary
                                        font.pixelSize: 30
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "Desativa o modo especial"
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
                        border.color: accentSoft
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
                                text: "ENVIAR MODO"
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

                                onClicked: hidManager.applyESportsMode(esportsGroup.open)
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
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "ESTADO DO BLOCO"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "Atual: " + modeTitle()
                                color: textPrimary
                                font.pixelSize: 13
                                font.bold: true
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
