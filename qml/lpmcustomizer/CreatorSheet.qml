import QtQuick 1.1
import com.nokia.meego 1.0

Sheet {
    id: sheet
    anchors.fill: parent

    property string savedSymbol;
    property string alignment: "left";

    property int sideMargin: sheet.platformStyle.acceptButtonRightMargin

    onAccepted: imageSaver.saveImage(alignment + "/" + savedSymbol + "/" + fontSize.value + "/" + textField.text);

    function changeImage(align, symbol, size, text) {
        var symstr = symbol
        if(symstr === null) {
            symstr = savedSymbol
        }

        imgPreview.source = "image://logocreator/" + alignment + "/" + symstr + "/" + size + "/" + text;
        savedSymbol = symstr;
    }

    /* copied from Sheet.qml just to override the accept button looks...... */
    buttons: Item {
        id: buttonRow
        anchors.fill: parent
        SheetButton {
            id: rejectButton
            objectName: "rejectButton"
            anchors.left: parent.left
            anchors.leftMargin: sheet.platformStyle.rejectButtonLeftMargin
            anchors.verticalCenter: parent.verticalCenter
            visible: text != ""
            text: "Cancel"
            onClicked: close()
        }
        SheetButton {
            id: acceptButton
            objectName: "acceptButton"
            anchors.right: parent.right
            anchors.rightMargin: sheet.platformStyle.acceptButtonRightMargin
            anchors.verticalCenter: parent.verticalCenter
            platformStyle: SheetButtonAccentStyle {
                background: "image://theme/color17-meegotouch-sheet-button-accent"+__invertedString+"-background"
                pressedBackground: "image://theme/color17-meegotouch-sheet-button-accent"+__invertedString+"-background-pressed"
                disabledBackground: "image://theme/color17-meegotouch-sheet-button-accent"+__invertedString+"-background-disabled"
            }
            enabled: textField.text != "" || !(savedSymbol == "" || savedSymbol == "0")
            visible: text != ""
            text: "Save"
            onClicked: close()
        }
        Component.onCompleted: {
            acceptButton.clicked.connect(accepted)
            rejectButton.clicked.connect(rejected)
        }
    }


    content: Item {
        anchors.fill: parent

        Text {
            id: curLab
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: sideMargin
            text: "New logo"
            font.pointSize: 24
            lineHeight: 32
            lineHeightMode: Text.FixedHeight
        }

        Text {
            id: descLab
            anchors.top: curLab.bottom
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: sideMargin
            anchors.right: imgPreview.left
            anchors.rightMargin: 40
            text: "Enter the text to display on your logo and use the slider to resize it. You can also add a symbol from the menu."
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pointSize: 16
            lineHeight: 24
            lineHeightMode: Text.FixedHeight
            font.family: "Nokia Pure Text Light"
            color: "#505050"
        }

        Image {
            id: imgPreview
            anchors.top: parent.top
            anchors.topMargin: 28
            anchors.right: parent.right
            anchors.rightMargin: sideMargin

            cache: false

            height: 120
            width: 120

            sourceSize.height: width
            sourceSize.width: height

            source: "image://logocreator/left/0/0/"

            Rectangle {
                anchors.fill: parent
                anchors.margins: -3
                color: "#ff8500"
                z: parent.z - 1
            }
        }

        ButtonRow {
            id: alignBar
            anchors.top: descLab.bottom
            anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Left"
                onClicked: {
                    alignment = "left";
                    changeImage(alignment, null, fontSize.value, textField.text);
                }
            }
            Button {
                text: "Center"
                onClicked: {
                    alignment = "center";
                    changeImage(alignment, null, fontSize.value, textField.text);
                }
            }
            Button {
                text: "Right"
                onClicked: {
                    alignment = "right";
                    changeImage(alignment, null, fontSize.value, textField.text);
                }
            }
        }


        TextArea {
            id: textField
            anchors.top: alignBar.bottom
            anchors.topMargin: 14
            height: 200
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: sideMargin
            anchors.rightMargin: sideMargin
            inputMethodHints: Qt.ImhNoPredictiveText
            placeholderText: "Enter your (multi-line) text here"

            onTextChanged: {
                changeImage(alignment, null, fontSize.value, text);
            }
        }

        Slider {
            id: fontSize
            anchors.top: textField.bottom
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.right: parent.right
            valueIndicatorText: value
            maximumValue: 80
            minimumValue: 4
            value: 20
            stepSize: 1
            valueIndicatorVisible: true

            onValueChanged: {
                changeImage(alignment, null, value, textField.text);
            }
        }

        Text {
            id: addSymbol
            anchors.top: fontSize.bottom
            anchors.topMargin: 24
            anchors.left: parent.left
            anchors.leftMargin: sideMargin
            text: "Add symbol"
            font.pointSize: 24
        }

        Row {
            id: butCont
            anchors.top: addSymbol.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            function uncheckOthers(asd) {
                // totally expected to be able to do a for-in loop over children
                // but alas, that didnt quite work
                for (var i = 0; i < butCont.children.length; i++) {
                    if(butCont.children[i] !== asd)
                        if(butCont.children[i].checked) butCont.children[i].checked = false;
                }
            }

            SymbolButton {
                id: heart
                iconName: "heart"
            }
            SymbolButton {
                id: star
                iconName: "star"
            }
            SymbolButton {
                id: smile
                iconName: "smile"
            }
            SymbolButton {
                id: note
                iconName: "note"
            }
        }
    }

}
