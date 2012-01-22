import QtQuick 1.1
import com.nokia.meego 1.0

Button {
    id: me
    width: 112
    height: 48
    checkable: true
    property string iconName: ""

    iconSource: checked ? "qrc:/img/" + iconName : "qrc:/img/inverted-" + iconName

    ButtonStyle {
        // change checkedBackground tbh
    }


    onCheckedChanged: {
        if(checked) {
            parent.uncheckOthers(me);
            changeImage(iconName, fontSize.value, textField.text);
        } else {
            changeImage(0, fontSize.value, textField.text);
        }
    }
}
