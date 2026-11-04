import QtQuick
import qs.config

// Square TUI button: 1px frame that lights up on hover or while `active`.
// With `label` (and an optional `hint`, a key like Super+C) it draws its own text the way
// the website shows the buttons: dim, brighter on hover, and while active filled with the
// accent and the text in the background color. Without a label put any content inside; it
// is centered unless you anchor it yourself, and `fg` is the text color to use.
// `solid: false` keeps the light tint for active ones, for toggles and swatches whose
// content has its own colors (the default without a label).
Rectangle {
    id: root

    property bool active: false
    // false: shown dimmed and ignores clicks (e.g. no Bluetooth adapter)
    property bool available: true
    property color accent: Theme.primary
    // Color of the label while neither active nor hovered
    property color ink: Theme.textDim
    property string label: ""
    property string hint: ""
    property int labelSize: 13
    property bool solid: label !== ""
    // What it shows when not active (Theme.bg to cover a frame line behind it)
    property color base: "transparent"
    readonly property bool hovered: area.containsMouse
    readonly property bool filled: active && solid && available
    readonly property color fg: !available ? Theme.muted : filled ? Theme.bg : hovered ? Theme.text : ink
    default property alias content: inner.data
    signal clicked()

    implicitWidth: label !== "" ? labelRow.implicitWidth + 24 : 0
    implicitHeight: label !== "" ? 28 : 0
    color: filled ? accent : active ? Qt.rgba(accent.r, accent.g, accent.b, 0.14) : base
    border.width: 1
    border.color: !available ? Theme.border : active || hovered ? accent : Theme.border
    opacity: available ? 1 : 0.45
    Behavior on color { ColorAnimation { duration: Theme.anim.fast } }
    Behavior on border.color { ColorAnimation { duration: Theme.anim.fast } }

    Item {
        id: inner
        anchors.fill: parent
    }

    Row {
        id: labelRow

        visible: root.label !== ""
        anchors.centerIn: parent
        spacing: 8

        Text {
            id: labelText
            text: root.label
            color: root.fg
            font.family: Theme.font
            font.pixelSize: root.labelSize
            Behavior on color { ColorAnimation { duration: Theme.anim.fast } }
        }
        Text {
            visible: root.hint !== ""
            anchors.baseline: labelText.baseline
            text: root.hint
            color: root.filled ? Theme.bg : Theme.muted
            opacity: root.filled ? 0.75 : 1
            font.family: Theme.font
            font.pixelSize: root.labelSize - 2
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.available ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (root.available)
                root.clicked();
        }
    }
}
