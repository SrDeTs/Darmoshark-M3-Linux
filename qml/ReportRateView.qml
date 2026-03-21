import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: pageRoot
    clip: true

    property color accent: "#00f5d4"
    property color accentSoft: "#13c9af"
    property color border: "#2a3331"
    property color panelDeep: "#0d1110"
    property color textPrimary: "#f4f7f6"
    property color textSecondary: "#8b9593"
    property string titleFont: "Red Hat Display"
    property string bodyFont: "Fira Sans"

    QtObject { id: pollingRateGroup; property int currentValue: 1000 }

    function rateDescription(rate) {
        if (rate === 125) return "Máximo alcance"
        if (rate === 500) return "Equilibrado"
        return "Maior resposta"
    }

    Flickable {
        anchors.fill: parent
        contentWidth: pageRoot.width
        contentHeight: contentColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        Column {
            id: contentColumn
            width: pageRoot.width
            spacing: 16

            Rectangle {
                width: parent.width
                height: 124
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0; color: "#131917" }
                    GradientStop { position: 1; color: "#0e1211" }
                }
                border.color: accent
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 6

                    Text {
                        text: "REPORT RATE"
                        color: textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        text: "Taxa de atualização"
                        color: textPrimary
                        font.pixelSize: 24
                        font.bold: true
                        font.family: titleFont
                    }

                    Text {
                        width: parent.width
                        text: "Ajuste confirmado no USB e no 2.4G, com o mesmo padrão de pacote por modo."
                        color: textSecondary
                        font.pixelSize: 11
                        font.family: bodyFont
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: Math.round((parent.width - 16) * 0.62)
                    height: 430
                    radius: 24
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#151c1a" }
                        GradientStop { position: 1; color: "#101514" }
                    }
                    border.color: border
                    border.width: 1
                    clip: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        Text {
                            text: "TAXA DE ATUALIZAÇÃO (HZ)"
                            color: textSecondary
                            font.pixelSize: 10
                            font.bold: true
                            font.family: titleFont
                        }

                        Row {
                            width: parent.width
                            spacing: 12

                            Repeater {
                                model: [125, 500, 1000]

                                delegate: Rectangle {
                                    width: Math.floor((parent.width - 24) / 3)
                                    height: 126
                                    radius: 20
                                    scale: pollingRateGroup.currentValue === modelData ? 1.012 : (hit.containsMouse ? 1.004 : 1.0)
                                    Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: pollingRateGroup.currentValue === modelData ? "#103b33" : (hit.containsMouse ? "#131918" : "#101513") }
                                        GradientStop { position: 1; color: pollingRateGroup.currentValue === modelData ? "#0f2f29" : "#0c1010" }
                                    }
                                    border.color: pollingRateGroup.currentValue === modelData ? accent : border
                                    border.width: pollingRateGroup.currentValue === modelData ? 1.5 : 1
                                    clip: true

                                    MouseArea {
                                        id: hit
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: pollingRateGroup.currentValue = modelData
                                    }

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 16
                                        spacing: 8

                                        Text {
                                            text: modelData
                                            color: pollingRateGroup.currentValue === modelData ? accent : textPrimary
                                            font.pixelSize: 28
                                            font.bold: true
                                            font.family: titleFont
                                        }

                                        Text {
                                            text: "Hz"
                                            color: textSecondary
                                            font.pixelSize: 11
                                            font.family: bodyFont
                                        }

                                        Rectangle {
                                            width: 52
                                            height: 4
                                            radius: 2
                                            color: modelData === 125 ? "#ff6b6b" : (modelData === 500 ? "#5b8dff" : accent)
                                        }

                                        Text {
                                            width: parent.width
                                            text: rateDescription(modelData)
                                            color: pollingRateGroup.currentValue === modelData ? accent : textSecondary
                                            font.pixelSize: 10
                                            font.family: bodyFont
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 106
                            radius: 18
                            color: panelDeep
                            border.color: border
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text {
                                    text: "SELEÇÃO ATUAL"
                                    color: textSecondary
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: titleFont
                                }

                                Text {
                                    text: pollingRateGroup.currentValue + " Hz"
                                    color: textPrimary
                                    font.pixelSize: 34
                                    font.bold: true
                                    font.family: titleFont
                                }
                            }
                        }
                    }
                }

                Column {
                    width: Math.round((parent.width - 16) * 0.38)
                    spacing: 16

                    Rectangle {
                        width: parent.width
                        height: 160
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#121816" }
                            GradientStop { position: 1; color: "#0d1110" }
                        }
                        border.color: border
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: "APLICAÇÃO DIRETA"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "Clique em aplicar para enviar a taxa selecionada ao mouse."
                                color: textPrimary
                                font.pixelSize: 14
                                font.bold: true
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                            }

                            Button {
                                text: "APLICAR"
                                width: parent.width
                                height: 48
                                enabled: hidManager.deviceConnected
                                hoverEnabled: true
                                scale: parent.enabled && pressed ? 1.01 : (hovered ? 1.005 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

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
                                    font.family: titleFont
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: hidManager.applySettings(pollingRateGroup.currentValue)
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 140
                        radius: 24
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#131917" }
                            GradientStop { position: 1; color: "#0e1211" }
                        }
                        border.color: accentSoft
                        border.width: 1
                        clip: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "OBSERVAÇÃO"
                                color: textSecondary
                                font.pixelSize: 10
                                font.bold: true
                                font.family: titleFont
                            }

                            Text {
                                width: parent.width
                                text: "Aqui só fica o que foi confirmado na captura do driver original."
                                color: textPrimary
                                font.pixelSize: 13
                                font.bold: true
                                font.family: titleFont
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                width: parent.width
                                text: "Não misturar com outras funções do sensor."
                                color: textSecondary
                                font.pixelSize: 11
                                font.family: bodyFont
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
