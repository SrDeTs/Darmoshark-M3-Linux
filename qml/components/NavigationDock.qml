import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    property var navPages: []
    property int selectedIndex: 0
    property color surfaceContainer: "#191a1a"
    property color surfaceContainerHigh: "#1f2020"
    property string titleFont: "Inter"
    property var iconResolver

    signal navigateRequested(int index)

    width: navLayout.implicitWidth + 32
    height: 84
    color: root.surfaceContainer
    radius: 24
    border.color: "#1f2020"
    border.width: 1

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: 23
        color: root.surfaceContainer
    }

    RowLayout {
        id: navLayout
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: root.navPages

            delegate: Button {
                id: navBtn
                Layout.fillHeight: true
                Layout.preferredWidth: 68
                Layout.maximumHeight: 76
                flat: true
                checkable: true
                checked: root.selectedIndex === index
                hoverEnabled: true

                background: Rectangle {
                    width: (navBtn.checked || navBtn.hovered) ? 42 : 0
                    height: (navBtn.checked || navBtn.hovered) ? 42 : 0
                    anchors.centerIn: parent
                    radius: navBtn.checked ? 16 : 20
                    color: navBtn.checked ? Qt.rgba(167/255, 200/255, 255/255, 0.15) : (navBtn.hovered ? root.surfaceContainerHigh : "transparent")

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
                        source: root.iconResolver ? root.iconResolver(index) : ""
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
                    root.navigateRequested(index)
                }
            }
        }
    }
}
