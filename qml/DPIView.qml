import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: dpiRoot
    anchors.fill: parent

    property color surfaceContainerLow: "#131313"
    property color surfaceContainer: "#191a1a"
    property color surfaceContainerHigh: "#1f2020"
    property color surfaceBright: "#2b2c2c"
    property color primary: "#a7c8ff"
    property color onSurface: "#e7e5e5"
    property color onSurfaceVariant: "#a1afc6"
    property color danger: "#ffb4ab"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"

    // Prettier versions of the base hardware colors
    property var stageColors: [
        "#FF5252", // Stage 1: Red
        "#448AFF", // Stage 2: Blue
        "#69F0AE", // Stage 3: Green
        "#E040FB", // Stage 4: Pink/Magenta
        "#18FFFF", // Stage 5: Cyan
        "#FFD740", // Stage 6: Yellow
        "#FFAB40"  // Stage 7: Orange
    ]

    property int renderStageCount: 6 // Model from screenshot shows 6 stages, though device might use less
    property int currentDpiValue: configManager.dpiStages[configManager.dpiCurrentStage] ? configManager.dpiStages[configManager.dpiCurrentStage].value : 0

    function stageCountList() { return [1, 2, 3, 4, 5, 6, 7] }

    function clampActiveStage(stageCount, activeStage) {
        if (stageCount <= 0)
            return 0
        if (activeStage >= stageCount)
            return stageCount - 1
        if (activeStage < 0)
            return 0
        return activeStage
    }

    Flickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: mainColumn.height + 120
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        ColumnLayout {
            id: mainColumn
            width: Math.min(parent.width - 64, 800)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 40
            spacing: 32

            // Top Header: Current DPI
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Current DPI"
                    color: onSurfaceVariant
                    font.pixelSize: 16
                    font.family: titleFont
                }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: configManager.dpiStages[configManager.dpiCurrentStage] ? configManager.dpiStages[configManager.dpiCurrentStage].value.toString() : "0"
                        color: onSurface
                        font.pixelSize: 64
                        font.bold: true
                        font.family: titleFont
                }
            }
            
            Item { Layout.preferredHeight: 16 } // Spacer

            // Controls Row (Toggles / Info)
            RowLayout {
                Layout.fillWidth: true
                
                RowLayout {
                    spacing: 8
                    Text {
                        text: "DPI Stages Ativos"
                        color: onSurfaceVariant
                        font.pixelSize: 14
                        font.family: bodyFont
                    }
                    ComboBox {
                        id: dpiCountSelector
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 28
                        model: stageCountList()
                        currentIndex: configManager.dpiStages.length > 0 ? (configManager.dpiStages.length - 1) : 4
                        background: Rectangle {
                            radius: 14
                            color: surfaceContainerHigh
                        }
                        contentItem: Text {
                            text: dpiCountSelector.displayText
                            color: onSurface
                            font.bold: true
                            font.family: bodyFont
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                        onActivated: (idx) => {
                            let newCount = stageCountList()[idx]
                            let slicedStages = configManager.dpiStages.slice(0, newCount)
                            let activeStage = dpiRoot.clampActiveStage(slicedStages.length, configManager.dpiCurrentStage)
                            configManager.setDpiCurrentStage(activeStage)
                            hidManager.applyDpi(slicedStages, activeStage)
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "APLICAR"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 36
                    enabled: hidManager.deviceConnected

                    background: Rectangle {
                        radius: 18
                        color: parent.enabled ? (parent.pressed ? surfaceBright : primary) : surfaceContainer
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    contentItem: Text {
                        text: parent.text
                        color: parent.enabled ? "#0e0e0e" : onSurfaceVariant
                        font.bold: true
                        font.family: titleFont
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        let slicedStages = configManager.dpiStages.slice(0, dpiCountSelector.currentIndex + 1)
                        let activeStage = dpiRoot.clampActiveStage(slicedStages.length, configManager.dpiCurrentStage)
                        configManager.setDpiCurrentStage(activeStage)
                        hidManager.applyDpi(slicedStages, activeStage)
                    }
                }
            }

            // Sliders List
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12

                Repeater {
                    model: configManager.dpiStages
                    
                    delegate: Rectangle {
                        id: stageRow
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
                        radius: 16
                        
                        // Highlight Logic: clear visual difference when selected
                        property bool isSelected: configManager.dpiCurrentStage === index
                        property color stageColor: dpiRoot.stageColors[index % dpiRoot.stageColors.length]
                        
                        color: isSelected ? dpiRoot.surfaceContainerHigh : dpiRoot.surfaceContainerLow
                        border.color: isSelected ? stageColor : "transparent"
                        border.width: isSelected ? 2 : 0

                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: configManager.setDpiCurrentStage(index)
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 24

                            RowLayout {
                                Layout.preferredWidth: 100
                                spacing: 12

                                Rectangle {
                                    width: 16
                                    height: 16
                                    radius: 4
                                    color: stageRow.stageColor
                                    border.color: stageRow.isSelected ? "#ffffff" : "transparent"
                                    border.width: stageRow.isSelected ? 2 : 0
                                }

                                Text {
                                    text: "Stage " + (index + 1)
                                    color: stageRow.isSelected ? onSurface : onSurfaceVariant
                                    font.pixelSize: 14
                                    font.bold: stageRow.isSelected
                                    font.family: bodyFont
                                }
                            }

                            Slider {
                                id: stageSlider
                                Layout.fillWidth: true
                                from: 100
                                to: 26000
                                stepSize: 50
                                value: modelData.value
                                
                                background: Rectangle {
                                    x: stageSlider.leftPadding
                                    y: stageSlider.topPadding + stageSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 6
                                    width: stageSlider.availableWidth
                                    height: implicitHeight
                                    radius: 3
                                    color: dpiRoot.surfaceContainer

                                    Rectangle {
                                        width: stageSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: stageRow.stageColor
                                        radius: 3
                                    }
                                }

                                handle: Rectangle {
                                    x: stageSlider.leftPadding + stageSlider.visualPosition * (stageSlider.availableWidth - width)
                                    y: stageSlider.topPadding + stageSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 18
                                    implicitHeight: 18
                                    radius: 9
                                    color: stageRow.stageColor
                                    border.color: stageSlider.pressed ? "#ffffff" : "#eeeeee"
                                    border.width: 2 // Make the handle clearly visible
                                }
                                
                                onValueChanged: {
                                    if (stageSlider.pressed) {
                                        valField.text = Math.round(value).toString()
                                    }
                                }
                                
                                onPressedChanged: {
                                    // Update backend ONLY on release to prevent model redraw from interrupting the drag!
                                    if (!stageSlider.pressed) {
                                        configManager.setDpiValue(index, Math.round(value))
                                    }
                                }
                            }

                            TextField {
                                id: valField
                                Layout.preferredWidth: 80
                                text: modelData.value.toString()
                                color: stageRow.isSelected ? onSurface : onSurfaceVariant
                                font.pixelSize: 16
                                font.family: bodyFont
                                font.bold: stageRow.isSelected
                                horizontalAlignment: TextInput.AlignRight
                                inputMethodHints: Qt.ImhDigitsOnly
                                
                                background: Item {} // Transparent background

                                onEditingFinished: {
                                    let val = parseInt(text)
                                    if (!isNaN(val)) {
                                        if (val < 100) val = 100
                                        if (val > 26000) val = 26000
                                        text = val.toString()
                                        stageSlider.value = val
                                        configManager.setDpiValue(index, val)
                                    } else {
                                        text = stageSlider.value.toString()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
