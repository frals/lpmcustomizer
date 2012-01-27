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
        color: "#ff8500"

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

    DefaultView {
        anchors.top: headerBox.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    CreatorSheet {
        id: creatorSheet
    }


    tools: ToolBarLayout {
        id: commonTools
        visible: true

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Create new"
            onClicked: creatorSheet.open();
            width: 212
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
        message: "This software is licensed under the BSD-license, for more information see \nhttp://projects.frals.se." +
                 "\n\nCode by Nick Leppänen Larsson <frals@frals.se>."
                 + "\nDesign by Annina Koskinen <annina.koskinen@aalto.fi>."
        acceptButtonText: "Ok"
    }

}
