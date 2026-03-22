import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color surfaceContainerLow: "#191a1a"
    property color surfaceContainer: "#2b2c2c"
    property color surfaceContainerHigh: "#1f2020"
    property color primary: "#a7c8ff"
    property color onSurface: "#e7e5e5"
    property color onSurfaceVariant: "#a1afc6"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    Rectangle {
        width: 320
        height: 120
        anchors.centerIn: parent
        color: surfaceContainerLow
        radius: 24
        border.color: surfaceContainerHigh
        border.width: 2

        Column {
            anchors.centerIn: parent
            spacing: 24

            Text {
                text: "Lift Off Distance"
                color: onSurface
                font.pixelSize: 18
                font.family: titleFont
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Text {
                    text: "1mm"
                    color: !configManager.liftOffHigh ? onSurface : onSurfaceVariant
                    font.pixelSize: 14
                    font.family: bodyFont
                    anchors.verticalCenter: parent.verticalCenter
                }

                Switch {
                    checked: configManager.liftOffHigh
                    anchors.verticalCenter: parent.verticalCenter
                    onToggled: {
                        configManager.setLiftOffHigh(checked)
                        if (typeof hidManager !== "undefined") {
                            hidManager.applyLiftOffDistance(!checked) // low = !high
                        }
                    }
                }

                Text {
                    text: "2mm"
                    color: configManager.liftOffHigh ? onSurface : onSurfaceVariant
                    font.pixelSize: 14
                    font.family: bodyFont
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
