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
        width: 450
        height: 274
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 96
        color: surfaceContainerLow
        radius: 24
        border.color: surfaceContainerHigh
        border.width: 2

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 18

            Text {
                text: "Sensor Performance"
                color: onSurface
                font.pixelSize: 24
                font.family: titleFont
                font.weight: Font.Medium
            }

            Column {
                width: parent.width
                spacing: 14

                Column {
                    width: parent.width
                    spacing: 4

                    RowLayout {
                        width: parent.width
                        spacing: 16

                        Text {
                            text: "Ripple"
                            color: onSurface
                            font.pixelSize: 14
                            font.family: bodyFont
                            Layout.preferredWidth: 92
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            checked: configManager.rippleEnabled
                            Layout.alignment: Qt.AlignVCenter
                            onToggled: {
                                configManager.setRippleEnabled(checked)
                                if (typeof hidManager !== "undefined") {
                                    hidManager.applyRipple(checked)
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: configManager.rippleEnabled ? "On" : "Off"
                            color: configManager.rippleEnabled ? onSurface : onSurfaceVariant
                            font.pixelSize: 14
                            font.family: bodyFont
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    Text {
                        width: parent.width
                        text: "Reduz pequenas vibrações do sensor em movimentos finos."
                        color: onSurfaceVariant
                        font.pixelSize: 12
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }
                }

                Column {
                    width: parent.width
                    spacing: 4

                    RowLayout {
                        width: parent.width
                        spacing: 16

                        Text {
                            text: "Motion Sync"
                            color: onSurface
                            font.pixelSize: 14
                            font.family: bodyFont
                            Layout.preferredWidth: 92
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            checked: configManager.motionSyncEnabled
                            Layout.alignment: Qt.AlignVCenter
                            onToggled: {
                                configManager.setMotionSyncEnabled(checked)
                                if (typeof hidManager !== "undefined") {
                                    hidManager.applyMotionSync(checked)
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: configManager.motionSyncEnabled ? "On" : "Off"
                            color: configManager.motionSyncEnabled ? onSurface : onSurfaceVariant
                            font.pixelSize: 14
                            font.family: bodyFont
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    Text {
                        width: parent.width
                        text: "Sincroniza melhor os dados do sensor com os relatórios enviados."
                        color: onSurfaceVariant
                        font.pixelSize: 12
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }
                }

                Column {
                    width: parent.width
                    spacing: 4

                    RowLayout {
                        width: parent.width
                        spacing: 16

                        Text {
                            text: "Angle Snap"
                            color: onSurface
                            font.pixelSize: 14
                            font.family: bodyFont
                            Layout.preferredWidth: 92
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            checked: configManager.angleSnapEnabled
                            Layout.alignment: Qt.AlignVCenter
                            onToggled: {
                                configManager.setAngleSnapEnabled(checked)
                                if (typeof hidManager !== "undefined") {
                                    hidManager.applyAngleSnap(checked)
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: configManager.angleSnapEnabled ? "On" : "Off"
                            color: configManager.angleSnapEnabled ? onSurface : onSurfaceVariant
                            font.pixelSize: 14
                            font.family: bodyFont
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    Text {
                        width: parent.width
                        text: "Ajuda a corrigir linhas retas automaticamente em movimentos diagonais."
                        color: onSurfaceVariant
                        font.pixelSize: 12
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
