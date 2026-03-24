import QtQuick 2.15

Item {
    id: root

    property bool controlsLocked: false
    property bool pageTransitionRunning: false
    property real incomingOpacity: 0.0
    property bool suspended: false
    property string currentSource: ""
    property string incomingSource: ""

    default property alias contentChildren: contentHost.data
    property alias currentPageLayer: currentPageLayer
    property alias incomingPageLayer: incomingPageLayer

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
                active: !root.suspended && root.currentSource.length > 0
                source: active ? root.currentSource : ""
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
                active: !root.suspended && root.incomingSource.length > 0
                source: active ? root.incomingSource : ""
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
