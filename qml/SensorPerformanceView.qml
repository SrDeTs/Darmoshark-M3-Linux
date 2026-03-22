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

    QtObject {
        id: rippleGroup
        property bool enabled: false
    }

    QtObject {
        id: motionSyncGroup
        property bool enabled: true
    }

    QtObject {
        id: angleSnapGroup
        property bool enabled: false
    }

    Rectangle {
        width: 360
        height: 220
        anchors.centerIn: parent
        color: surfaceContainerLow
        radius: 24
        border.color: surfaceContainerHigh
        border.width: 2

        Column {
            anchors.centerIn: parent
            spacing: 18

            Text {
                text: "Sensor Performance"
                color: onSurface
                font.pixelSize: 18
                font.family: titleFont
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                Row {
                    spacing: 16

                    Text {
                        text: "Ripple"
                        color: onSurface
                        font.pixelSize: 14
                        font.family: bodyFont
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Switch {
                        checked: rippleGroup.enabled
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            rippleGroup.enabled = checked
                            if (typeof hidManager !== "undefined") {
                                hidManager.applyRipple(checked)
                            }
                        }
                    }

                    Text {
                        text: rippleGroup.enabled ? "On" : "Off"
                        color: rippleGroup.enabled ? onSurface : onSurfaceVariant
                        font.pixelSize: 14
                        font.family: bodyFont
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 16

                    Text {
                        text: "Motion Sync"
                        color: onSurface
                        font.pixelSize: 14
                        font.family: bodyFont
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Switch {
                        checked: motionSyncGroup.enabled
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            motionSyncGroup.enabled = checked
                            if (typeof hidManager !== "undefined") {
                                hidManager.applyMotionSync(checked)
                            }
                        }
                    }

                    Text {
                        text: motionSyncGroup.enabled ? "On" : "Off"
                        color: motionSyncGroup.enabled ? onSurface : onSurfaceVariant
                        font.pixelSize: 14
                        font.family: bodyFont
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 16

                    Text {
                        text: "Angle Snap"
                        color: onSurface
                        font.pixelSize: 14
                        font.family: bodyFont
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Switch {
                        checked: angleSnapGroup.enabled
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            angleSnapGroup.enabled = checked
                            if (typeof hidManager !== "undefined") {
                                hidManager.applyAngleSnap(checked)
                            }
                        }
                    }

                    Text {
                        text: angleSnapGroup.enabled ? "On" : "Off"
                        color: angleSnapGroup.enabled ? onSurface : onSurfaceVariant
                        font.pixelSize: 14
                        font.family: bodyFont
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
