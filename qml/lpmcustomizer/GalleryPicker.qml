import QtQuick 1.1
//import LPM 1.0
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

Sheet {
    id: gallerySheet

    rejectButtonText: "Cancel"
    acceptButtonText: "Accept"

    //visualParent: appWindow

    property string selectedLocalPhoto: ""

    signal activating
    signal activated
    signal deactivating
    signal deactivated

    onAccepted: {
        console.log("selected!", selectedLocalPhoto);
    }

    onRejected: {

    }

    onStatusChanged: {
        switch(status) {
        case DialogStatus.Closed:
            break;
        case DialogStatus.Opening:
            selectedLocalPhoto = "";
            break;
        case DialogStatus.Open:
            break;
        case DialogStatus.Closing:
            break;
        }
    }

    buttons: Item {
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
            }

            SheetButton {
                anchors.left: parent.left
                anchors.leftMargin: gallerySheet.platformStyle.rejectButtonLeftMargin
                anchors.verticalCenter: parent.verticalCenter
                text: gallerySheet.rejectButtonText
                onClicked: gallerySheet.reject()
            }

            SheetButton {
                id: acceptButton
                enabled: selectedLocalPhoto !== ""
                anchors.right: parent.right
                anchors.rightMargin: gallerySheet.platformStyle.acceptButtonRightMargin
                anchors.verticalCenter: parent.verticalCenter
                text: gallerySheet.acceptButtonText
                onClicked: gallerySheet.accept()
            }
        }

    content: Item {
        anchors.fill:  parent
        //color: "#000000"

        GridView {
            id: imgView
            clip: true
            anchors.fill: parent
            anchors.leftMargin: 4

            cellWidth: appWindow.inPortrait ? (parent.width / 4 - 2) : (parent.width / 6 - 1)
            cellHeight: imgView.cellWidth

            model: platform.galleryModel

            delegate: Item {
                clip: true
                id: photoDelegate
                //anchors.margins: 2
                width: imgView.cellWidth
                height: imgView.cellHeight

                Rectangle {
                    color: "#999999"
                    anchors.fill: parent
                    visible: imgView.currentIndex == index
                }

                Image {
                    id: photoImage
                    anchors.centerIn: parent

                    width: parent.width - 6
                    height: parent.height - 6

                    sourceSize.height: 240
                    sourceSize.width: 240

                    clip: true
                    source: "file:" + filepath
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
                            //selectedLocalPhoto = url;
                            selectedLocalPhoto = "file://" + filepath;
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
