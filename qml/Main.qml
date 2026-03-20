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
        { title: "Início", subtitle: "Visão geral do dispositivo" },
        { title: "DPI", subtitle: "Perfis e sensibilidade" },
        { title: "Configurações", subtitle: "Resposta do sensor" }
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
        color: bgShell
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
            color: bgPanel
            border.color: borderColor
            border.width: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 16

                ColumnLayout {
                    spacing: 4

                    Text {
                        text: "DARMOSHARK"
                        color: accent
                        font.pixelSize: 22
                        font.bold: true
                        font.letterSpacing: 1.5
                    }

                    Text {
                        text: "M3 configurator"
                        color: textSecondary
                        font.pixelSize: 11
                        font.letterSpacing: 0.8
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
                        Layout.preferredHeight: 60
                        flat: true
                        checkable: true
                        checked: stackLayout.currentIndex === index
                        hoverEnabled: true

                        background: Rectangle {
                            radius: 16
                            color: navBtn.checked ? "#113b33" : (navBtn.down ? "#111918" : "transparent")
                            border.color: navBtn.checked ? accent : "transparent"
                            border.width: navBtn.checked ? 1 : 0

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
                            anchors.margins: 14
                            spacing: 2

                            Text {
                                text: modelData.title
                                color: navBtn.checked ? textPrimary : textSecondary
                                font.pixelSize: 15
                                font.bold: navBtn.checked
                            }

                            Text {
                                text: modelData.subtitle
                                color: navBtn.checked ? accent : "#6b7573"
                                font.pixelSize: 9
                            }
                        }

                        onClicked: stackLayout.currentIndex = index
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    height: 112
                    radius: 18
                    color: bgPanelAlt
                    border.color: borderColor
                    border.width: 1
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 6

                        Text {
                            text: hidManager.deviceConnected ? "Dispositivo conectado" : "Sem dispositivo"
                            color: hidManager.deviceConnected ? accent : danger
                            font.pixelSize: 12
                            font.bold: true
                        }

                        Text {
                            text: connectionLabel(hidManager.connectionMode)
                            color: textPrimary
                            font.pixelSize: 18
                            font.bold: true
                        }

                        Text {
                            text: "Bateria " + hidManager.batteryLevel + "%"
                            color: textSecondary
                            font.pixelSize: 10
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
                height: 88
                radius: 24
                color: bgPanel
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
                            font.pixelSize: 25
                            font.bold: true
                        }

                        Text {
                            text: appRoot.pageSubtitle(stackLayout.currentIndex)
                            color: textSecondary
                            font.pixelSize: 11
                        }
                    }

                    Rectangle {
                        width: 142
                        height: 42
                        radius: 21
                        color: hidManager.deviceConnected ? "#103b33" : "#301717"
                        border.color: hidManager.deviceConnected ? accent : danger
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: hidManager.deviceConnected ? "ONLINE" : "OFFLINE"
                            color: hidManager.deviceConnected ? accent : danger
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }
                }
            }

            StackLayout {
                id: stackLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                currentIndex: 0

                HomeView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                DPIView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                SettingsView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
