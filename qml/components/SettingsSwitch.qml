import QtQuick 2.15
import QtQuick.Controls 2.15

Switch {
    id: switchRoot
    implicitWidth: 50
    implicitHeight: 28
    padding: 0

    indicator: Rectangle {
        implicitWidth: 50
        implicitHeight: 28
        radius: height / 2
        color: switchRoot.checked ? "#3b475a" : "#202224"
        border.width: 1
        border.color: switchRoot.checked
            ? Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.20)
            : Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.06)
        opacity: switchRoot.enabled ? 1.0 : 0.45

        Behavior on color {
            ColorAnimation { duration: 160 }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: "transparent"
            border.width: 1
            border.color: switchRoot.checked
                ? Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.12)
                : Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.03)
        }

        Rectangle {
            width: 22
            height: 22
            radius: 11
            y: 3
            x: switchRoot.checked ? parent.width - width - 3 : 3
            color: switchRoot.checked ? "#d9dee7" : "#cfd4dc"
            border.width: 1
            border.color: Qt.rgba(15 / 255, 18 / 255, 22 / 255, switchRoot.checked ? 0.08 : 0.16)

            Rectangle {
                anchors.centerIn: parent
                width: 8
                height: 8
                radius: 4
                color: switchRoot.checked ? "#5a6575" : "#767d87"
                opacity: switchRoot.down ? 0.7 : 1.0
            }

            Behavior on x {
                NumberAnimation { duration: 170; easing.type: Easing.OutCubic }
            }

            Behavior on color {
                ColorAnimation { duration: 140 }
            }
        }
    }

    contentItem: Item {}
}
