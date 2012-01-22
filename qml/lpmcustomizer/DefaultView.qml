import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: pickImagePage

    Text {
        id: curLab
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.leftMargin: 16
        text: "Current logo"
        font.pointSize: 24
        lineHeight: 28
        lineHeightMode: Text.FixedHeight
    }

    Text {
        id: descLab
        anchors.top: curLab.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.right: curImg.left
        anchors.rightMargin: 40
        text: "For best quality, use black and white images with size 120 x 120 in png-format."
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pointSize: 16
        lineHeight: 24
        lineHeightMode: Text.FixedHeight
        font.family: "Nokia Pure Text Light"
        color: "#505050"
    }

    Image {
        id: curImg
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 12

        height: 120
        width: 120

        cache: false

        sourceSize.height: width
        sourceSize.width: height

        source: platform.currentLogo === "" ? "file:///opt/lpmcustomizer/no-logo.png" : "file://" + platform.currentLogo

        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            color: "#ff8500"
            z: parent.z - 1
        }
    }

    Rectangle {
        id: divider
        height: 2
        anchors.top: curImg.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#a9abad"
    }

    Item {
        id: gridHolder
        anchors.top: divider.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        GridView {
            id: imgView
            clip: true

            anchors.fill: parent

            cellWidth: 118
            cellHeight: imgView.cellWidth

            model: platformGalleryModel

            highlightFollowsCurrentItem: false

            onModelChanged: {
                imgView.currentIndex = platform.indexOf(platform.currentLogo);
            }

            delegate: Item {
                clip: true
                id: photoDelegate
                //anchors.margins: 2
                width: 118
                height: 118

                Rectangle {
                    color: "#ff8500"
                    anchors.fill: parent
                    visible: imgView.currentIndex === index
                }

                Image {
                    id: photoImage
                    anchors.centerIn: parent

                    width: parent.width - 8
                    height: parent.height - 8

                    sourceSize.height: width
                    sourceSize.width: height

                    clip: true
                    source: "file:" + modelData.filepath

                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true
                    cache: source == "file:///home/user/lpmlogo.png" ? false : true

                    //rotation: portrait ? 90 : 0

                    MouseArea {
                        anchors.fill: parent
                        z: 3
                        onClicked: {
                            imgView.currentIndex = index;
                            var fp = modelData.filepath
                            if(fp == "/opt/lpmcustomizer/no-logo.png") fp = "";
                            platform.setOperatorLogo(fp);
                        }
                    }
                }


            }

            ScrollDecorator {
                flickableItem: imgView
            }

        }

    }
}
