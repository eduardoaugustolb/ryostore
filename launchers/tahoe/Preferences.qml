import QtQuick
import QtQuick.Controls
import Ryoku.Ui.Singletons

Rectangle {
    id: root
    required property var launcher
    signal dismissed()
    color: launcher.tint
    radius: Tokens.px(18)
    MouseArea { anchors.fill: parent }
    Column {
        anchors.fill: parent; anchors.margins: Tokens.px(18)
        spacing: Tokens.px(10)
        Text {
            text: I18n.tr("Appearance")
            color: root.launcher.ink
            font.family: root.launcher.fontFamily; font.pixelSize: Tokens.px(18)
        }
        Text {
            width: parent.width; wrapMode: Text.WordWrap
            text: I18n.tr("Match Dynamic Island follows its material, theme and opacity. Grid, favorites and hidden apps follow Ryoku App Launcher settings.")
            color: root.launcher.ink; opacity: 0.7
            font.family: root.launcher.fontFamily; font.pixelSize: Tokens.px(11)
        }
        ComboBox {
            width: parent.width
            model: [I18n.tr("Match Dynamic Island"), I18n.tr("Liquid Glass"), I18n.tr("Solid")]
            currentIndex: ["island", "glass", "solid"].indexOf(root.launcher.preferences.material || "glass")
            onActivated: root.launcher.save("material", ["island", "glass", "solid"][currentIndex])
        }
        ComboBox {
            width: parent.width
            model: [I18n.tr("Automatic theme"), I18n.tr("Light"), I18n.tr("Dark")]
            currentIndex: ["auto", "light", "dark"].indexOf(root.launcher.preferences.appearance || "auto")
            onActivated: root.launcher.save("appearance", ["auto", "light", "dark"][currentIndex])
        }
        Text {
            text: I18n.tr("Glass opacity") + " · " + Math.round(root.launcher.glassOpacity * 100) + "%"
            color: root.launcher.ink
            font.family: root.launcher.fontFamily; font.pixelSize: Tokens.px(12)
        }
        Slider {
            width: parent.width; from: 0.15; to: 1; stepSize: 0.01
            value: root.launcher.glassOpacity
            onMoved: root.launcher.save("opacity", value)
        }
        CheckBox {
            text: I18n.tr("Specular glass rim")
            checked: root.launcher.preferences.rim !== false
            onToggled: root.launcher.save("rim", checked)
        }
        Row {
            spacing: Tokens.px(8)
            Button {
                text: I18n.tr("Reset")
                onClicked: { root.launcher.preferences = ({}); root.launcher.save("material", "glass"); }
            }
            Button { text: I18n.tr("Done"); onClicked: root.dismissed() }
        }
    }
}
