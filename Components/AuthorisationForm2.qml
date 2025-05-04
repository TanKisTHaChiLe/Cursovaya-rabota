import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import AppTheme 1.0
import CRM.Database 1.0
import "."
import ".."

Rectangle {
    id: authorisation
    color: Theme.isDarkTheme ? "#111827" : "#F9FAFB"
    width: 1200*scaleFactor
    height: 700*scaleFactor
    visible: false
    property real originalWidth: 1200
    property real originalHeight: 700
    property real scaleFactor: Math.min(width / originalWidth, height / originalHeight)
    Rectangle {
        id: authorisation_form
        anchors.centerIn: parent
        width: 448*scaleFactor
        height: 558*scaleFactor
        radius: 8
        color: Theme.isDarkTheme ? "#1F2937" : "#FFFFFF"
        Rectangle {
            id: title_container
            anchors.top: parent.top
            anchors.topMargin: 48*scaleFactor
            anchors.left: parent.left
            anchors.leftMargin: 32*scaleFactor
            width:header.width
            height: header.height
            color: parent.color
            Rectangle {
                id: header
                width:384*scaleFactor
                height: logo.height + title.height + h2.height + 24 + 14
                 color: parent.color
                Image {
                    id: logo
                    source: "qrc:/images/Logo.svg"
                    width: 48*scaleFactor
                    height:48*scaleFactor
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: title
                    text: qsTr("Добро пожаловать")
                    color:Theme.isDarkTheme ? "#FFFFFF" : "#111827"
                    font.weight: 600
                    font.pixelSize: 24*scaleFactor
                    font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                    anchors.top: logo.bottom
                    anchors.topMargin: 16*scaleFactor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: h2
                    text: qsTr("Войдите в свой аккаунт")
                    color: Theme.isDarkTheme ? "#9CA3AF" : "#4B5563"
                    font.weight: 400
                    font.pixelSize: 14*scaleFactor
                    font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                    anchors.top: title.bottom
                    anchors.topMargin: 8*scaleFactor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

        }
        Rectangle {
            id: input_container
            anchors.top: title_container.bottom
            anchors.topMargin: 32*scaleFactor
            anchors.left: parent.left
            anchors.leftMargin: 32*scaleFactor
            width:384*scaleFactor
            height: holder1.height +email_container.height + holder2.height + password_container.height + 15 + holder3.height + password_container2.height
            color: parent.color
            Text {
                id: holder1
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 6
                text: qsTr("Логин")
                color:Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                font.weight: 500
                font.pixelSize: 14*scaleFactor
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
            }
            Rectangle{
                id:email_container
                anchors.top: holder1.bottom
                anchors.topMargin: 5
                height: 38*scaleFactor
                width: 384*scaleFactor
                border.color:Theme.isDarkTheme ?"#4B5563": "#D1D5DB"
                color:  Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                border.width: 1
                radius: 4
                TextField{
                    id: email
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    background: null
                    placeholderText: "name@company.com"
                    placeholderTextColor: "#6B7280"
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                    font.weight: 400
                    font.pixelSize: 14*scaleFactor
                    color:Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                }
            }
            Text{
                id: holder2
                text: qsTr("Пароль")
                color:Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                anchors.top: email_container.bottom
                anchors.topMargin: 24
                anchors.left: parent.left
                anchors.leftMargin: 6
                font.weight: 500
                font.pixelSize: 14*scaleFactor
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
            }
            Rectangle{
                id: password_container
                anchors.top: holder2.bottom
                anchors.topMargin: 5
                height: 38*scaleFactor
                width: 384*scaleFactor
                border.color:Theme.isDarkTheme ?"#4B5563": "#D1D5DB"
                color:  Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                border.width: 1
                radius: 4
                TextField{
                    id: password
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    background: null
                    echoMode: TextInput.Password
                    placeholderTextColor: "#6B7280"
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                    font.weight: 400
                    font.pixelSize: 14*scaleFactor
                    color:Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                }
            }
            Text{
                id: holder3
                text: qsTr("Повторите пароль")
                color:Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                anchors.top: password_container.bottom
                anchors.topMargin: 24
                anchors.left: parent.left
                anchors.leftMargin: 6
                font.weight: 500
                font.pixelSize: 14*scaleFactor
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
            }
            Rectangle{
                id: password_container2
                anchors.top: holder3.bottom
                anchors.topMargin: 5
                height: 38*scaleFactor
                width: 384*scaleFactor
                border.color:Theme.isDarkTheme ?"#4B5563": "#D1D5DB"
                color:  Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                border.width: 1
                radius: 4
                TextField{
                    id: password2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    background: null
                    echoMode: TextInput.Password
                    placeholderTextColor: "#6B7280"
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                    font.weight: 400
                    font.pixelSize: 14*scaleFactor
                    color:Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                }
                MouseArea {

                }
            }
        }
        Rectangle{
            id: button
            width: 384*scaleFactor
            height:38*scaleFactor
            anchors.top: input_container.bottom
            anchors.topMargin: 80*scaleFactor
            anchors.left: parent.left
            anchors.leftMargin: 32*scaleFactor
            color: "#000000"
            radius: 4
            Text {
                id: button_text
                text: qsTr("Зарегистрироваться")
                color: "#FFFFFF"
                font.family: "fonts/Roboto_Condensed-Regular.ttf"
                font.weight: 500
                font.pixelSize: 14*scaleFactor
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(password.text==password2.text){
                        const userId = DatabaseManager.registerUser(email.text, password.text);
                        console.log(email.text, password.text,userId)
                        if (userId) {
                            stackView.pop();
                        } else {
                            holder1.text = "Ошибка, пользователь с таким именем уже существует";
                            holder1.color = "red"
                            email_container.border.color = "red"

                        }
                    }else{
                        password_container2.border.color = "red"
                        holder3.text= "Пароль не совпадает"
                        holder3.color = "red"
                    }
                }
            }
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
              id: errorLabel
              color: "red"
          }

    }

}
