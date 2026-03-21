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
    color: "#050707"

    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"
    property color bgBase: "#050707"
    property color bgShell: "#0b0f0e"
    property color bgPanel: "#101514"
    property color bgPanelAlt: "#151b19"
    property color bgCard: "#121816"
    property color borderColor: "#26302f"
    property color accent: "#00f5d4"
    property color accentSoft: "#14c7ae"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"
    property color danger: "#ff6b6b"

    property var navPages: [
        { title: "Início", subtitle: "Visão geral do dispositivo", source: "qrc:/qml/HomeView.qml" },
        { title: "DPI", subtitle: "Perfis e sensibilidade", source: "qrc:/qml/DPIView.qml" },
        { title: "Report Rate", subtitle: "Taxa de atualização", source: "qrc:/qml/ReportRateView.qml" },
        { title: "Sensor Performance", subtitle: "Motion Sync e Angle Snap", source: "qrc:/qml/SensorPerformanceView.qml" },
        { title: "Lift Off Distance", subtitle: "Altura de levantamento", source: "qrc:/qml/LiftOffDistanceView.qml" },
        { title: "Scroll Direction", subtitle: "Sentido da rolagem", source: "qrc:/qml/ScrollDirectionView.qml" },
        { title: "E-Sports Mode", subtitle: "Perfil especial", source: "qrc:/qml/ESportsModeView.qml" }
    ]

    function pageTitle(index) {
        return navPages[index].title
    }

    function pageSubtitle(index) {
        return navPages[index].subtitle
    }

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
        color: accent
        opacity: 0.07
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        x: parent.width - 360
        y: 50
        width: 620
        height: 620
        radius: 310
        color: "#17302b"
        opacity: 0.13
    }

    Rectangle {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        x: parent.width - 300
        y: parent.height - 260
        width: 400
        height: 400
        radius: 200
        color: "#0d4a3d"
        opacity: 0.07
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 16
        radius: 28
        gradient: Gradient {
            GradientStop { position: 0; color: "#0d1110" }
            GradientStop { position: 1; color: "#090d0c" }
        }
        border.color: "#2c3533"
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
                GradientStop { position: 0; color: "#111716" }
                GradientStop { position: 1; color: "#0d1110" }
            }
            border.color: borderColor
            border.width: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 16

                ColumnLayout {
                    spacing: 4

                    RowLayout {
                        spacing: 10

                        Rectangle {
                            width: 34
                            height: 34
                            radius: 12
                            color: "#0f2320"
                            border.color: accent
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "M3"
                                color: accent
                                font.pixelSize: 12
                                font.bold: true
                                font.family: titleFont
                            }
                        }

                        ColumnLayout {
                            spacing: 2

                            Text {
                                text: "DARMOSHARK"
                                color: accent
                                font.pixelSize: 22
                                font.bold: true
                                font.family: titleFont
                                font.letterSpacing: 1.5
                            }

                            Text {
                                text: "DPI / Sensor shell"
                                color: textSecondary
                                font.pixelSize: 11
                                font.family: bodyFont
                                font.letterSpacing: 0.8
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#27312f"
                }

                Repeater {
                    model: navPages

                    delegate: Button {
                        id: navBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: 56
                        flat: true
                        checkable: true
                        checked: stackLayout.currentIndex === index
                        hoverEnabled: true
                        scale: navBtn.checked ? 1.015 : (navBtn.hovered ? 1.005 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                        background: Rectangle {
                            radius: 16
                            color: navBtn.checked ? "#113b33" : (navBtn.hovered ? "#0e1715" : (navBtn.down ? "#111918" : "transparent"))
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
                                width: 4
                                radius: 2
                                color: accent
                                opacity: navBtn.checked ? 1 : 0
                            }
                        }

                        contentItem: ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 2

                            RowLayout {
                                spacing: 10

                                Rectangle {
                                    width: 22
                                    height: 22
                                    radius: 8
                                    color: navBtn.checked ? accent : "#16211f"
                                    border.color: navBtn.checked ? accent : "#26302f"
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: navIcon(index)
                                        color: navBtn.checked ? "#041312" : textSecondary
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }

                                Text {
                                    text: modelData.title
                                    color: navBtn.checked ? textPrimary : textSecondary
                                    font.pixelSize: 14
                                    font.bold: navBtn.checked
                                    font.family: titleFont
                                }
                            }

                            Text {
                                text: modelData.subtitle
                                color: navBtn.checked ? accent : "#6b7573"
                                font.pixelSize: 9
                                font.family: bodyFont
                            }
                        }

                        onClicked: stackLayout.currentIndex = index
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    height: 108
                    radius: 18
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#141a19" }
                        GradientStop { position: 1; color: "#101514" }
                    }
                    border.color: borderColor
                    border.width: 1
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 6

                        RowLayout {
                            spacing: 8

                                Rectangle {
                                    width: 18
                                    height: 18
                                    radius: 6
                                    color: "#18211f"
                                    border.color: borderColor
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: hidManager.deviceConnected ? "●" : "○"
                                        color: hidManager.deviceConnected ? accent : danger
                                        font.pixelSize: 9
                                        font.bold: true
                                        font.family: titleFont
                                    }
                                }

                            Text {
                                text: hidManager.deviceConnected ? "Dispositivo ativo" : "Sem dispositivo"
                                color: hidManager.deviceConnected ? accent : danger
                                font.pixelSize: 12
                                font.bold: true
                                font.family: titleFont
                            }
                        }

                        Text {
                            text: connectionLabel(hidManager.connectionMode)
                            color: textPrimary
                            font.pixelSize: 18
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            text: "Bateria " + hidManager.batteryLevel + "%"
                            color: textSecondary
                            font.pixelSize: 10
                            font.family: bodyFont
                        }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                height: 84
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#121817" }
                    GradientStop { position: 1; color: "#0f1312" }
                }
                border.color: borderColor
                border.width: 1
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 14

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: appRoot.pageTitle(stackLayout.currentIndex)
                            color: textPrimary
                            font.pixelSize: 24
                            font.bold: true
                            font.family: titleFont
                        }

                        Text {
                            text: appRoot.pageSubtitle(stackLayout.currentIndex)
                            color: textSecondary
                            font.pixelSize: 11
                            font.family: bodyFont
                        }
                    }

                    Rectangle {
                        width: 142
                        height: 40
                        radius: 21
                        color: hidManager.deviceConnected ? "#103b33" : "#301717"
                        border.color: hidManager.deviceConnected ? accent : danger
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: hidManager.deviceConnected ? "ONLINE" : "OFFLINE"
                            color: hidManager.deviceConnected ? accent : danger
                            font.pixelSize: 11
                            font.bold: true
                            font.family: titleFont
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
}
