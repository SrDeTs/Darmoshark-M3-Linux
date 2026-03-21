import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: homeRoot
    clip: true

    property color accent: "#6da8ff"
    property color accentSoft: "#91b8ff"
    property color border: "#2b3650"
    property color panel: "#151d31"
    property color panelDeep: "#11182a"
    property color textPrimary: "#e8edf6"
    property color textSecondary: "#a1afc6"
    property color danger: "#8da9ff"
    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"

    function connectionLabel(mode) {
        if (!mode || mode.length === 0)
            return "Desconhecido"
        if (mode === "2.4G Wireless")
            return "Sem fio 2.4G"
        if (mode === "Wired")
            return "Cabo"
        return mode
    }

    Flickable {
        anchors.fill: parent
        contentWidth: homeRoot.width
        contentHeight: contentColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: homeRoot.width
            spacing: 18

            Rectangle {
                width: parent.width
                height: 220
                radius: 24
                color: "#11182a"
                border.color: border
                border.width: 1
                clip: true

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#18213a" }
                        GradientStop { position: 1; color: "#11182a" }
                    }
                    opacity: 0.92
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 18

                    Rectangle {
                        width: 210
                        height: parent.height - 36
                        radius: 20
                        color: "#18243c"
                        border.color: "#354463"
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/images/m3_device_mouse.png"
                            width: 144
                            height: 144
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                    }

                    Column {
                        width: parent.width - 246
                        spacing: 10

                        Text {
                            text: "Darmoshark M3"
                            color: textPrimary
                            font.pixelSize: 28
                            font.bold: true
                            font.family: titleFont
                        }
                    }
                }
            }
        }
    }
}
