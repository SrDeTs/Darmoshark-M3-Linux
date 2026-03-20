import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: dpiRoot
    clip: true

    property int currentActiveStage: 0
    property color accent: "#00f5d4"
    property color panel: "#111614"
    property color panelAlt: "#151b19"
    property color panelDeep: "#0d1110"
    property color border: "#2a3331"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"

    function stageCountList() {
        return [1, 2, 3, 4, 5]
    }

    function connectionLabel() {
        if (!hidManager.connectionMode || hidManager.connectionMode.length === 0)
            return "Desconhecido"
        return hidManager.connectionMode === "2.4G Wireless" ? "Sem fio 2.4G"
             : hidManager.connectionMode === "Wired" ? "Cabo"
             : hidManager.connectionMode
    }

    Flickable {
        anchors.fill: parent
        contentWidth: dpiRoot.width
        contentHeight: contentColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: dpiRoot.width
            spacing: 16

            Rectangle {
                width: parent.width
                height: 88
                radius: 24
                color: panel
                border.color: border
                border.width: 1
                clip: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 14

                    Column {
                        width: parent.width - 170
                        spacing: 4

                        Text {
                            text: "PERFIS DE DPI"
                            color: textPrimary
                            font.pixelSize: 25
                            font.bold: true
                        }

                        Text {
                            text: "Edita os perfis, escolhe o estágio ativo e envia direto ao mouse."
                            color: textSecondary
                            font.pixelSize: 11
                        }
                    }

                    Rectangle {
                        width: 142
                        height: 42
                        radius: 21
                        color: "#103b33"
                        border.color: accent
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: configManager.dpiStages.length + " perfis"
                            color: accent
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: Math.round((parent.width - 16) * 0.64)
                    height: 558
                    radius: 24
                    color: panelAlt
                    border.color: border
                    border.width: 1
                    clip: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "ESTÁGIOS DISPONÍVEIS"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                        }

                        Repeater {
                            model: configManager.dpiStages.slice(0, dpiCountSelector.stageCount)

                            delegate: Rectangle {
                                width: parent.width
                                height: 86
                                radius: 18
                                color: dpiRoot.currentActiveStage === index ? "#12241f" : panelDeep
                                border.color: dpiRoot.currentActiveStage === index ? accent : border
                                border.width: dpiRoot.currentActiveStage === index ? 1.5 : 1
                                clip: true

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: dpiRoot.currentActiveStage = index
                                }

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 14

                                    Rectangle {
                                        width: 14
                                        height: 32
                                        radius: 3
                                        color: modelData.color || accent
                                    }

                                    Rectangle {
                                        width: 42
                                        height: 42
                                        radius: 13
                                        color: dpiRoot.currentActiveStage === index ? accent : "#1f2423"
                                        border.color: dpiRoot.currentActiveStage === index ? accent : border
                                        border.width: 1

                                        Text {
                                            anchors.centerIn: parent
                                            text: index + 1
                                            color: dpiRoot.currentActiveStage === index ? "#041312" : textPrimary
                                            font.pixelSize: 15
                                            font.bold: true
                                        }
                                    }

                                    Column {
                                        width: parent.width - 180
                                        spacing: 3

                                        Text {
                                            text: "ESTÁGIO " + (index + 1)
                                            color: dpiRoot.currentActiveStage === index ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                        }

                                        Row {
                                            spacing: 8

                                            Text {
                                                text: modelData.value
                                                color: textPrimary
                                                font.pixelSize: 22
                                                font.bold: true
                                            }

                                            Text {
                                                text: "DPI"
                                                color: textSecondary
                                                font.pixelSize: 11
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        TextField {
                                            id: dpiField
                                            width: 190
                                            height: 30
                                            text: modelData.value.toString()
                                            color: textPrimary
                                            font.pixelSize: 14
                                            inputMethodHints: Qt.ImhDigitsOnly
                                            selectByMouse: true
                                            background: Rectangle {
                                                radius: 10
                                                color: "#121716"
                                                border.color: "#25302e"
                                                border.width: 1
                                            }

                                            onEditingFinished: {
                                                let val = parseInt(text)
                                                if (!isNaN(val)) {
                                                    if (val < 100) val = 100
                                                    if (val > 26000) val = 26000
                                                    text = val.toString()
                                                    configManager.setDpiValue(index, val)
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        width: 74
                                        height: 30
                                        radius: 15
                                        color: dpiRoot.currentActiveStage === index ? "#103b33" : "#1a201f"
                                        border.color: dpiRoot.currentActiveStage === index ? accent : border
                                        border.width: 1

                                        Text {
                                            anchors.centerIn: parent
                                            text: dpiRoot.currentActiveStage === index ? "ATIVO" : "ESCOLHER"
                                            color: dpiRoot.currentActiveStage === index ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Column {
                    width: Math.round((parent.width - 16) * 0.36)
                    spacing: 16

                    Rectangle {
                        width: parent.width
                        height: 244
                        radius: 24
                        color: panel
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: "ESTÁGIO ATIVO"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                            }

                            Text {
                                text: (dpiRoot.currentActiveStage + 1) + "º"
                                color: accent
                                font.pixelSize: 48
                                font.bold: true
                            }

                            Text {
                                text: "A seleção muda o estágio que receberá o próximo envio."
                                color: textPrimary
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: border
                            }

                            Text {
                                text: "Modo atual: " + connectionLabel()
                                color: textSecondary
                                font.pixelSize: 11
                            }

                            Text {
                                text: hidManager.deviceConnected ? "Mouse pronto para receber" : "Sem dispositivo conectado"
                                color: hidManager.deviceConnected ? accent : "#c95f5f"
                                font.pixelSize: 12
                                font.bold: true
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 146
                        radius: 24
                        color: panelAlt
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: "QUANTIDADE DE ESTÁGIOS"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                            }

                            ComboBox {
                                id: dpiCountSelector
                                width: parent.width
                                property int stageCount: 5
                                model: stageCountList()
                                currentIndex: 4
                                background: Rectangle {
                                    radius: 12
                                    color: "#161c1b"
                                    border.color: border
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: dpiCountSelector.displayText
                                    color: textPrimary
                                    font.bold: true
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 12
                                }

                                onActivated: (idx) => {
                                    stageCount = model[idx]
                                    let slicedStages = configManager.dpiStages.slice(0, stageCount)
                                    hidManager.applyDpi(slicedStages, dpiRoot.currentActiveStage)
                                }
                            }

                            Button {
                                text: "APLICAR DPI"
                                width: parent.width
                                height: 46
                                enabled: hidManager.deviceConnected

                                background: Rectangle {
                                    radius: 14
                                    color: parent.enabled ? (parent.pressed ? "#00c5a5" : accent) : "#2d3635"
                                    border.color: parent.enabled ? accent : "#4a5452"
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: parent.enabled ? "#071412" : "#7d8785"
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: {
                                    let slicedStages = configManager.dpiStages.slice(0, dpiCountSelector.stageCount)
                                    hidManager.applyDpi(slicedStages, dpiRoot.currentActiveStage)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
