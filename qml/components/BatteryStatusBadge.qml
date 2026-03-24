import QtQuick 2.15

Rectangle {
    id: root

    property color textColor: "#e7e5e5"
    property string titleFont: "Inter"
    property bool batteryKnown: false
    property bool charging: false
    property int batteryLevel: -1
    readonly property color batteryColor: {
        if (!root.batteryKnown)
            return "#9aa6bc"
        if (root.charging)
            return "#7ed38b"
        if (root.batteryLevel <= 10)
            return "#ff6b6b"
        if (root.batteryLevel <= 20)
            return "#ff8c5a"
        if (root.batteryLevel <= 35)
            return "#ffb357"
        if (root.batteryLevel <= 60)
            return "#ffd166"
        return "#8ddf8a"
    }
    width: 118
    height: 84
    radius: 20
    color: "#191a1a"
    border.color: "#1f2020"
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: root.batteryKnown ? (root.batteryLevel + "%") : "--"
        color: root.batteryColor
        font.pixelSize: 33
        font.family: root.titleFont
        font.weight: Font.DemiBold
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.16)
    }
}
