import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "idiomas/I18n.js" as I18n

ApplicationWindow {
    id: appRoot
    width: 1360
    height: 820
    minimumWidth: 1180
    minimumHeight: 720
    visible: true
    title: I18n.tr(configManager.language, "app.title")
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
    property bool themeTransitionRunning: false
    property bool pageTransitionRunning: false
    property string activeBackgroundSource: backgroundSource()
    property string incomingBackgroundSource: ""
    property int currentPageIndex: 0
    property int nextPageIndex: -1
    property int pageTransitionDirection: 1

    onClosing: function(close) {
        if (configManager.minimizeToTrayEnabled && appController.trayAvailable) {
            close.accepted = false
            appController.hideToTray()
        }
    }

    onVisibilityChanged: {
        if (visibility === Window.Minimized && configManager.minimizeToTrayEnabled && appController.trayAvailable) {
            appController.hideToTray()
        }
    }

    property var navPages: [
        { titleKey: "nav.home", subtitleKey: "nav.home_subtitle", source: "qrc:/qml/HomeView.qml" },
        { titleKey: "nav.dpi", subtitleKey: "nav.dpi_subtitle", source: "qrc:/qml/DPIView.qml" },
        { titleKey: "nav.report_rate", subtitleKey: "nav.report_rate_subtitle", source: "qrc:/qml/ReportRateView.qml" },
        { titleKey: "nav.sensor", subtitleKey: "nav.sensor_subtitle", source: "qrc:/qml/SensorPerformanceView.qml" },
        { titleKey: "nav.lod", subtitleKey: "nav.lod_subtitle", source: "qrc:/qml/LiftOffDistanceView.qml" },
        { titleKey: "nav.scroll", subtitleKey: "nav.scroll_subtitle", source: "qrc:/qml/ScrollDirectionView.qml" },
        { titleKey: "nav.esports", subtitleKey: "nav.esports_subtitle", source: "qrc:/qml/ESportsModeView.qml" },
        { titleKey: "nav.config", subtitleKey: "nav.config_subtitle", source: "qrc:/qml/SettingsView.qml" },
        { titleKey: "nav.about", subtitleKey: "nav.about_subtitle", source: "qrc:/qml/AboutView.qml" }
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

    function selectedNavIndex() {
        if (pageTransitionRunning && nextPageIndex >= 0)
            return nextPageIndex
        return currentPageIndex
    }

    function backgroundSource() {
        if (configManager.theme === "White")
            return "qrc:/images/BG-M3-White.png"
        return "qrc:/images/BG-M3-Black.png"
    }

    function updateThemeBackground() {
        var nextSource = backgroundSource()
        if (nextSource === activeBackgroundSource || themeTransitionRunning)
            return

        incomingBackgroundSource = nextSource
        themeTransitionRunning = true
        themeIncoming.opacity = 0.0
        themeIncoming.scale = 1.035
        themeOverlay.opacity = 0.0
        themeTransition.restart()
    }

    function navigateTo(index) {
        if (index === currentPageIndex || pageTransitionRunning)
            return

        nextPageIndex = index
        pageTransitionDirection = index > currentPageIndex ? 1 : -1
        incomingPageLayer.x = 40 * pageTransitionDirection
        incomingPageLayer.opacity = 0.0
        incomingPageLayer.scale = 0.992
        currentPageLayer.x = 0
        currentPageLayer.opacity = 1.0
        currentPageLayer.scale = 1.0
        incomingPageLoader.source = pageSource(index)
        pageTransitionRunning = true
        pageTransition.restart()
    }

    Connections {
        target: configManager

        function onThemeChanged() {
            appRoot.updateThemeBackground()
        }
    }

    Item {
        id: appScene
        anchors.fill: parent

        Image {
            id: backgroundBase
            anchors.fill: parent
            source: activeBackgroundSource
            fillMode: Image.PreserveAspectCrop
            smooth: true
            mipmap: true
            z: -1
        }

        Image {
            id: themeIncoming
            anchors.fill: parent
            source: incomingBackgroundSource
            fillMode: Image.PreserveAspectCrop
            smooth: true
            mipmap: true
            opacity: 0.0
            scale: 1.0
            visible: opacity > 0.0 || appRoot.themeTransitionRunning
            z: -1
        }

        Rectangle {
            id: themeOverlay
            anchors.fill: parent
            color: configManager.theme === "White"
                   ? Qt.rgba(248 / 255, 250 / 255, 255 / 255, 0.12)
                   : Qt.rgba(11 / 255, 13 / 255, 18 / 255, 0.22)
            opacity: 0.0
            z: 0
        }

        Item {
            id: pageViewport
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 136
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            clip: true

            Item {
                id: currentPageLayer
                anchors.fill: parent

                Loader {
                    id: currentPageLoader
                    anchors.fill: parent
                    source: appRoot.pageSource(appRoot.currentPageIndex)
                }
            }

            Item {
                id: incomingPageLayer
                anchors.fill: parent
                opacity: 0.0
                visible: opacity > 0.0 || appRoot.pageTransitionRunning

                Loader {
                    id: incomingPageLoader
                    anchors.fill: parent
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
            color: "#191a1a"
            radius: 24
            border.color: "#1f2020"
            border.width: 1

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 23
                color: "#191a1a"
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
                        Layout.preferredWidth: 68
                        Layout.maximumHeight: 76
                        flat: true
                        checkable: true
                        checked: appRoot.selectedNavIndex() === index
                        hoverEnabled: true

                        background: Rectangle {
                            width: (navBtn.checked || navBtn.hovered) ? 42 : 0
                            height: (navBtn.checked || navBtn.hovered) ? 42 : 0
                            anchors.centerIn: parent
                            radius: navBtn.checked ? 16 : 20
                            color: navBtn.checked ? Qt.rgba(167/255, 200/255, 255/255, 0.15) : (navBtn.hovered ? surfaceContainerHigh : "transparent")

                            Behavior on color { ColorAnimation { duration: 200 } }
                            Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                            Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                            Behavior on radius { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                        }

                        contentItem: ColumnLayout {
                            id: navContent
                            anchors.centerIn: parent
                            width: 22
                            height: 22
                            spacing: 0
                            scale: 1.0

                            Image {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                                source: navIcon(index)
                                sourceSize.width: 18
                                sourceSize.height: 18
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                opacity: navBtn.checked ? 1.0 : 0.72
                            }
                        }

                        SequentialAnimation {
                            id: clickPulse

                            NumberAnimation {
                                target: navContent
                                property: "scale"
                                from: 1.0
                                to: 0.82
                                duration: 80
                                easing.type: Easing.OutCubic
                            }

                            NumberAnimation {
                                target: navContent
                                property: "scale"
                                from: 0.82
                                to: 1.0
                                duration: 170
                                easing.type: Easing.OutBack
                            }
                        }

                        onClicked: {
                            clickPulse.restart()
                            appRoot.navigateTo(index)
                        }
                    }
                }
            }
        }
    }

    ParallelAnimation {
        id: pageTransition

        ParallelAnimation {
            NumberAnimation {
                target: currentPageLayer
                property: "x"
                from: 0
                to: -34 * appRoot.pageTransitionDirection
                duration: 240
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: currentPageLayer
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 220
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: currentPageLayer
                property: "scale"
                from: 1.0
                to: 0.992
                duration: 240
                easing.type: Easing.OutCubic
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: incomingPageLayer
                property: "x"
                from: 40 * appRoot.pageTransitionDirection
                to: 0
                duration: 340
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: incomingPageLayer
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 300
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: incomingPageLayer
                property: "scale"
                from: 0.992
                to: 1.0
                duration: 340
                easing.type: Easing.OutCubic
            }
        }

        onFinished: {
            appRoot.currentPageIndex = appRoot.nextPageIndex
            appRoot.nextPageIndex = -1
            appRoot.pageTransitionRunning = false
            currentPageLayer.x = 0
            currentPageLayer.opacity = 1.0
            currentPageLayer.scale = 1.0
            incomingPageLayer.x = 0
            incomingPageLayer.opacity = 0.0
            incomingPageLayer.scale = 1.0
            incomingPageLoader.source = ""
        }
    }

    ParallelAnimation {
        id: themeTransition

        SequentialAnimation {
            NumberAnimation {
                target: themeOverlay
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 180
                easing.type: Easing.OutCubic
            }
            PauseAnimation { duration: 40 }
            NumberAnimation {
                target: themeOverlay
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 320
                easing.type: Easing.InOutCubic
            }
        }

        NumberAnimation {
            target: themeIncoming
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 420
            easing.type: Easing.InOutCubic
        }

        NumberAnimation {
            target: themeIncoming
            property: "scale"
            from: 1.035
            to: 1.0
            duration: 520
            easing.type: Easing.OutCubic
        }

        onFinished: {
            appRoot.activeBackgroundSource = appRoot.incomingBackgroundSource
            appRoot.incomingBackgroundSource = ""
            appRoot.themeTransitionRunning = false
            themeIncoming.opacity = 0.0
            themeIncoming.scale = 1.0
            themeOverlay.opacity = 0.0
        }
    }

    MultiEffect {
        anchors.fill: parent
        source: appScene
        autoPaddingEnabled: false
        blurEnabled: true
        blurMax: 96
        blurMultiplier: 1.6
        blur: 1.0
        brightness: -0.04
        saturation: -0.1
        visible: appRoot.modalBlurActive
        z: 90
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(8 / 255, 10 / 255, 14 / 255, appRoot.modalBlurActive ? 0.34 : 0.0)
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
                            text: configRecoveredFromCorruption
                                  ? I18n.tr(configManager.language, "main.config_recovered")
                                  : I18n.tr(configManager.language, "main.config_created")
                            color: onSurface
                            font.pixelSize: 24
                            font.family: titleFont
                            font.bold: true
                            Layout.fillWidth: true
                        }

                        Text {
                            text: configRecoveredFromCorruption
                                  ? I18n.tr(configManager.language, "main.config_recovered_desc")
                                  : I18n.tr(configManager.language, "main.config_created_desc")
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
                        text: I18n.tr(configManager.language, "common.open_folder")
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
                        text: I18n.tr(configManager.language, "common.ok_got_it")
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
