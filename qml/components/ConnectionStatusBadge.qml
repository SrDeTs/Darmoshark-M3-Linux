import QtQuick 2.15
import QtQuick.Controls 2.15
import "../idiomas/I18n.js" as I18n

Rectangle {
    id: root
    width: 124
    height: 84
    radius: 20

    property string language: "pt-BR"
    property string connectionMode: ""
    property bool connected: false
    property string titleFont: "Inter"
    property color textColor: "#e7e5e5"
    property color secondaryTextColor: "#a1afc6"

    readonly property string statusKey: {
        if (!connected)
            return "connection.disconnected"
        if (connectionMode === "2.4G Wireless")
            return "connection.wireless"
        if (connectionMode === "Wired")
            return "connection.wired"
        return "connection.unknown"
    }
    readonly property bool wireless: connected && connectionMode === "2.4G Wireless"
    readonly property bool wired: connected && connectionMode === "Wired"
    readonly property color accentColor: {
        if (!connected)
            return Qt.rgba(140 / 255, 146 / 255, 158 / 255, 1.0)
        if (wireless)
            return Qt.rgba(167 / 255, 200 / 255, 255 / 255, 1.0)
        if (wired)
            return Qt.rgba(125 / 255, 214 / 255, 181 / 255, 1.0)
        return Qt.rgba(167 / 255, 200 / 255, 255 / 255, 1.0)
    }
    readonly property color accentFillColor: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, connected ? 0.14 : 0.08)
    readonly property string displayText: I18n.tr(language, statusKey)

    color: "#191a1a"
    border.color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.18)
    border.width: 1

    function refreshDisplay(initial) {
        if (initial || currentLabel.text.length === 0) {
            currentLabel.text = displayText
            currentLabel.color = root.textColor
            currentLabel.opacity = 1.0
            currentLabel.y = 0
            pulse.restart()
            return
        }

        if (currentLabel.text === displayText)
            return

        outgoingLabel.text = currentLabel.text
        outgoingLabel.opacity = 1.0
        outgoingLabel.y = 0

        currentLabel.text = displayText
        currentLabel.opacity = 0.0
        currentLabel.y = 8

        switchAnimation.restart()
        pulse.restart()
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: 19
        color: "#191a1a"
    }

    Rectangle {
        id: pulseOverlay
        anchors.fill: parent
        radius: parent.radius
        color: root.accentFillColor
        opacity: 0.0
    }

    Column {
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: I18n.tr(root.language, "connection.title")
            color: root.secondaryTextColor
            font.pixelSize: 11
            font.family: root.titleFont
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2
        }

        Item {
            width: 88
            height: 34

            Text {
                id: outgoingLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: root.textColor
                font.pixelSize: 16
                font.family: root.titleFont
                font.weight: Font.Medium
                opacity: 0.0
            }

            Text {
                id: currentLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: root.textColor
                font.pixelSize: 16
                font.family: root.titleFont
                font.weight: Font.Medium
            }
        }
    }

    SequentialAnimation {
        id: pulse

        NumberAnimation {
            target: pulseOverlay
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 110
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: pulseOverlay
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 260
            easing.type: Easing.InOutCubic
        }
    }

    ParallelAnimation {
        id: switchAnimation

        NumberAnimation {
            target: outgoingLabel
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 180
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: outgoingLabel
            property: "y"
            from: 0
            to: -8
            duration: 180
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: currentLabel
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 220
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: currentLabel
            property: "y"
            from: 8
            to: 0
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    Behavior on border.color {
        ColorAnimation { duration: 220 }
    }

    Behavior on color {
        ColorAnimation { duration: 220 }
    }

    onDisplayTextChanged: refreshDisplay(false)
    Component.onCompleted: refreshDisplay(true)
}
