import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Item {
    id: pageRoot
    clip: true

    property color cardColor: "#191a1a"
    property color cardBorder: "#1f2020"
    property color sectionColor: "#2b2c2c"
    property color sectionBorder: "#1f2020"
    property color textPrimary: "#f4f7ff"
    property color textSecondary: "#a9b6cb"
    property color textMuted: "#74829c"
    property color accent: "#9dbfff"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    Rectangle {
        id: aboutCard
        width: 346
        height: 540
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 90
        radius: 28
        color: cardColor
        border.color: cardBorder
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 0

            Item { Layout.preferredHeight: 18 }

            Image {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/images/LogoDarmoshark.png"
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 176
                sourceSize.height: 98
                smooth: true
                mipmap: true
            }

            Item { Layout.preferredHeight: 12 }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Darmoshark"
                color: textPrimary
                font.pixelSize: 32
                font.family: titleFont
                font.weight: Font.DemiBold
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "M3 Configurator"
                color: textMuted
                font.pixelSize: 14
                font.family: bodyFont
            }

            Item { Layout.preferredHeight: 28 }

            Repeater {
                model: [
                    { title: "Firmware", value: hidManager.firmwareVersion, side: "Mouse" },
                    { title: "RF Version", value: hidManager.rfVersion, side: "Dongle" },
                    { title: "App Version", value: "v0.1", side: "Linux" }
                ]

                delegate: Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 82
                    radius: 20
                    color: sectionColor
                    border.color: sectionBorder
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 18
                        anchors.topMargin: 14
                        anchors.bottomMargin: 14

                        ColumnLayout {
                            spacing: 4

                            Text {
                                text: modelData.title
                                color: textMuted
                                font.pixelSize: 12
                                font.family: bodyFont
                            }

                            Text {
                                text: modelData.value
                                color: textPrimary
                                font.pixelSize: 20
                                font.family: titleFont
                                font.weight: Font.DemiBold
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: modelData.side
                            color: accent
                            font.pixelSize: 13
                            font.family: bodyFont
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: 16 }
        }
    }
}
