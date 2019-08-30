import QtQuick 2.12
import QtQuick.Controls 2.12

ScrollView {
    property alias backgroundColor: textAreaBackground.color
    property alias placeholderText: textArea.placeholderText
    property alias text: textArea.text
    property alias area: textArea

    default property alias textAreaData: textArea.data

    id: scrollView
    clip: true

    TextArea {
        id: textArea
        readOnly: ! visible
        selectByMouse: true

        wrapMode: TextEdit.Wrap
        font.family: theme.fontFamily.sans
        font.pixelSize: theme.fontSize.normal
        font.pointSize: -1

        color: theme.controls.textArea.text
        background: Rectangle {
            id: textAreaBackground
            color: theme.controls.textArea.background
        }

        Keys.onPressed: if (
            event.modifiers & Qt.AltModifier ||
            event.modifiers & Qt.MetaModifier
        ) event.accepted = true

        Keys.forwardTo: mainUI.shortcuts
    }
}
