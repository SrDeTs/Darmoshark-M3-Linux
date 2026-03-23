import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "idiomas/I18n.js" as I18n

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
        width: 450
        height: 126
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 96
        radius: 24
        color: glassTint
        border.color: lineColor
        border.width: 2

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            Text {
                text: I18n.tr(configManager.language, "scroll.title")
                color: textPrimary
                font.pixelSize: 24
                font.family: titleFont
                font.weight: Font.Medium
            }

            Rectangle {
                width: parent.width
                height: 44
                radius: 22
                color: sectionTint
                border.color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.03)
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 4

                    Repeater {
                        model: [
                            { label: I18n.tr(configManager.language, "scroll.inverted"), nextState: false, active: !configManager.scrollNormal },
                            { label: I18n.tr(configManager.language, "scroll.normal"), nextState: true, active: configManager.scrollNormal }
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
                                font.pixelSize: 14
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

    Rectangle {
        width: 450
        height: 128
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: controlCard.bottom
        anchors.topMargin: 14
        radius: 24
        color: glassTint
        border.color: lineColor
        border.width: 2

        Column {
            anchors.fill: parent
            anchors.leftMargin: 18
            anchors.rightMargin: 18
            anchors.topMargin: 14
            anchors.bottomMargin: 16
            spacing: 8

            Text {
                text: I18n.tr(configManager.language, "common.how_it_works")
                color: textPrimary
                font.pixelSize: 18
                font.family: titleFont
                font.weight: Font.Medium
            }

            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: I18n.tr(configManager.language, "scroll.about_desc")
                color: textSecondary
                font.pixelSize: 14
                font.family: bodyFont
                lineHeight: 1.25
                maximumLineCount: 3
            }
        }
    }
}
