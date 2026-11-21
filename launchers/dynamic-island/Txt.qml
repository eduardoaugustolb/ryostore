import QtQuick
import Ryoku.Ui.Singletons

Text {
    property real size: 13
    property int weight: Font.Medium
    font.family: Tokens.ui
    font.pixelSize: size
    font.weight: weight
    font.letterSpacing: size >= 20 ? -size * 0.022 : size >= 15 ? -0.2 : 0
    font.features: { "tnum": 1 }
    color: Tokens.ink
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
    textFormat: Text.PlainText
    Behavior on color { ColorAnimation { duration: 200 } }
}
