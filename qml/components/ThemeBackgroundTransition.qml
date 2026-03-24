import QtQuick 2.15

Item {
    id: root

    property string activeSource: ""
    property string fallbackSource: ""
    property string incomingSource: ""
    property bool running: false
    property bool lightTheme: false
    property int direction: 1
    property bool suspended: false

    signal transitionFinished(string activeSource)

    function startTransition(nextSource, nextIsLight, nextDirection) {
        if (!nextSource || nextSource.length === 0 || running)
            return

        if (!activeSource || activeSource.length === 0) {
            activeSource = nextSource
            transitionFinished(activeSource)
            return
        }

        if (nextSource === activeSource)
            return

        incomingSource = nextSource
        lightTheme = nextIsLight
        direction = nextDirection
        running = true

        incomingImage.opacity = 0.0
        incomingScale.xScale = 1.095
        incomingScale.yScale = 1.095
        incomingTranslate.x = 64 * direction
        incomingTranslate.y = -18

        baseImage.opacity = 1.0
        baseScale.xScale = 1.0
        baseScale.yScale = 1.0

        wash.opacity = 0.0
        highlight.opacity = 0.0
        highlightTranslate.x = -width - highlight.width

        transition.restart()
    }

    Image {
        id: baseImage
        anchors.fill: parent
        source: root.suspended ? "" : (root.activeSource && root.activeSource.length > 0 ? root.activeSource : root.fallbackSource)
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
        z: -1
        transform: Scale {
            id: baseScale
            origin.x: root.width / 2
            origin.y: root.height / 2
            xScale: 1.0
            yScale: 1.0
        }
    }

    Image {
        id: incomingImage
        anchors.fill: parent
        source: root.suspended ? "" : root.incomingSource
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
        opacity: 0.0
        visible: opacity > 0.0 || root.running
        z: -1
        transform: [
            Translate {
                id: incomingTranslate
                x: 0
                y: 0
            },
            Scale {
                id: incomingScale
                origin.x: root.width / 2
                origin.y: root.height / 2
                xScale: 1.0
                yScale: 1.0
            }
        ]
    }

    Rectangle {
        id: wash
        anchors.fill: parent
        color: root.lightTheme
               ? Qt.rgba(246 / 255, 249 / 255, 255 / 255, 0.14)
               : Qt.rgba(10 / 255, 12 / 255, 18 / 255, 0.24)
        opacity: 0.0
        z: 0
    }

    Rectangle {
        id: highlight
        width: root.width * 0.52
        height: root.height * 1.35
        y: -root.height * 0.18
        rotation: 12
        radius: width / 2
        opacity: 0.0
        visible: opacity > 0.0 || root.running
        z: 1
        transform: Translate {
            id: highlightTranslate
            x: -root.width
            y: 0
        }
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: root.lightTheme
                       ? Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.0)
                       : Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.0)
            }
            GradientStop {
                position: 0.48
                color: root.lightTheme
                       ? Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.17)
                       : Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.10)
            }
            GradientStop {
                position: 1.0
                color: root.lightTheme
                       ? Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.0)
                       : Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.0)
            }
        }
    }

    ParallelAnimation {
        id: transition

        SequentialAnimation {
            NumberAnimation {
                target: wash
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 180
                easing.type: Easing.OutCubic
            }
            PauseAnimation { duration: 36 }
            NumberAnimation {
                target: wash
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 340
                easing.type: Easing.InOutCubic
            }
        }

        SequentialAnimation {
            NumberAnimation {
                target: highlight
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 120
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: highlight
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 310
                easing.type: Easing.InOutCubic
            }
        }

        NumberAnimation {
            target: highlightTranslate
            property: "x"
            from: -root.width - highlight.width * 0.35
            to: root.width + highlight.width * 0.15
            duration: 480
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: incomingImage
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 430
            easing.type: Easing.InOutCubic
        }

        NumberAnimation {
            target: incomingScale
            property: "xScale"
            from: 1.095
            to: 1.0
            duration: 620
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: incomingScale
            property: "yScale"
            from: 1.095
            to: 1.0
            duration: 620
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: incomingTranslate
            property: "x"
            from: 64 * root.direction
            to: 0
            duration: 620
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: incomingTranslate
            property: "y"
            from: -18
            to: 0
            duration: 620
            easing.type: Easing.OutCubic
        }

        SequentialAnimation {
            NumberAnimation {
                target: baseImage
                property: "opacity"
                from: 1.0
                to: 0.42
                duration: 220
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: baseImage
                property: "opacity"
                from: 0.42
                to: 1.0
                duration: 320
                easing.type: Easing.InOutCubic
            }
        }

        NumberAnimation {
            target: baseScale
            property: "xScale"
            from: 1.0
            to: 1.04
            duration: 520
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: baseScale
            property: "yScale"
            from: 1.0
            to: 1.04
            duration: 520
            easing.type: Easing.OutCubic
        }

        onFinished: {
            root.activeSource = root.incomingSource
            root.incomingSource = ""
            root.running = false

            incomingImage.opacity = 0.0
            incomingScale.xScale = 1.0
            incomingScale.yScale = 1.0
            incomingTranslate.x = 0
            incomingTranslate.y = 0

            baseImage.opacity = 1.0
            baseScale.xScale = 1.0
            baseScale.yScale = 1.0

            wash.opacity = 0.0
            highlight.opacity = 0.0
            highlightTranslate.x = -root.width - highlight.width

            root.transitionFinished(root.activeSource)
        }
    }
}
