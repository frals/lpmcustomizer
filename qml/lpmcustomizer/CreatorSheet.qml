import QtQuick 1.1
import com.nokia.meego 1.0

Sheet {
    id: sheet
    anchors.fill: parent

    property string savedSymbol;

    property int sideMargin: sheet.platformStyle.acceptButtonRightMargin

    onAccepted: imageSaver.saveImage(savedSymbol + "/" + fontSize.value + "/" + textField.text);

    function changeImage(symbol, size, text) {
        var symstr = symbol
        if(symstr === null) {
            symstr = savedSymbol
        }

        imgPreview.source = "image://logocreator/" + symstr + "/" + size + "/" + text;
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
            anchors.topMargin: 24
            anchors.left: parent.left
            anchors.leftMargin: 16
            text: "New logo"
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
            anchors.right: imgPreview.left
            anchors.rightMargin: 40
            text: "Enter the text to display on your logo and use the slider to resize it. You can also add a symbol from the menu."
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pointSize: 16
            lineHeight: 22
            lineHeightMode: Text.FixedHeight
            font.family: "Nokia Pure Text Light"
            color: "#505050"
        }

        Image {
            id: imgPreview
            anchors.top: parent.top
            anchors.topMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: sideMargin

            cache: false

            height: 120
            width: 120

            sourceSize.height: width
            sourceSize.width: height

            source: "image://logocreator/0/0/"

            Rectangle {
                anchors.fill: parent
                anchors.margins: -3
                color: "#ff8500"
                z: parent.z - 1
            }
        }

        TextArea {
            id: textField
            anchors.top: descLab.bottom
            anchors.topMargin: 8
            height: 200
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: sideMargin
            anchors.rightMargin: sideMargin
            inputMethodHints: Qt.ImhNoPredictiveText
            placeholderText: "Enter your (multi-line) text here"

            onTextChanged: {
                changeImage(null, fontSize.value, text);
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
                changeImage(null, value, textField.text);
            }
        }

        Text {
            id: addSymbol
            anchors.top: fontSize.bottom
            anchors.topMargin: 24
            anchors.left: parent.left
            anchors.leftMargin: 16
            text: "Add symbol"
            font.pointSize: 24
        }

        Row {
            id: butCont
            anchors.top: addSymbol.bottom
            anchors.topMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4

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
                iconName: "heart.png"
            }
            SymbolButton {
                id: heart1
                iconName: "heart.png"
            }
            SymbolButton {
                id: heart2
                iconName: "heart.png"
            }
            SymbolButton {
                id: heart3
                iconName: "heart.png"
            }
        }
    }

}
