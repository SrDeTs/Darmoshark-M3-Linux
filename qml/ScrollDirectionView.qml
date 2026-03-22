import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color lineColor: "#1f2020"
    property color glassTint: "#191a1a"
    property color sectionTint: "#2b2c2c"
    property color textPrimary: "#f4f7ff"
    property color textSecondary: "#b2bdd1"
    property color textMuted: "#7e8aa1"
    property color accent: "#9dc0ff"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    Rectangle {
        id: controlCard
        width: 560
        height: 212
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 90
        radius: 30
        color: glassTint
        border.color: lineColor
        border.width: 2

        Column {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 16

            Text {
                text: "Scroll Direction"
                color: textPrimary
                font.pixelSize: 28
                font.family: titleFont
                font.weight: Font.DemiBold
            }

            Text {
                width: parent.width - 12
                text: "Escolha o comportamento da roda com um seletor direto e mais limpo."
                color: textSecondary
                font.pixelSize: 15
                wrapMode: Text.WordWrap
                font.family: bodyFont
            }

            Rectangle {
                width: parent.width
                height: 78
                radius: 24
                color: sectionTint
                border.color: lineColor
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Repeater {
                        model: [
                            { label: "Invertido", caption: "Rolagem alternativa", nextState: false, active: !configManager.scrollNormal },
                            { label: "Normal", caption: "Padrão do mouse", nextState: true, active: configManager.scrollNormal }
                        ]

                        delegate: Rectangle {
                            width: 268
                            height: parent.height
                            radius: 20
                            color: modelData.active ? Qt.rgba(157 / 255, 192 / 255, 255 / 255, 0.18) : "transparent"
                            border.color: modelData.active ? Qt.rgba(157 / 255, 192 / 255, 255 / 255, 0.22) : "transparent"
                            border.width: 1

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: modelData.label
                                    color: modelData.active ? textPrimary : textSecondary
                                    font.pixelSize: 22
                                    font.family: titleFont
                                    font.weight: Font.DemiBold
                                }

                                Text {
                                    text: modelData.caption
                                    color: modelData.active ? accent : textMuted
                                    font.pixelSize: 13
                                    font.family: bodyFont
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    configManager.setScrollNormal(modelData.nextState)
                                    if (typeof hidManager !== "undefined")
                                        hidManager.applyScrollDirection(modelData.nextState)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        width: 240
        height: 212
        anchors.left: controlCard.right
        anchors.leftMargin: 18
        anchors.top: controlCard.top
        radius: 30
        color: glassTint
        border.color: lineColor
        border.width: 2

        Column {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 12

            Text {
                text: "Estado atual"
                color: textMuted
                font.pixelSize: 13
                font.family: bodyFont
            }

            Text {
                text: configManager.scrollNormal ? "Normal" : "Invertido"
                color: textPrimary
                font.pixelSize: 38
                font.family: titleFont
                font.weight: Font.DemiBold
            }

            Rectangle {
                width: 136
                height: 34
                radius: 17
                color: Qt.rgba(157 / 255, 192 / 255, 255 / 255, 0.16)

                Text {
                    anchors.centerIn: parent
                    text: configManager.scrollNormal ? "Uso padrão" : "Modo alternativo"
                    color: accent
                    font.pixelSize: 12
                    font.family: bodyFont
                    font.weight: Font.Medium
                }
            }
        }
    }
}
