import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color accent: "#6da8ff"
    property color accentSoft: "#91b8ff"
    property color border: "#2b3650"
    property color panelDeep: "#11182a"
    property color textPrimary: "#e8edf6"
    property color textSecondary: "#a1afc6"
    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"

    QtObject { id: lodGroup; property bool low: true }

    function lodTitle() {
        return lodGroup.low ? "Low" : "High"
    }

    function lodDescription() {
        return lodGroup.low ? "1 mm" : "2 mm"
    }

    Flickable {
        anchors.fill: parent
        contentWidth: pageRoot.width
        contentHeight: contentColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: pageRoot.width
            spacing: 16

            Rectangle {
                width: parent.width
                height: 124
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#151d31" }
                    GradientStop { position: 1; color: "#11182a" }
                }
                border.color: accent
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 6

                    Text {
                        text: "LIFT OFF DISTANCE"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        text: "Altura de levantamento"
                        color: textPrimary
                        font.pixelSize: 24
                        font.bold: true
                        font.family: titleFont
                    }

                }
            }

            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: Math.round((parent.width - 16) * 0.62)
                    height: 244
                    radius: 24
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#151d31" }
                        GradientStop { position: 1; color: "#151d31" }
                    }
                    border.color: border
                    border.width: 1
                    clip: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "SELEÇÃO DO BLOCO"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                        }

                        Row {
                            width: parent.width
                            spacing: 12

                            Rectangle {
                                width: Math.floor((parent.width - 12) / 2)
                                height: 150
                                radius: 20
                                scale: lodGroup.low ? 1.012 : 1.0
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                gradient: Gradient {
                                    GradientStop { position: 0; color: lodGroup.low ? "#26334f" : "#182235" }
                                    GradientStop { position: 1; color: lodGroup.low ? "#1d2f4a" : "#11192b" }
                                }
                                border.color: lodGroup.low ? accent : border
                                border.width: lodGroup.low ? 1.5 : 1
                                clip: true

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: lodGroup.low = true
                                }

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 8

                                    Row {
                                        spacing: 8

                                        Rectangle {
                                            width: 18
                                            height: 18
                                            radius: 9
                                            color: lodGroup.low ? accent : "#202a42"
                                            border.color: lodGroup.low ? accent : border
                                            border.width: 1
                                        }

                                        Text {
                                            text: "LOW"
                                            color: lodGroup.low ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                            font.family: titleFont
                                        }
                                    }

                                    Text {
                                        text: "1 mm"
                                        color: textPrimary
                                        font.pixelSize: 30
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "Menor altura de levantamento"
                                        color: textSecondary
                                        font.pixelSize: 11
                                        font.family: bodyFont
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            Rectangle {
                                width: Math.floor((parent.width - 12) / 2)
                                height: 150
                                radius: 20
                                scale: !lodGroup.low ? 1.012 : 1.0
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                gradient: Gradient {
                                    GradientStop { position: 0; color: !lodGroup.low ? "#26334f" : "#182235" }
                                    GradientStop { position: 1; color: !lodGroup.low ? "#1d2f4a" : "#11192b" }
                                }
                                border.color: !lodGroup.low ? accent : border
                                border.width: !lodGroup.low ? 1.5 : 1
                                clip: true

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: lodGroup.low = false
                                }

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 8

                                    Row {
                                        spacing: 8

                                        Rectangle {
                                            width: 18
                                            height: 18
                                            radius: 9
                                            color: !lodGroup.low ? accent : "#202a42"
                                            border.color: !lodGroup.low ? accent : border
                                            border.width: 1
                                        }

                                        Text {
                                            text: "HIGH"
                                            color: !lodGroup.low ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                            font.family: titleFont
                                        }
                                    }

                                    Text {
                                        text: "2 mm"
                                        color: textPrimary
                                        font.pixelSize: 30
                                        font.bold: true
                                        font.family: titleFont
                                    }

                                    Text {
                                        width: parent.width
                                        text: "Maior altura de levantamento"
                                        color: textSecondary
                                        font.pixelSize: 11
                                        font.family: bodyFont
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }
                    }
                }

                Column {
                    width: Math.round((parent.width - 16) * 0.38)
                    spacing: 16

                    Rectangle {
                        width: parent.width
                        height: 154
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#151d31" }
                            GradientStop { position: 1; color: "#11182a" }
                        }
                        border.color: accentSoft
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: "AÇÃO DIRETA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Button {
                                text: "ENVIAR LOD"
                                width: parent.width
                                height: 48
                                enabled: hidManager.deviceConnected
                                hoverEnabled: true
                                scale: parent.enabled && pressed ? 1.01 : (hovered ? 1.005 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                                background: Rectangle {
                                    radius: 14
                                    color: parent.enabled ? (parent.pressed ? "#6da8ff" : accent) : "#39435c"
                                    border.color: parent.enabled ? accent : "#5a6480"
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: parent.enabled ? "#e8edf6" : "#a1afc6"
                                    font.bold: true
                                    font.family: titleFont
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: hidManager.applyLiftOffDistance(lodGroup.low)
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 124
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#151d31" }
                            GradientStop { position: 1; color: "#11182a" }
                        }
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "ESTADO DO BLOCO"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "Atual: " + lodTitle() + " (" + lodDescription() + ")"
                                color: textPrimary
                                font.pixelSize: 13
                                font.bold: true
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
