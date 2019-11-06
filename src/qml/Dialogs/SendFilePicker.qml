import QtQuick 2.12
import "../utils.js" as Utils

HFileDialogOpener {
    fill: false
    dialog.title: qsTr("Select a file to send")

    onFilePicked: {
        let path = Qt.resolvedUrl(file).replace(/^file:/, "")

        Utils.sendFile(userId, roomId, path, () => {
            if (destroyWhenDone) destroy()
        },
        (type, args, error, traceback) => {
            console.error("python:\n" + traceback)
            if (destroyWhenDone) destroy()
        })
    }

    onCancelled: if (destroyWhenDone) destroy()


    property string userId
    property string roomId
    property bool destroyWhenDone: false
}
