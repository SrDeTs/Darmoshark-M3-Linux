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

    QtObject { id: motionSyncGroup; property bool enabled: true }
    QtObject { id: angleSnapGroup; property bool enabled: false }

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
                        text: "SENSOR PERFORMANCE"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        text: "Motion Sync e Angle Snap"
                        color: textPrimary
                        font.pixelSize: 24
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        width: parent.width
                        text: "A aba fica isolada para não misturar sensor com taxa de atualização."
                        color: textSecondary
                        font.pixelSize: 11
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 148
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#131917" }
                    GradientStop { position: 1; color: "#0e1211" }
                }
                border.color: motionSyncGroup.enabled ? accent : border
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
                                text: "◉"
                                color: accent
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }
                        }

                        Text {
                            text: "MOTION SYNC"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                        }
                    }

                    Text {
                        width: parent.width
                        text: "Toggle confirmado nas capturas de USB e 2.4G."
                        color: textPrimary
                        font.pixelSize: 13
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }

                    Row {
                        width: parent.width
                        spacing: 10

                        Column {
                            width: parent.width - 90
                            spacing: 2

                            Text {
                                text: motionSyncGroup.enabled ? "Ativo" : "Inativo"
                                color: motionSyncGroup.enabled ? accent : textSecondary
                                font.pixelSize: 16
                                font.bold: true
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "Aplicação direta no mouse."
                                color: textSecondary
                                font.pixelSize: 10
                                font.family: bodyFont
                                wrapMode: Text.WordWrap
                            }
                        }

                        Switch {
                            checked: motionSyncGroup.enabled
                            onToggled: {
                                motionSyncGroup.enabled = checked
                                hidManager.applyMotionSync(checked)
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 148
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#131917" }
                    GradientStop { position: 1; color: "#0e1211" }
                }
                border.color: angleSnapGroup.enabled ? accent : border
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
                                text: "◌"
                                color: accent
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }
                        }

                        Text {
                            text: "ANGLE SNAP"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                        }
                    }

                    Text {
                        width: parent.width
                        text: "Também separado para manter a tela limpa e legível."
                        color: textPrimary
                        font.pixelSize: 13
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }

                    Row {
                        width: parent.width
                        spacing: 10

                        Column {
                            width: parent.width - 90
                            spacing: 2

                            Text {
                                text: angleSnapGroup.enabled ? "Ativo" : "Inativo"
                                color: angleSnapGroup.enabled ? accent : textSecondary
                                font.pixelSize: 16
                                font.bold: true
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "Aplicação direta no mouse."
                                color: textSecondary
                                font.pixelSize: 10
                                font.family: bodyFont
                                wrapMode: Text.WordWrap
                            }
                        }

                        Switch {
                            checked: angleSnapGroup.enabled
                            onToggled: {
                                angleSnapGroup.enabled = checked
                                hidManager.applyAngleSnap(checked)
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 146
                radius: 24
                color: panelDeep
                border.color: border
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Text {
                        text: "PRÓXIMO BLOCO"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        width: parent.width
                        text: "Lift Off Distance, Scroll Direction e E-Sports Mode entram nas próprias páginas ao fechar os pacotes."
                        color: textPrimary
                        font.pixelSize: 13
                        font.bold: true
                        font.family: titleFont
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        width: parent.width
                        text: "A separação impede que a página vire um painel misturado."
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
