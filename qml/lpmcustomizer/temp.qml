import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: page

    Label {
        id: pickLab
        anchors.top: parent.top
        anchors.topMargin: 64
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Pick your image (120x120, png, pref. b/w)"
    }

    Label {
        id: curLab
        anchors.top: pickLab.bottom
        anchors.topMargin: 128
        anchors.horizontalCenter: page.horizontalCenter
        text: "Current logo:"
    }

    Image {
        id: curImg
        anchors.top: curLab.bottom
        anchors.horizontalCenter: page.horizontalCenter

        height: 120
        width: 120

        source: platform.currentLogo === "" ? "" : "file://" + platform.currentLogo
    }

    Rectangle {
        anchors.top: curImg.bottom
        anchors.topMargin: 36
        id: divider
        width: parent.width
        height: 2
        color: "#666666"
    }

    Button {
        id: pickerButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: divider.bottom
        anchors.topMargin: 64
        text: "Pick from gallery"
        onClicked: gpSheet.open();
    }

    Item {
        anchors.top: pickerButton.bottom
        anchors.horizontalCenter: page.horizontalCenter
        visible: gpSheet.selectedLocalPhoto !== ""

        Label {
            id: newLab
            anchors.top: parent.top
            anchors.topMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            text: "New logo:"
        }

        Image {
            id: newImg
            anchors.top: newLab.bottom
            //anchors.topMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter

            height: 120
            width: 120

            source: ""
        }

    }

    GalleryPicker {
        id: gpSheet

        onAccepted: {
            newImg.source = "file://" + selectedLocalPhoto;
        }
    }



    tools: ToolBarLayout {
        id: commonTools
        visible: true
        ToolButtonRow {
            ToolButton {
                text: "Save"
                onClicked: platform.setOperatorLogo(gpSheet.selectedLocalPhoto);
            }
            ToolButton {
                text: "Reset"
                onClicked: platform.setOperatorLogo("");
            }
        }
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
        message: "Created by Nick Leppänen Larsson <frals@frals.se>, enjoy!"
        acceptButtonText: "Awesome."
    }
}
