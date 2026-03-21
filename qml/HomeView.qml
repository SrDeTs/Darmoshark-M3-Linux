import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: homeRoot
    clip: true

    property color accent: "#00f5d4"
    property color accentSoft: "#13c9af"
    property color border: "#2a3331"
    property color panel: "#111614"
    property color panelDeep: "#0d1110"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"
    property color danger: "#ff6b6b"
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
            spacing: 16

            Rectangle {
                width: parent.width
                height: 204
                radius: 24
                color: "#101514"
                border.color: accent
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 18

                    Rectangle {
                        width: 210
                        height: parent.height - 36
                        radius: 20
                        color: "#151b19"
                        border.color: "#2f3836"
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
