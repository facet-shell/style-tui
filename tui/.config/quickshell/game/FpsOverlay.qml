import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.config
import qs.services

// Over the game while game mode is on and Config.fpsOverlay says so: one line in brackets,
// [game]─[144 fps]─[cpu 61%]─[gpu 87% 64°]. fps only when MangoHud runs in the game
// (GameStats); cpu and gpu from SystemStats. Clicks go through it; the corner is in the
// settings (Config.fpsOverlayPosition).
Scope {
    id: root

    property bool hidden: false

    readonly property string position: Config.fpsOverlayPosition
    readonly property bool top: !position.startsWith("bottom")
    readonly property bool left: !position.endsWith("right")

    // One [ … ] piece: a dim name before or a dim unit after the value
    component Piece: Row {
        id: piece

        property string name: ""
        property string value: ""
        property string unit: ""
        property color tint: Theme.text

        spacing: 0
        Text { text: "["; color: Theme.frame; font.family: Theme.font; font.pixelSize: 14 }
        Text { visible: piece.name !== ""; text: piece.name + " "; color: Theme.muted; font.family: Theme.font; font.pixelSize: 14 }
        Text { text: piece.value; color: piece.tint; font.family: Theme.font; font.pixelSize: 14; font.weight: Font.Medium }
        Text { visible: piece.unit !== ""; text: " " + piece.unit; color: Theme.muted; font.family: Theme.font; font.pixelSize: 14 }
        Text { text: "]"; color: Theme.frame; font.family: Theme.font; font.pixelSize: 14 }
    }

    component Joint: Text {
        text: "─"
        color: Theme.frame
        font.family: Theme.font
        font.pixelSize: 14
    }

    PanelWindow {
        screen: {
            const name = Hyprland.focusedMonitor?.name;
            return Quickshell.screens.find(s => s.name === name) ?? Quickshell.screens[0];
        }
        visible: !root.hidden && Config.fpsOverlay && Toggles.gameMode
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "qs-fps-overlay"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        anchors {
            top: root.top
            bottom: !root.top
            left: root.left
            right: !root.left
        }
        // Under the bar at the top, like the other popups
        margins {
            top: 66
            bottom: 14
            left: 24
            right: 24
        }
        implicitWidth: line.implicitWidth + 24
        implicitHeight: line.implicitHeight + 10

        // Clicks go through
        mask: Region {}

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.7)
            border.width: 1
            border.color: Theme.border
        }

        Row {
            id: line

            anchors.centerIn: parent
            spacing: 0

            Piece { value: "game"; tint: Theme.primary }
            Joint { visible: GameStats.fps >= 0 }
            Piece {
                visible: GameStats.fps >= 0
                value: GameStats.fps
                unit: "fps"
                tint: GameStats.fps < 30 ? Theme.danger : GameStats.fps < 55 ? Theme.warn : Theme.text
            }
            Joint {}
            Piece { name: "cpu"; value: `${Math.round(SystemStats.cpu)}%` }
            Joint { visible: SystemStats.gpuDir !== "" }
            Piece {
                visible: SystemStats.gpuDir !== ""
                name: "gpu"
                value: SystemStats.gpuTemp > 0 ? `${Math.round(SystemStats.gpu)}% ${Math.round(SystemStats.gpuTemp)}°` : `${Math.round(SystemStats.gpu)}%`
            }
        }
    }
}
