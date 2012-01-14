import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: page

    property string selectedLocalPhoto: ""

    QueryDialog {
        id: firstLaunchDialog
        titleText: "A small note from the developer"
        message: "I believe every user should have the freedom to customize their device as they please.\n" +
        "Due to this, you can select any image you want to present on your lock screen.\n However, please, note that some images might" +
        " affect your screen in a negative way, hence I recommend you to only use black and white images.\n" +
        "I take no responsibility at all for any consequences of using this application."
        acceptButtonText: "Accept";

        Component.onCompleted: {
            if(!platform.firstLaunchDone) firstLaunchDialog.open();
        }

        onAccepted: {
            platform.setFirstLaunchDone();
        }

        onRejected: {
            Qt.quit();
        }
    }

    Rectangle {
        id: headerBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: 72
        color: "#ff8430"

        Text {
            id: titleLab
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            text: "Pick your logo"
            color: "white"
            font.pointSize: 24
        }

    }

    Text {
        id: curLab
        anchors.top: headerBox.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.leftMargin: 16
        text: "Current logo"
        font.pointSize: 24
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
        font.family: "Nokia Pure Text Light"
        color: "#505050"
    }

    Image {
        id: curImg
        anchors.top: headerBox.bottom
        anchors.topMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 12

        height: 120
        width: 120

        sourceSize.height: width
        sourceSize.width: height

        source: platform.currentLogo === "" ? "file:///opt/lpmcustomizer/no-logo.png" : "file://" + platform.currentLogo

        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            color: "#ff8430"
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
                    color: "#ff8430"
                    anchors.fill: parent
                    visible: imgView.currentIndex == index
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
                    //source: url

                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true

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


    tools: ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }

    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("About"); onClicked: aboutDialog.open() }
        }
    }

    QueryDialog {
        id: aboutDialog
        titleText: "About"
        message: "This software is licensed under the BSD-license, for more information see \nhttp://projects.frals.se." +
                "\n\nCode by Nick Leppänen Larsson <frals@frals.se>."
                 + "\nDesign by Annina Koskinen <annina.koskinen@aalto.fi>."
        acceptButtonText: "Ok"
    }

}
