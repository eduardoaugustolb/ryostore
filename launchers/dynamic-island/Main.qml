pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Ryoku.Ui.Singletons

Scope {
    id: root

    property string monitor: ""
    property bool open: false
    readonly property var output: Quickshell.screens.find(screen =>
        screen.name === (root.monitor || Wm.focusedOutput)) ?? Quickshell.screens[0] ?? null
    readonly property bool shown: root.open && root.output !== null

    function show(monitor) {
        root.monitor = monitor || "";
        root.open = true;
    }

    function hide() {
        root.open = false;
    }

    LazyLoader {
        active: root.shown

        PanelWindow {
            screen: root.output
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "launcher"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            anchors { top: true; bottom: true; left: true; right: true }

            MouseArea {
                anchors.fill: parent
                onClicked: root.hide()
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y: 12
                width: Math.min(600, parent.width - 24)
                height: page.wantedHeight
                radius: 28
                color: Tokens.paperLift
                border.color: Tokens.lineStrong
                clip: true

                MouseArea { anchors.fill: parent }

                LauncherPage {
                    id: page
                    anchors.fill: parent
                    active: true
                    onDismissed: root.hide()
                }
            }
        }
    }
}
