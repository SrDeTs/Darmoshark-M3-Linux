import QtQuick 2.15

Rectangle {
    id: root

    property color textColor: "#e7e5e5"
    property string titleFont: "Inter"
    property bool batteryKnown: false
    property bool charging: false
    property int batteryLevel: -1
    property rect sourceRect: Qt.rect(0, 0, 0, 0)

    width: 118
    height: 84
    radius: 20
    color: "#191a1a"
    border.color: "#1f2020"
    border.width: 1

    Column {
        anchors.centerIn: parent
        spacing: 6

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 42
            height: 24
            source: "qrc:/images/Bateria/SpryteBateria.png"
            sourceClipRect: root.sourceRect
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.batteryKnown ? (root.batteryLevel + "%") : "--"
            color: root.textColor
            font.pixelSize: 17
            font.family: root.titleFont
            font.weight: Font.Medium
        }
    }
}
