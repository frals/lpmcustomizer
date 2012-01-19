import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    anchors.fill: parent

    TextArea {
	id: textField
	anchors.top: parent.top
	height: 200
	anchors.left: parent.left
	anchors.right: parent.right
	width: 200
	onTextChanged: {
	    imgPreview.source = "image://logocreator/" + fontSize.value + "/" + text;
	}
    }

    Slider {
	anchors.top: textField.bottom
	anchors.horizontalCenter: parent.horizontalCenter
	id: fontSize
	valueIndicatorText: value
	maximumValue: 150
	minimumValue: 1
	value: 20
	stepSize: 1
	valueIndicatorVisible: true

	onValueChanged: {
	    imgPreview.source = "image://logocreator/" + value + "/" + textField.text;
	}
    }

    Image {
	id: imgPreview
	anchors.top: fontSize.bottom
	anchors.horizontalCenter: parent.horizontalCenter
	source: "image://logocreator/0/"
    }

    Button {
	anchors.top: imgPreview.bottom
	anchors.topMargin: 12
	anchors.horizontalCenter: parent.horizontalCenter
	text: "Save me!";
	onClicked: imageSaver.saveImage(fontSize.value + "/" + textField.text);
    }

}
