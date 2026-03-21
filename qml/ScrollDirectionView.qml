import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color accent: "#00f5d4"
    property color accentSoft: "#13c9af"
    property color border: "#2a3331"
    property color panelDeep: "#0d1110"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"
    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"

    QtObject { id: scrollGroup; property bool forward: true }

    function directionTitle() {
        return scrollGroup.forward ? "Forward" : "Reverse"
    }

    function directionDescription() {
        return scrollGroup.forward ? "Rolagem normal" : "Rolagem invertida"
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
                    GradientStop { position: 0; color: "#131917" }
                    GradientStop { position: 1; color: "#0e1211" }
                }
                border.color: accent
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 6

                    Text {
                        text: "SCROLL DIRECTION"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        text: "Sentido da rolagem"
                        color: textPrimary
                        font.pixelSize: 24
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        width: parent.width
                        text: "A captura confirmou dois estados: Forward e Reverse."
                        color: textSecondary
                        font.pixelSize: 11
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
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
                        GradientStop { position: 0; color: "#151c1a" }
                        GradientStop { position: 1; color: "#101514" }
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
                                scale: scrollGroup.forward ? 1.012 : 1.0
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                gradient: Gradient {
                                    GradientStop { position: 0; color: scrollGroup.forward ? "#103b33" : "#101513" }
                                    GradientStop { position: 1; color: scrollGroup.forward ? "#0f2f29" : "#0c1010" }
                                }
                                border.color: scrollGroup.forward ? accent : border
                                border.width: scrollGroup.forward ? 1.5 : 1
                                clip: true

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: scrollGroup.forward = true
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
                                            color: scrollGroup.forward ? accent : "#1f2423"
                                            border.color: scrollGroup.forward ? accent : border
                                            border.width: 1
                                        }

                                        Text {
                                            text: "FORWARD"
                                            color: scrollGroup.forward ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                            font.family: titleFont
                                        }
                                    }

                                    Text {
                                        text: "Rolagem normal"
                                        color: textPrimary
                                        font.pixelSize: 30
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "Sentido padrão da roda"
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
                                scale: !scrollGroup.forward ? 1.012 : 1.0
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                gradient: Gradient {
                                    GradientStop { position: 0; color: !scrollGroup.forward ? "#103b33" : "#101513" }
                                    GradientStop { position: 1; color: !scrollGroup.forward ? "#0f2f29" : "#0c1010" }
                                }
                                border.color: !scrollGroup.forward ? accent : border
                                border.width: !scrollGroup.forward ? 1.5 : 1
                                clip: true

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: scrollGroup.forward = false
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
                                            color: !scrollGroup.forward ? accent : "#1f2423"
                                            border.color: !scrollGroup.forward ? accent : border
                                            border.width: 1
                                        }

                                        Text {
                                            text: "REVERSE"
                                            color: !scrollGroup.forward ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                            font.family: titleFont
                                        }
                                    }

                                    Text {
                                        text: "Rolagem invertida"
                                        color: textPrimary
                                        font.pixelSize: 30
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "Inverte o sentido da roda"
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
                            GradientStop { position: 0; color: "#121816" }
                            GradientStop { position: 1; color: "#0d1110" }
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

                            Text {
                                width: parent.width
                                text: "O valor selecionado é enviado direto para o mouse."
                                color: textPrimary
                                font.pixelSize: 14
                                font.bold: true
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                            }

                            Button {
                                text: "ENVIAR SENTIDO"
                                width: parent.width
                                height: 48
                                enabled: hidManager.deviceConnected
                                hoverEnabled: true
                                scale: parent.enabled && pressed ? 1.01 : (hovered ? 1.005 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

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
                                    font.family: titleFont
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: hidManager.applyScrollDirection(scrollGroup.forward)
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 124
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#131917" }
                            GradientStop { position: 1; color: "#0e1211" }
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
                                text: "Separado de propósito para manter a navegação limpa."
                                color: textPrimary
                                font.pixelSize: 13
                                font.bold: true
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                width: parent.width
                                text: "Atual: " + directionTitle() + " - " + directionDescription()
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
}
