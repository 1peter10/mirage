import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../../Base"

Row {
    id: messageContent
    spacing: standardSpacing / 2
    layoutDirection: isOwn ? Qt.RightToLeft : Qt.LeftToRight

    HAvatar {
        id: avatar
        hidden: combine
        name: senderInfo.displayName || stripUserId(model.senderId)
        dimension: 48
    }

    Rectangle {
        color: HStyle.chat.message.background

        //width: nameLabel.implicitWidth
        width: Math.min(
            roomEventListView.width - avatar.width - messageContent.spacing,
            HStyle.fontSize.normal * 0.5 * 75,  // 600 with 16px font
            Math.max(
                nameLabel.visible ? nameLabel.implicitWidth : 0,
                contentLabel.implicitWidth
            )
        )
        height: nameLabel.height + contentLabel.implicitHeight

        Column {
            spacing: 0
            anchors.fill: parent

            HLabel {
                height: combine ? 0 : implicitHeight
                width: parent.width
                visible: height > 0

                id: nameLabel
                text: senderInfo.displayName || model.senderId
                color: Qt.hsla(avatar.hueFromName(avatar.name),
                               HStyle.displayName.saturation,
                               HStyle.displayName.lightness,
                               1)
                elide: Text.ElideRight
                maximumLineCount: 1
                horizontalAlignment: isOwn ? Text.AlignRight : Text.AlignLeft

                leftPadding: horizontalPadding
                rightPadding: horizontalPadding
                topPadding: verticalPadding
            }

            HRichLabel {
                width: parent.width

                id: contentLabel
                text: model.content +
                      "&nbsp;&nbsp;<font size=" + HStyle.fontSize.small +
                      "px color=" + HStyle.chat.message.date + ">" +
                      Qt.formatDateTime(model.date, "hh:mm:ss") +
                      "</font>" +
                      (model.isLocalEcho ?
                       "&nbsp;<font size=" + HStyle.fontSize.small +
                       "px>⏳</font>" : "")
                textFormat: model.type == "text" ?
                            Text.PlainText : Text.RichText
                color: HStyle.chat.message.body
                wrapMode: Text.Wrap

                leftPadding: horizontalPadding
                rightPadding: horizontalPadding
                topPadding: nameLabel.visible ? 0 : verticalPadding
                bottomPadding: verticalPadding
            }
        }
    }
}
