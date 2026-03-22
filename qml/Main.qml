import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects

ApplicationWindow {
    id: appRoot
    width: 1360
    height: 820
    minimumWidth: 1180
    minimumHeight: 720
    visible: true
    title: qsTr("Darmoshark M3 Configurator")
    color: "#0e0e0e"

    // Obsidian Glide Design System Colors
    property string titleFont: "Inter"
    property string bodyFont: "Inter"
    
    property color bgBase: "#0e0e0e"
    property color surfaceContainerLow: "#131313"
    property color surfaceContainer: "#191a1a"
    property color surfaceContainerHigh: "#1f2020"
    property color surfaceBright: "#2b2c2c"
    
    // Primary / Accents
    property color primary: "#a7c8ff"
    
    // Text
    property color onSurface: "#e7e5e5"
    property color onSurfaceVariant: "#a1afc6" // Fica um cinza azulado
    property color danger: "#ffb4ab"
    property bool configWarningDismissed: false
    property bool modalBlurActive: false

    property var navPages: [
        { title: "Início", subtitle: "Visão geral", source: "qrc:/qml/HomeView.qml" },
        { title: "DPI", subtitle: "Sensibilidade", source: "qrc:/qml/DPIView.qml" },
        { title: "Report Rate", subtitle: "Polling rate", source: "qrc:/qml/ReportRateView.qml" },
        { title: "Sensor", subtitle: "Performance", source: "qrc:/qml/SensorPerformanceView.qml" },
        { title: "LOD", subtitle: "Altura de corte", source: "qrc:/qml/LiftOffDistanceView.qml" },
        { title: "Scroll", subtitle: "Sentido", source: "qrc:/qml/ScrollDirectionView.qml" },
        { title: "E-Sports", subtitle: "Modo especial", source: "qrc:/qml/ESportsModeView.qml" },
        { title: "Config", subtitle: "Preferências", source: "qrc:/qml/SettingsView.qml" },
        { title: "Sobre", subtitle: "Informações", source: "qrc:/qml/AboutView.qml" }
    ]

    function connectionLabel(mode) {
        if (!mode || mode.length === 0) return "Desconhecido"
        if (mode === "2.4G Wireless") return "Sem fio 2.4G"
        if (mode === "Wired") return "Cabo USB"
        return mode
    }

    function navIcon(index) {
        if (index === 0) return "qrc:/images/IconsBar/Home.png"
        if (index === 1) return "qrc:/images/IconsBar/DPI.png"
        if (index === 2) return "qrc:/images/IconsBar/Report Rate.png"
        if (index === 3) return "qrc:/images/IconsBar/SensorPerformance.png"
        if (index === 4) return "qrc:/images/IconsBar/Lift Off Distance.png"
        if (index === 5) return "qrc:/images/IconsBar/ScrollDirection.png"
        if (index === 6) return "qrc:/images/IconsBar/E-SportMde.png"
        if (index === 7) return "qrc:/images/IconsBar/Config.png"
        return "qrc:/images/IconsBar/About.png"
    }

    function pageSource(index) {
        return navPages[index].source
    }

    Item {
        id: appScene
        anchors.fill: parent

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: "qrc:/images/BG-M3-Black.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            mipmap: true
            z: -1
        }

        SwipeView {
            id: stackLayout
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 136
            anchors.leftMargin: 8
            anchors.rightMargin: 8
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

        Rectangle {
            id: floatingBar
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            width: navLayout.implicitWidth + 32
            height: 84
            color: Qt.rgba(16 / 255, 17 / 255, 21 / 255, 0.42)
            radius: 24
            border.color: Qt.rgba(255/255, 255/255, 255/255, 0.10)
            border.width: 1

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 23
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.025) }
                    GradientStop { position: 1.0; color: Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.025) }
                }
            }

            RowLayout {
                id: navLayout
                anchors.centerIn: parent
                spacing: 4

                Repeater {
                    model: navPages

                    delegate: Button {
                        id: navBtn
                        Layout.fillHeight: true
                        Layout.preferredWidth: 88
                        Layout.maximumHeight: 76
                        flat: true
                        checkable: true
                        checked: stackLayout.currentIndex === index
                        hoverEnabled: true

                        background: Rectangle {
                            radius: 20
                            color: navBtn.checked ? Qt.rgba(167/255, 200/255, 255/255, 0.15) : (navBtn.hovered ? surfaceContainerHigh : "transparent")

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        contentItem: ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 4

                            Image {
                                Layout.alignment: Qt.AlignHCenter
                                source: navIcon(index)
                                sourceSize.width: 18
                                sourceSize.height: 18
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                opacity: navBtn.checked ? 1.0 : 0.72
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: modelData.title
                                color: navBtn.checked ? primary : onSurfaceVariant
                                font.pixelSize: 11
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        onClicked: stackLayout.currentIndex = index
                    }
                }
            }
        }
    }

    ShaderEffectSource {
        id: sceneSnapshot
        anchors.fill: parent
        sourceItem: appScene
        recursive: true
        live: true
        hideSource: false
        visible: false
    }

    MultiEffect {
        anchors.fill: parent
        source: sceneSnapshot
        autoPaddingEnabled: false
        blurEnabled: true
        blurMax: 48
        blurMultiplier: 1.0
        blur: 0.95
        visible: appRoot.modalBlurActive
        z: 90
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(8 / 255, 10 / 255, 14 / 255, appRoot.modalBlurActive ? 0.22 : 0.0)
        visible: appRoot.modalBlurActive
        z: 91
    }

    Rectangle {
        anchors.fill: parent
        z: 100
        visible: (configCreatedFirstRun || configRecoveredFromCorruption) && !appRoot.configWarningDismissed
        color: Qt.rgba(8, 10, 14, 0.62)

        Rectangle {
            width: Math.min(parent.width - 64, 560)
            height: 244
            anchors.centerIn: parent
            radius: 26
            color: "#151a25"
            border.color: Qt.rgba(167, 200, 255, 0.18)
            border.width: 1

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    GradientStop { position: 0; color: "#171e2b" }
                    GradientStop { position: 1; color: "#121722" }
                }
                opacity: 0.92
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 18

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        Layout.preferredWidth: 42
                        Layout.preferredHeight: 42
                        radius: 14
                        color: Qt.rgba(167, 200, 255, 0.14)
                        border.color: Qt.rgba(167, 200, 255, 0.22)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: configRecoveredFromCorruption ? "!" : "i"
                            color: primary
                            font.pixelSize: 22
                            font.bold: true
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        Text {
                            text: configRecoveredFromCorruption ? "Configuração recuperada" : "Configuração criada"
                            color: onSurface
                            font.pixelSize: 24
                            font.family: titleFont
                            font.bold: true
                            Layout.fillWidth: true
                        }

                        Text {
                            text: configRecoveredFromCorruption
                                  ? "O arquivo estava corrompido e foi recriado."
                                  : "O app criou a configuração inicial."
                            color: onSurfaceVariant
                            font.pixelSize: 13
                            font.family: bodyFont
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Qt.rgba(255, 255, 255, 0.06)
                }

                Text {
                    text: configRecoveredFromCorruption
                          ? "Arquivo: ~/.config/Darmoshark M3 Linux/config.toml"
                          : "Arquivo: ~/.config/Darmoshark M3 Linux/config.toml"
                    color: onSurfaceVariant
                    font.pixelSize: 12
                    font.family: bodyFont
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 12

                    Button {
                        text: "Abrir pasta"
                        Layout.preferredWidth: 140
                        Layout.preferredHeight: 40

                        background: Rectangle {
                            radius: 12
                            color: surfaceContainerHigh
                            border.color: Qt.rgba(255, 255, 255, 0.06)
                            border.width: 1
                        }

                        contentItem: Text {
                            text: parent.text
                            color: onSurface
                            font.family: titleFont
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: Qt.openUrlExternally(configDirectoryUrl)
                    }

                    Button {
                        text: "Entendi"
                        Layout.preferredWidth: 128
                        Layout.preferredHeight: 40

                        background: Rectangle {
                            radius: 12
                            color: primary
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "#0e0e0e"
                            font.family: titleFont
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: appRoot.configWarningDismissed = true
                    }
                }
            }
        }
    }
}
