import QtQuick 2.15

Item {
    id: root

    property string activeSource: ""
    property string fallbackSource: ""
    property string incomingSource: ""
    property bool running: false
    property bool suspended: false

    signal transitionFinished(string activeSource)

    function resolvedBaseSource() {
        if (root.activeSource && root.activeSource.length > 0)
            return root.activeSource
        return root.fallbackSource
    }

    function startTransition(nextSource, nextIsLight, nextDirection) {
        if (root.suspended || !nextSource || nextSource.length === 0 || running)
            return

        if (!root.activeSource || root.activeSource.length === 0) {
            root.activeSource = nextSource
            transitionFinished(root.activeSource)
            return
        }

        if (nextSource === root.activeSource)
            return

        root.incomingSource = nextSource
        root.running = true
        incomingImage.opacity = 0.0
        transition.restart()
    }

    Image {
        id: baseImage
        anchors.fill: parent
        source: root.suspended ? "" : root.resolvedBaseSource()
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
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
    }

    NumberAnimation {
        id: transition
        target: incomingImage
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: 220
        easing.type: Easing.InOutCubic

        onFinished: {
            root.activeSource = root.incomingSource
            root.incomingSource = ""
            incomingImage.opacity = 0.0
            root.running = false
            root.transitionFinished(root.activeSource)
        }
    }
}
