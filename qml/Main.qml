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

    property var navPages: [
        { title: "Início", subtitle: "Visão geral", source: "qrc:/qml/HomeView.qml" },
        { title: "DPI", subtitle: "Sensibilidade", source: "qrc:/qml/DPIView.qml" },
        { title: "Report Rate", subtitle: "Polling rate", source: "qrc:/qml/ReportRateView.qml" },
        { title: "Sensor", subtitle: "Performance", source: "qrc:/qml/SensorPerformanceView.qml" },
        { title: "LOD", subtitle: "Altura de corte", source: "qrc:/qml/LiftOffDistanceView.qml" },
        { title: "Scroll", subtitle: "Sentido", source: "qrc:/qml/ScrollDirectionView.qml" },
        { title: "E-Sports", subtitle: "Modo especial", source: "qrc:/qml/ESportsModeView.qml" }
    ]

    function connectionLabel(mode) {
        if (!mode || mode.length === 0) return "Desconhecido"
        if (mode === "2.4G Wireless") return "Sem fio 2.4G"
        if (mode === "Wired") return "Cabo USB"
        return mode
    }

    function navIcon(index) {
        if (index === 0) return "⌂"
        if (index === 1) return "◉"
        if (index === 2) return "↻"
        if (index === 3) return "◌"
        if (index === 4) return "⇳"
        if (index === 5) return "⇅"
        return "⚑"
    }

    function pageSource(index) {
        return navPages[index].source
    }


    // Rich, Modern Background from Image
    Image {
        anchors.fill: parent
        source: "qrc:/images/BG-M3-Black.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
        z: -1
    }

    // Top Status Bar (Minimal)
    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 32
        height: 48
        spacing: 16
        z: 10 // Above SwipeView

        Text {
            text: "Darmoshark M3 - " + navPages[stackLayout.currentIndex].title
            color: onSurface
            font.pixelSize: 28
            font.family: titleFont
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true } // Spacer

        // Device Connection / Profile Node
        RowLayout {
            spacing: 12
            
            Rectangle {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 160
                radius: 12
                color: surfaceContainerHigh
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Text {
                        text: "⚙"
                        color: onSurfaceVariant
                        font.pixelSize: 14
                    }
                    Text {
                        text: "Profile 1" // Placeholder since app lacks profile switching
                        color: onSurfaceVariant
                        font.pixelSize: 14
                        font.family: bodyFont
                    }
                }
            }

            Rectangle {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 140
                radius: 12
                color: hidManager.deviceConnected ? Qt.rgba(167/255, 200/255, 255/255, 0.15) : surfaceContainerHigh
                border.color: hidManager.deviceConnected ? Qt.rgba(167/255, 200/255, 255/255, 0.3) : "transparent"
                border.width: 1
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Text {
                        text: "🔋"
                        color: hidManager.deviceConnected ? primary : onSurfaceVariant
                        font.pixelSize: 14
                    }
                    Text {
                        text: hidManager.deviceConnected ? ("Battery: " + hidManager.batteryLevel + "%") : "Sem conexão"
                        color: hidManager.deviceConnected ? primary : onSurfaceVariant
                        font.pixelSize: 14
                        font.family: bodyFont
                    }
                }
            }
        }
    }

    SwipeView {
        id: stackLayout
        anchors.fill: parent
        // Use margins to avoid content behind the floating bar
        anchors.topMargin: 100
        anchors.bottomMargin: 140 
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

    // Floating Pill Bar
    Rectangle {
        id: floatingBar
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        width: navLayout.implicitWidth + 32
        height: 84
        color: surfaceContainer // Darkish pill background
        radius: 24 // rounded rectangle style
        border.color: Qt.rgba(255/255, 255/255, 255/255, 0.05) // Ghost Border
        border.width: 1

        RowLayout {
            id: navLayout
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: navPages

                delegate: Button {
                    id: navBtn
                    Layout.fillHeight: true
                    Layout.preferredWidth: 84
                    Layout.maximumHeight: 76
                    flat: true
                    checkable: true
                    checked: stackLayout.currentIndex === index
                    hoverEnabled: true

                    background: Rectangle {
                        radius: 20
                        // Active gets a prominent blue block, typical of this design
                        color: navBtn.checked ? Qt.rgba(167/255, 200/255, 255/255, 0.15) : (navBtn.hovered ? surfaceContainerHigh : "transparent")
                        
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    contentItem: ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 4
                        
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: navIcon(index)
                            color: navBtn.checked ? primary : onSurface
                            font.pixelSize: 22
                            font.bold: true
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

    Rectangle {
        anchors.fill: parent
        z: 100
        visible: (configCreatedFirstRun || configRecoveredFromCorruption) && !appRoot.configWarningDismissed
        color: Qt.rgba(0, 0, 0, 0.55)

        Rectangle {
            width: Math.min(parent.width - 64, 520)
            height: 220
            anchors.centerIn: parent
            radius: 24
            color: surfaceContainerHigh
            border.color: Qt.rgba(255, 255, 255, 0.08)
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

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
                          ? "O arquivo de configuração estava corrompido. O app recriou um padrão em ~/.config/Darmoshark M3 Linux/config.toml."
                          : "O app criou a configuração inicial em ~/.config/Darmoshark M3 Linux/config.toml."
                    color: onSurfaceVariant
                    font.pixelSize: 14
                    font.family: bodyFont
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 12

                    Button {
                        text: "Abrir pasta"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 40

                        background: Rectangle {
                            radius: 14
                            color: surfaceContainerHigh
                            border.color: Qt.rgba(255, 255, 255, 0.08)
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
                        Layout.preferredWidth: 140
                        Layout.preferredHeight: 40

                        background: Rectangle {
                            radius: 14
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
