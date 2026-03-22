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
        width: 620
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

            Rectangle {
                width: parent.width
                height: 52
                radius: 22
                color: sectionTint
                border.color: lineColor
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 4

                    Repeater {
                        model: [
                            { label: "Invertido", nextState: false, active: !configManager.scrollNormal },
                            { label: "Normal", nextState: true, active: configManager.scrollNormal }
                        ]

                        delegate: Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Rectangle {
                                anchors.fill: parent
                                radius: 18
                                color: modelData.active ? accent : "transparent"
                                border.color: modelData.active
                                              ? Qt.rgba(157 / 255, 192 / 255, 255 / 255, 0.65)
                                              : "transparent"
                                border.width: modelData.active ? 1 : 0

                                Behavior on color { ColorAnimation { duration: 140 } }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.label
                                color: modelData.active ? "#eef5ff" : textSecondary
                                font.pixelSize: 15
                                font.family: bodyFont
                                font.weight: modelData.active ? Font.Medium : Font.Normal
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
}
