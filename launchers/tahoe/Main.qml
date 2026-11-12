import QtQuick
import Quickshell
import Quickshell.Io
import shell.services
import Ryoku.Ui.Singletons
import "lib/catalog.js" as Catalog

Scope {
    id: root
    property bool openRequested: false
    readonly property bool shown: openRequested || closing.running
    property string monitor: ""
    property string query: ""
    property string section: "all"
    property int selected: 0
    readonly property string configHome: Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")
    property var shared: ({})
    property var island: ({})
    property var preferences: ({})
    readonly property int columns: Math.round(Catalog.number(shared.columns, 7, 3, 16))
    readonly property int tileWidth: Math.round(Catalog.number(shared.matWidth, 82, 64, 180))
    readonly property real glassOpacity: Catalog.number(preferences.opacity,
        Catalog.number(island.glassOpacity, 0.55, 0.15, 1), 0.15, 1)
    readonly property real frost: Catalog.number(shared.bgBlur, 12, 0, 30)
    readonly property bool glass: preferences.material !== "solid" &&
        (preferences.material !== "island" || island.style !== "black")
    readonly property bool dark: preferences.appearance === "dark" ||
        (preferences.appearance !== "light" && (island.appearance === "dark" ||
            (island.appearance !== "light" && Tokens.paper.r + Tokens.paper.g + Tokens.paper.b < 1.5)))
    readonly property color ink: dark ? Qt.rgba(1, 1, 1, 0.92) : Qt.rgba(0.12, 0.10, 0.09, 0.94)
    readonly property color tint: dark ? Qt.rgba(0.12, 0.12, 0.14, 1) : Qt.rgba(0.91, 0.86, 0.79, 1)
    readonly property string fontFamily: typeof island.font === "string" && island.font !== "auto" ? island.font : Tokens.ui
    // Same spring presets as Dynamic Island Theme.qml and its split bubbles.
    readonly property bool reduced: Tokens.reduceMotion || island.motion === "reduced"
    readonly property real spring: ({ gentle: 3.0, balanced: 3.6, bouncy: 4.2, reduced: 7 })[island.motion] || 3.6
    readonly property real damping: ({ gentle: 0.42, balanced: 0.30, bouncy: 0.21, reduced: 1.0 })[island.motion] || 0.30
    readonly property var results: Catalog.results(DesktopEntries.applications.values, query, section,
        Catalog.strings(shared.hiddenApps), Catalog.strings(shared.pinnedApps))
    readonly property var output: {
        const wanted = monitor || Wm.focusedOutput;
        for (const s of Quickshell.screens) if (s.name === wanted) return s;
        return Quickshell.screens.length ? Quickshell.screens[0] : null;
    }
    onResultsChanged: selected = Math.max(0, Math.min(selected, results.length - 1))
    function parse(text) {
        try { const value = JSON.parse(text); return value && typeof value === "object" && !Array.isArray(value) ? value : {}; }
        catch (error) { return {}; }
    }
    function save(key, value) {
        const next = Object.assign({}, preferences);
        next[key] = value;
        preferences = next;
        ownFile.setText(JSON.stringify(next, null, 2));
    }
    function show(mon) {
        closing.stop(); monitor = mon || ""; query = ""; section = "all"; selected = 0; openRequested = true;
    }
    function hide() { if (openRequested) { openRequested = false; closing.restart(); } }
    function toggle(mon) { openRequested ? hide() : show(mon); }
    function move(delta) { selected = Math.max(0, Math.min(results.length - 1, selected + delta)); }
    function launch(entry) { if (entry) { hide(); AppLaunch.run(entry, null); } }
    function stateDump() { return { open: openRequested, query: query, section: section, selected: selected, resultCount: results.length, glass: glass, dark: dark, layout: sheetLoader.item ? sheetLoader.item.stateDump() : null }; }
    Timer { id: closing; interval: root.reduced ? 1 : 230 }
    FileView {
        path: root.configHome + "/ryoku/launcher.json"
        watchChanges: true; blockLoading: true; printErrors: false
        onFileChanged: reload()
        onLoaded: root.shared = root.parse(text())
        onLoadFailed: root.shared = ({})
    }
    FileView {
        path: root.configHome + "/ryoku/dynamic-island/settings.json"
        watchChanges: true; blockLoading: true; printErrors: false
        onFileChanged: reload()
        onLoaded: root.island = root.parse(text())
        onLoadFailed: root.island = ({})
    }
    FileView {
        id: ownFile
        path: root.configHome + "/ryoku/tahoe-launcher.json"
        watchChanges: true; blockLoading: true; printErrors: false
        onFileChanged: reload()
        onLoaded: root.preferences = root.parse(text())
        onLoadFailed: root.preferences = ({})
    }
    LazyLoader {
        id: sheetLoader
        active: root.shown && root.output !== null
        Sheet { launcher: root; screen: root.output }
    }
}
