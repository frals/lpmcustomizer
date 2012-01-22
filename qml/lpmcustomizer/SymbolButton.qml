import QtQuick 1.1
import com.nokia.meego 1.0

Button {
    id: me
    width: 108
    height: 48
    checkable: true
    property string iconName: ""
    property string iconFileNameW: "qrc:/img/" + iconName + "_white.png"
    property string iconFileNameB: "qrc:/img/" + iconName + "_black.png"

    Image {
        anchors.centerIn: parent
        sourceSize.width: 32
        sourceSize.height: 32
        source: parent.checked ? iconFileNameW : iconFileNameB
    }

    //iconSource: checked ? iconFileNameW : iconFileNameB

    platformStyle: ButtonStyle {
        checkedBackground: "image://theme/meegotouch-button-inverted-background" + (position ? "-" + position : "")
    }


    onCheckedChanged: {
        if(checked) {
            parent.uncheckOthers(me);
            changeImage(alignment, iconName, fontSize.value, textField.text);
        } else {
            changeImage(alignment, 0, fontSize.value, textField.text);
        }
    }
}
