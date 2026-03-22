import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color cardColor: Qt.rgba(42 / 255, 44 / 255, 51 / 255, 0.92)
    property color cardBorder: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.05)
    property color textPrimary: "#ece7ef"
    property color textSecondary: "#beb7c8"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    Rectangle {
        width: 326
        height: 440
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        radius: 28
        color: cardColor
        border.color: cardBorder
        border.width: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: 25
            color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.015)
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 0

            Text {
                text: "About"
                color: textPrimary
                font.pixelSize: 18
                font.weight: Font.Medium
                font.family: titleFont
            }

            Item { Layout.preferredHeight: 24 }

            Image {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/images/LogoDarmoshark.png"
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 168
                sourceSize.height: 92
                smooth: true
                mipmap: true
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Darmoshark"
                color: textPrimary
                font.pixelSize: 28
                font.family: titleFont
                font.weight: Font.Medium
            }

            Item { Layout.preferredHeight: 48 }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Firmware Version:"
                    color: textPrimary
                    font.pixelSize: 16
                    font.family: titleFont
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: hidManager.firmwareVersion
                    color: textSecondary
                    font.pixelSize: 14
                    font.family: bodyFont
                }
            }

            Item { Layout.preferredHeight: 26 }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "RF Version:"
                    color: textPrimary
                    font.pixelSize: 16
                    font.family: titleFont
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: hidManager.rfVersion
                    color: textSecondary
                    font.pixelSize: 14
                    font.family: bodyFont
                }
            }

            Item { Layout.preferredHeight: 26 }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "App Version:"
                    color: textPrimary
                    font.pixelSize: 16
                    font.family: titleFont
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "v0.1"
                    color: textSecondary
                    font.pixelSize: 14
                    font.family: bodyFont
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
