import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import qs.components
import qs.config
import qs.services

ColumnLayout {
    id: root
    property string output: "*"
    property string projectPath: ""
    readonly property var properties: Wallpapers.propertiesFor(output, projectPath)
    spacing: 8
    function refresh() { Wallpapers.refreshSceneSettings(output, projectPath); }
    onOutputChanged: refresh()
    onProjectPathChanged: refresh()
    Connections {
        target: Wallpapers
        function onGlintStatusChanged() { root.refresh(); }
    }
    Text {
        Layout.fillWidth: true
        text: "Glint · wallpaper settings"
        color: Theme.primary
        font.family: Theme.font
        font.pixelSize: 14
    }
    TuiButton {
        visible: !Wallpapers.glintActive
        label: "start engine"
        onClicked: Wallpapers.startGlint()
    }
    Flickable {
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(fields.implicitHeight, 150)
        contentHeight: fields.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ColumnLayout {
            id: fields
            width: parent.width
            spacing: 6
            Repeater {
                model: root.properties
                ColumnLayout {
                    id: setting
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 4
                    Text {
                        Layout.fillWidth: true
                        text: Wallpapers.propertyLabel(setting.modelData) + (setting.modelData.mixed ? " · mixed" : "")
                        color: Theme.text
                        font.family: Theme.font
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }
                    TuiButton {
                        visible: setting.modelData.type === "bool"
                        label: setting.modelData.value === true ? "on" : "off"
                        active: setting.modelData.value === true
                        onClicked: Wallpapers.setSceneSetting(root.output, setting.modelData.name, !setting.modelData.value, root.projectPath)
                    }
                    Controls.ComboBox {
                        visible: setting.modelData.type === "combo"
                        Layout.fillWidth: true
                        model: setting.modelData.options ?? []
                        textRole: "label"
                        currentIndex: model.findIndex(o => JSON.stringify(o.value) === JSON.stringify(setting.modelData.value))
                        palette.button: Theme.bg
                        palette.buttonText: Theme.text
                        palette.text: Theme.text
                        palette.base: Theme.bg
                        palette.highlight: Theme.primary
                        onActivated: index => Wallpapers.setSceneSetting(root.output, setting.modelData.name, model[index].value, root.projectPath)
                    }
                    Controls.TextField {
                        id: input
                        visible: !["bool", "combo"].includes(setting.modelData.type)
                        Layout.fillWidth: true
                        color: Theme.text
                        font.family: Theme.font
                        font.pixelSize: 12
                        background: Rectangle { color: Theme.bg; border.width: 1; border.color: Theme.border }
                        Binding {
                            target: input
                            property: "text"
                            when: !input.activeFocus
                            value: setting.modelData.mixed ? "" : String(setting.modelData.value ?? "")
                        }
                        onAccepted: {
                            const value = setting.modelData.type === "slider" ? Number(text) : text;
                            if (setting.modelData.type !== "slider" || Number.isFinite(value))
                                Wallpapers.setSceneSetting(root.output, setting.modelData.name, value, root.projectPath);
                        }
                    }
                }
            }
        }
    }
    Text {
        Layout.fillWidth: true
        visible: Wallpapers.glintError !== ""
        text: Wallpapers.glintError
        color: Theme.primary
        font.family: Theme.font
        font.pixelSize: 12
        wrapMode: Text.Wrap
    }
}
