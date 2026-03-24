import QtQuick 2.15

Item {
    id: root

    property bool controlsLocked: false
    property bool pageTransitionRunning: false
    property real incomingOpacity: 0.0

    default property alias contentChildren: contentHost.data
    property alias currentPageLayer: currentPageLayer
    property alias currentPageLoader: currentPageLoader
    property alias incomingPageLayer: incomingPageLayer
    property alias incomingPageLoader: incomingPageLoader

    clip: true
    enabled: !root.controlsLocked
    opacity: root.controlsLocked ? 0.42 : 1.0

    Behavior on opacity {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    Item {
        id: contentHost
        anchors.fill: parent

        Item {
            id: currentPageLayer
            anchors.fill: parent

            Loader {
                id: currentPageLoader
                anchors.fill: parent
            }
        }

        Item {
            id: incomingPageLayer
            anchors.fill: parent
            opacity: root.incomingOpacity
            visible: opacity > 0.0 || root.pageTransitionRunning

            Loader {
                id: incomingPageLoader
                anchors.fill: parent
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(8 / 255, 10 / 255, 14 / 255, 0.10)
        opacity: root.controlsLocked ? 1.0 : 0.0
        visible: opacity > 0.0
        z: 2

        Behavior on opacity {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.controlsLocked
        }
    }
}
