import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt.labs.folderlistmodel 2.15
import "../idiomas/I18n.js" as I18n

Popup {
    id: root
    property string mode: "import"
    property string language: "pt-BR"
    property color cardColor: "#191a1a"
    property color cardBorder: "#1f2020"
    property color fieldColor: "#2b2c2c"
    property color textPrimary: "#e7e5e5"
    property color textSecondary: "#a1afc6"
    property color textMuted: "#8b8f98"
    property string titleFont: "Inter"
    property string bodyFont: "Inter"
    property url startFolder: configDirectoryUrl
    property url currentFolder: startFolder
    property string selectedFilePath: ""
    property string exportFileName: "darmoshark-m3-config.toml"

    signal importRequested(string path)
    signal exportRequested(string path)

    width: 640
    height: 520
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 160; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale"; from: 0.96; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
        }
    }

    exit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 120; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.98; duration: 120; easing.type: Easing.OutCubic }
        }
    }

    function normalizedFolderPath(urlValue) {
        var asString = String(urlValue || "")
        if (asString.startsWith("file://"))
            return asString.replace("file://", "")
        return asString
    }

    function ensureFolderUrl(value) {
        var asString = String(value || "")
        if (!asString.length)
            return startFolder
        if (asString.startsWith("file://"))
            return asString
        if (asString.startsWith("/"))
            return "file://" + asString
        return asString
    }

    function currentFolderDisplay() {
        return normalizedFolderPath(currentFolder)
    }

    function openImportDialog() {
        mode = "import"
        selectedFilePath = ""
        currentFolder = ensureFolderUrl(startFolder)
        open()
    }

    function openExportDialog() {
        mode = "export"
        selectedFilePath = ""
        currentFolder = ensureFolderUrl(startFolder)
        exportFileName = "darmoshark-m3-config.toml"
        open()
    }

    function parentFolderUrl() {
        var path = currentFolderDisplay()
        if (!path || path === "/")
            return currentFolder

        var trimmed = path.endsWith("/") && path.length > 1 ? path.slice(0, -1) : path
        var lastSlash = trimmed.lastIndexOf("/")
        if (lastSlash <= 0)
            return "file:///"
        return "file://" + trimmed.slice(0, lastSlash)
    }

    function selectedExportPath() {
        var base = currentFolderDisplay()
        var fileName = exportFileName.trim()
        if (!fileName.length)
            return ""
        if (!fileName.endsWith(".toml"))
            fileName += ".toml"
        if (base.endsWith("/"))
            return base + fileName
        return base + "/" + fileName
    }

    onVisibleChanged: {
        if (Window.window)
            Window.window.modalBlurActive = visible
    }

    FolderListModel {
        id: folderModel
        folder: root.ensureFolderUrl(root.currentFolder)
        showDirs: true
        showFiles: root.mode === "import"
        showDotAndDotDot: false
        nameFilters: root.mode === "import" ? ["*.toml"] : []
        sortField: FolderListModel.Name
    }

    background: Rectangle {
        radius: 24
        color: root.cardColor
        border.color: root.cardBorder
        border.width: 2
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 0

        Text {
            text: root.mode === "import"
                ? I18n.tr(root.language, "settings.modal_import_title")
                : I18n.tr(root.language, "settings.modal_export_title")
            color: root.textPrimary
            font.pixelSize: 24
            font.family: root.titleFont
            font.weight: Font.Medium
        }

        Item { Layout.preferredHeight: 14 }

        Text {
            text: I18n.tr(root.language, "settings.modal_current_folder")
            color: root.textSecondary
            font.pixelSize: 13
            font.family: root.bodyFont
        }

        Item { Layout.preferredHeight: 6 }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            radius: 12
            color: root.fieldColor

            Text {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                text: root.currentFolderDisplay()
                color: root.textPrimary
                font.pixelSize: 13
                font.family: root.bodyFont
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
            }
        }

        Item { Layout.preferredHeight: 10 }

        Button {
            Layout.preferredWidth: 110
            Layout.preferredHeight: 36
            text: I18n.tr(root.language, "settings.modal_up")
            enabled: root.currentFolderDisplay() !== "/"

            background: Rectangle {
                radius: 12
                color: root.fieldColor
                opacity: parent.enabled ? 1.0 : 0.5
            }

            contentItem: Text {
                text: parent.text
                color: root.textPrimary
                font.pixelSize: 13
                font.family: root.titleFont
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                root.currentFolder = root.parentFolderUrl()
                root.selectedFilePath = ""
            }
        }

        Item { Layout.preferredHeight: 14 }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 16
            color: "#161717"
            border.color: Qt.rgba(1, 1, 1, 0.05)
            border.width: 1

            ListView {
                id: fileList
                anchors.fill: parent
                anchors.margins: 8
                clip: true
                spacing: 6
                model: folderModel

                delegate: Item {
                    width: fileList.width
                    height: 44
                    readonly property bool isDirectory: fileIsDir
                    readonly property string absolutePath: String(filePath || "")
                    readonly property bool isSelected: !isDirectory && root.selectedFilePath === absolutePath

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: isSelected
                            ? Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.12)
                            : Qt.rgba(1, 1, 1, 0.03)
                        border.color: isSelected
                            ? Qt.rgba(167 / 255, 200 / 255, 255 / 255, 0.18)
                            : "transparent"
                        border.width: 1
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 10

                        Text {
                            text: isDirectory ? "📁" : "📄"
                            font.pixelSize: 15
                        }

                        Text {
                            Layout.fillWidth: true
                            text: fileName
                            color: root.textPrimary
                            font.pixelSize: 14
                            font.family: root.bodyFont
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (isDirectory) {
                                root.currentFolder = root.ensureFolderUrl(absolutePath)
                                root.selectedFilePath = ""
                            } else {
                                root.selectedFilePath = absolutePath
                            }
                        }
                        onDoubleClicked: {
                            if (isDirectory) {
                                root.currentFolder = root.ensureFolderUrl(absolutePath)
                                root.selectedFilePath = ""
                            } else if (root.mode === "import") {
                                root.importRequested(absolutePath)
                                root.close()
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: folderModel.count === 0
                    text: I18n.tr(root.language, "settings.modal_no_files")
                    color: root.textMuted
                    font.pixelSize: 14
                    font.family: root.bodyFont
                }
            }
        }

        Item { Layout.preferredHeight: 14 }

        ColumnLayout {
            Layout.fillWidth: true
            visible: root.mode === "export"
            spacing: 6

            Text {
                text: I18n.tr(root.language, "settings.modal_file_name")
                color: root.textSecondary
                font.pixelSize: 13
                font.family: root.bodyFont
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                radius: 12
                color: root.fieldColor

                TextField {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    text: root.exportFileName
                    color: root.textPrimary
                    font.pixelSize: 14
                    font.family: root.bodyFont
                    background: null
                    selectByMouse: true
                    onTextChanged: root.exportFileName = text
                }
            }
        }

        Item { Layout.preferredHeight: 14 }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: I18n.tr(root.language, "settings.cancel")

                background: Rectangle {
                    radius: 12
                    color: root.fieldColor
                }

                contentItem: Text {
                    text: parent.text
                    color: root.textPrimary
                    font.pixelSize: 14
                    font.family: root.titleFont
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: root.close()
            }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: root.mode === "import"
                    ? I18n.tr(root.language, "settings.modal_open")
                    : I18n.tr(root.language, "settings.modal_save")
                enabled: root.mode === "import"
                    ? root.selectedFilePath.length > 0
                    : root.selectedExportPath().length > 0

                background: Rectangle {
                    radius: 12
                    color: "#a7c8ff"
                    opacity: parent.enabled ? 1.0 : 0.5
                }

                contentItem: Text {
                    text: parent.text
                    color: "#101114"
                    font.pixelSize: 14
                    font.family: root.titleFont
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    if (root.mode === "import") {
                        root.importRequested(root.selectedFilePath)
                    } else {
                        root.exportRequested(root.selectedExportPath())
                    }
                    root.close()
                }
            }
        }
    }
}
