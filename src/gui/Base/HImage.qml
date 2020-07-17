// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.12
import QtGraphicalEffects 1.12

Image {
    id: image

    property bool circle: radius === circleRadius
    property bool broken: false
    property bool animate: true
    property bool animated:
        utils.urlExtension(image.source).toLowerCase() === "gif"

    property alias radius: roundMask.radius
    property alias showProgressBar: progressBarLoader.active

    readonly property int circleRadius:
        Math.ceil(Math.max(image.width, image.height))


    autoTransform: true
    asynchronous: true
    fillMode: Image.PreserveAspectFit

    cache: ! (animate && animated) &&
           (sourceSize.width + sourceSize.height) <= 512

    layer.enabled: radius !== 0
    layer.effect: OpacityMask { maskSource: roundMask }

    Component {
        id: animatedImageComponent

        AnimatedImage {
            id: animatedImage

            property bool userPaused: ! window.settings.media.autoPlayGIF

            source: image.source
            autoTransform: image.autoTransform
            asynchronous: image.asynchronous
            fillMode: image.fillMode

            mirror: image.mirror
            mipmap: image.mipmap
            smooth: image.smooth
            horizontalAlignment: image.horizontalAlignment
            verticalAlignment: image.verticalAlignment

            // Online GIFs won't be able to loop if cache is set to false,
            // but caching GIFs is expansive.
            cache: ! Qt.resolvedUrl(source).startsWith("file://")
            paused: ! visible || window.hidden || userPaused

            layer.enabled: image.radius !== 0
            layer.effect: OpacityMask { maskSource: roundMask }

            // Hack to make the non-animated image behind this one
            // basically invisible
            Binding {
                target: image
                property: "sourceSize.width"
                value: 1
            }
            Binding {
                target: image
                property: "sourceSize.height"
                value: 1
            }

            HButton {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: theme.spacing / 2
                anchors.bottomMargin: theme.spacing / 2

                enableRadius: true
                icon.name: parent.userPaused ? "player-play" : "player-pause"
                iconItem.small: true
                visible: parent.width > width * 2 && parent.height > height * 2
                onClicked: parent.userPaused = ! parent.userPaused
            }
        }
    }

    HLoader {
        anchors.fill: parent
        sourceComponent: animate && animated ? animatedImageComponent : null
    }

    HLoader {
        id: progressBarLoader

        readonly property alias progress: image.progress
        readonly property Component determinate: HCircleProgressBar {
            progress: image.progress
        }

        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.5
        height: width
        active: image.status === Image.Loading
        sourceComponent: HBusyIndicator {}

        onProgressChanged:
            if (progress > 0 && progress < 1) sourceComponent = determinate
    }

    HIcon {
        anchors.centerIn: parent
        visible: broken || image.status === Image.Error
        svgName: "broken-image"
        colorize: theme.colors.negativeBackground
    }

    Rectangle {
        id: roundMask
        anchors.fill: parent
        visible: false
    }
}
