import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color accent: "#00f5d4"
    property color border: "#2a3331"
    property color panelDeep: "#0d1110"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"
    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"

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
                    GradientStop { position: 0; color: "#131917" }
                    GradientStop { position: 1; color: "#0e1211" }
                }
                border.color: border
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
                        text: "Em breve"
                        color: textPrimary
                        font.pixelSize: 24
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        width: parent.width
                        text: "Existe captura separada na pasta Darmoshark M3, então essa função pode virar uma aba própria sem misturar com sensor performance."
                        color: textSecondary
                        font.pixelSize: 11
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 220
                radius: 24
                color: panelDeep
                border.color: border
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 10

                    Text {
                        text: "ESTRUTURA RESERVADA"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        width: parent.width
                        text: "Quando você fechar o comportamento do LOD, essa página já está separada para receber os controles sem bagunçar o resto do app."
                        color: textPrimary
                        font.pixelSize: 14
                        font.bold: true
                        font.family: titleFont
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        width: parent.width
                        text: "Por enquanto eu deixo só o shell pronto e limpo."
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
