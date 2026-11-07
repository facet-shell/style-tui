import QtQuick
import QtQuick.Window
import Quickshell
import qs.wallpapers
import qs.services
import qs.config

ShellRoot {
    id: test
    property int phase: 0
    Component.onCompleted: Wallpapers.refresh()
    Window {
        visible: true
        width: 1200
        height: 900
        WallpaperView { id: view; anchors.fill: parent }
    }
    GlintProperties { id: controls; width: 350; output: "*"; projectPath: "/test/42" }
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            if (test.phase === 0) {
                if (Theme.frame === undefined) { console.error("Structural theme frame token missing"); Qt.exit(1); return; }
                if (!Wallpapers.glintActive || controls.properties.length !== 5) { console.error("Tui native properties missing"); Qt.exit(1); return; }
                Wallpapers.setDisplaySetting("*", "fps", 120);
            } else if (test.phase === 1) {
                if (view.displayOptions.fps !== 120 || view.displayOptions.mixed.fps) { console.error("Tui display options did not update"); Qt.exit(1); return; }
                view.current = view.shown.findIndex(w => w.id === "42");
                view.applyCurrent();
            } else {
                if (Wallpapers.current("*") !== "/test/42") { console.error("Tui apply failed"); Qt.exit(1); return; }
                console.log("Glint views smoke passed"); Qt.quit();
            }
            test.phase++;
        }
    }
}
