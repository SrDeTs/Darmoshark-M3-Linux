import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color panel: "#191a1a"
    property color panelSoft: "#2b2c2c"
    property color panelLine: "#1f2020"
    property color accent: "#6f9fe8"
    property color accentSoft: "#8db7ff"
    property color textPrimary: "#e8edf6"
    property color textSecondary: "#c5cee0"
    property color textDim: "#99a7be"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    function rateDescription(rate) {
        if (rate === 125) return "Máximo alcance"
        if (rate === 500) return "Equilibrado"
        return "Maior resposta"
    }

    function selectRate(rate) {
        configManager.setPollingRate(rate)
        if (typeof hidManager !== "undefined" && hidManager.deviceConnected)
            hidManager.applySettings(rate)
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            width: 450
            height: 132
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 24
            anchors.topMargin: 96
            radius: 24
            color: panel
            border.color: panelLine
            border.width: 2

            Column {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 16

                Text {
                    text: "Report Rate"
                    color: textPrimary
                    font.pixelSize: 24
                    font.family: titleFont
                    font.weight: Font.Medium
                }

                Rectangle {
                    width: parent.width
                    height: 44
                    radius: 22
                    color: panelSoft
                    border.color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.03)
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        Repeater {
                            model: [125, 500, 1000]

                            delegate: Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    radius: 18
                                    color: configManager.pollingRate === modelData ? accent : "transparent"
                                    border.color: configManager.pollingRate === modelData
                                                  ? Qt.rgba(141 / 255, 183 / 255, 255 / 255, 0.65)
                                                  : "transparent"
                                    border.width: configManager.pollingRate === modelData ? 1 : 0

                                    Behavior on color { ColorAnimation { duration: 140 } }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData + "Hz"
                                    color: configManager.pollingRate === modelData ? "#eef5ff" : textSecondary
                                    font.pixelSize: 14
                                    font.family: bodyFont
                                    font.weight: configManager.pollingRate === modelData ? Font.Medium : Font.Normal
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: pageRoot.selectRate(modelData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
