import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: appRoot
    width: 1360
    height: 820
    minimumWidth: 1180
    minimumHeight: 720
    visible: true
    title: qsTr("Darmoshark M3 Configurator")
    color: "#0b1020"

    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"
    property color bgBase: "#0b1020"
    property color bgShell: "#11182a"
    property color bgPanel: "#151d31"
    property color bgPanelAlt: "#18223a"
    property color bgCard: "#182235"
    property color borderColor: "#2b3650"
    property color accent: "#6da8ff"
    property color accentSoft: "#91b8ff"
    property color textPrimary: "#e8edf6"
    property color textSecondary: "#a1afc6"
    property color danger: "#8da9ff"

    property var navPages: [
        { title: "Início", subtitle: "Visão geral do mouse", source: "qrc:/qml/HomeView.qml" },
        { title: "DPI", subtitle: "Perfis de sensibilidade", source: "qrc:/qml/DPIView.qml" },
        { title: "Report Rate", subtitle: "Taxa de resposta", source: "qrc:/qml/ReportRateView.qml" },
        { title: "Sensor Performance", subtitle: "Ajustes do sensor", source: "qrc:/qml/SensorPerformanceView.qml" },
        { title: "Lift Off Distance", subtitle: "Altura de levantamento", source: "qrc:/qml/LiftOffDistanceView.qml" },
        { title: "Scroll Direction", subtitle: "Sentido da rolagem", source: "qrc:/qml/ScrollDirectionView.qml" },
        { title: "E-Sports Mode", subtitle: "Modo especial", source: "qrc:/qml/ESportsModeView.qml" }
    ]

    function connectionLabel(mode) {
        if (!mode || mode.length === 0)
            return "Desconhecido"
        if (mode === "2.4G Wireless")
            return "Sem fio 2.4G"
        if (mode === "Wired")
            return "Cabo"
        return mode
    }

    function navIcon(index) {
        if (index === 0) return "⌂"
        if (index === 1) return "◉"
        if (index === 2) return "↻"
        if (index === 3) return "◌"
        if (index === 4) return "⇳"
        return "⇄"
    }

    function pageSource(index) {
        return navPages[index].source
    }

    Rectangle {
        anchors.fill: parent
        color: bgBase
    }

    Rectangle {
        x: -120
        y: -100
        width: 460
        height: 460
        radius: 230
        color: "#7aa4ff"
        opacity: 0.06
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        x: parent.width - 360
        y: 50
        width: 620
        height: 620
        radius: 310
        color: "#18263e"
        opacity: 0.14
    }

    Rectangle {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        x: parent.width - 300
        y: parent.height - 260
        width: 400
        height: 400
        radius: 200
        color: "#20365b"
        opacity: 0.08
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 16
        radius: 28
        gradient: Gradient {
            GradientStop { position: 0; color: "#11182a" }
            GradientStop { position: 1; color: "#0e1424" }
        }
        border.color: "#2d3958"
        border.width: 1
        opacity: 0.98
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        Rectangle {
            Layout.preferredWidth: 282
            Layout.fillHeight: true
            radius: 24
            gradient: Gradient {
                GradientStop { position: 0; color: "#151c2d" }
                GradientStop { position: 1; color: "#11182a" }
            }
            border.color: borderColor
            border.width: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 16

                ColumnLayout {
                        spacing: 3

                    RowLayout {
                        spacing: 8

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 10
                            color: "#1e2a43"
                            border.color: accent
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "M3"
                                color: accent
                                font.pixelSize: 11
                                font.bold: true
                                font.family: titleFont
                            }
                        }

                        ColumnLayout {
                            spacing: 2

                            Text {
                                text: "DARMOSHARK"
                                color: accent
                                font.pixelSize: 20
                                font.bold: true
                                font.family: titleFont
                                font.letterSpacing: 1.1
                            }

                            Text {
                                text: "Shell do mouse"
                                color: textSecondary
                                font.pixelSize: 10
                                font.family: bodyFont
                                font.letterSpacing: 0.4
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2f3b5a"
                }

                Repeater {
                    model: navPages

                    delegate: Button {
                        id: navBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: 52
                        flat: true
                        checkable: true
                        checked: stackLayout.currentIndex === index
                        hoverEnabled: true
                        scale: navBtn.checked ? 1.01 : (navBtn.hovered ? 1.004 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                        background: Rectangle {
                            radius: 14
                            color: navBtn.checked ? "#242f49" : (navBtn.hovered ? "#162033" : (navBtn.down ? "#111829" : "transparent"))
                            border.color: navBtn.checked ? accent : "transparent"
                            border.width: navBtn.checked ? 1 : 0

                            Behavior on color {
                                ColorAnimation { duration: 140 }
                            }
                            Behavior on border.color {
                                ColorAnimation { duration: 140 }
                            }

                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 3
                                radius: 2
                                color: accent
                                opacity: navBtn.checked ? 0.9 : 0
                            }
                        }

                        contentItem: ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 11
                            spacing: 2

                            RowLayout {
                                spacing: 10

                                Rectangle {
                                    width: 20
                                    height: 20
                                    radius: 8
                                    color: navBtn.checked ? accent : "#1d2941"
                                    border.color: navBtn.checked ? accent : borderColor
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: navIcon(index)
                                        color: navBtn.checked ? "#041312" : textSecondary
                                        font.pixelSize: 11
                                        font.bold: true
                                    }
                                }

                                Text {
                                    text: modelData.title
                                    color: navBtn.checked ? textPrimary : textSecondary
                                    font.pixelSize: 13
                                    font.bold: navBtn.checked
                                    font.family: titleFont
                                }
                            }

                            Text {
                                text: modelData.subtitle
                                color: navBtn.checked ? accent : "#6b7573"
                                font.pixelSize: 8
                                font.family: bodyFont
                            }
                        }

                        onClicked: stackLayout.currentIndex = index
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    radius: 16
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#161d2f" }
                        GradientStop { position: 1; color: "#12182a" }
                    }
                    border.color: borderColor
                    border.width: 1
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 13
                        spacing: 6

                        RowLayout {
                            spacing: 8

                                Rectangle {
                                    width: 16
                                    height: 16
                                    radius: 5
                                    color: "#1d2941"
                                    border.color: borderColor
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: hidManager.deviceConnected ? "●" : "○"
                                        color: hidManager.deviceConnected ? accent : danger
                                        font.pixelSize: 8
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }

                            Text {
                                text: hidManager.deviceConnected ? "Dispositivo ativo" : "Sem dispositivo"
                                color: hidManager.deviceConnected ? accent : danger
                                font.pixelSize: 11
                                font.bold: true
                                font.family: titleFont
                            }
                        }

                        Text {
                            text: connectionLabel(hidManager.connectionMode)
                            color: textPrimary
                            font.pixelSize: 16
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            text: "Bateria " + hidManager.batteryLevel + "%"
                            color: textSecondary
                            font.pixelSize: 9
                            font.family: bodyFont
                        }
                    }
                }
            }
        }

        SwipeView {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            interactive: false
            currentIndex: 0

            Repeater {
                model: navPages.length

                Item {
                    width: stackLayout.width
                    height: stackLayout.height

                    Loader {
                        anchors.fill: parent
                        source: appRoot.pageSource(index)
                    }
                }
            }
        }
    }
}
