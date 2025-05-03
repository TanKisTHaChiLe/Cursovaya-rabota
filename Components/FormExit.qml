import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import AppTheme 1.0
import CRM.Database 1.0
import "."
import ".."
Window  {
    title: "Выход"
    id: popup_exit
    visible: false
    minimumHeight: 146
    minimumWidth: 512
    maximumHeight: 146
    maximumWidth: 512
    property color color_exept_text_1: Theme.isDarkTheme ? "#FFFFFF" :"#111827"
    property color color_exept_text_2: Theme.isDarkTheme ? "#9CA3AF" : "#6B7280"
    property color color_button_cancel: Theme.isDarkTheme ? "#000000" : "#FFFFFF"
    property color color_text_cancel:  Theme.isDarkTheme ? "#FFFFFF"  : "#374151"
    color: block_Background
    Behavior on color {
        ColorAnimation {
            duration: 250
        }
    }

    property var databaseManager: DatabaseManager

        // Обработчик успешного выхода
        Connections {
            target: databaseManager
            function onLogoutSuccess() {
                console.log("Успешный выход из системы");
                stackView.replace(autorisation);
            }
        }

    Rectangle {
        id: text_popup
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        height: exept_text_container>popup_exit_image ? exept_text_container.height : popup_exit_image.height
        color: block_Background
        Behavior on color {
            ColorAnimation {
                duration: 250
            }
        }
        Image {
            id: popup_exit_image
            source: "qrc:/images/Danger.svg"
            width: 40
            height: 40
            anchors.left: parent.left
            anchors.top: parent.top
        }
        Rectangle {
            id: exept_text_container
            height: exept_text.height + exept_text_2.height + 8
            anchors.top: parent.top
            anchors.left: popup_exit_image.right
            anchors.leftMargin: 16
            anchors.right: parent.right
            color: block_Background
            Behavior on color {
                ColorAnimation {
                    duration: 250
                }
            }
            Text {
                id: exept_text
                text: qsTr("Подтверждение выхода")
                font.weight: 500
                font.pixelSize: 18
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                color:color_exept_text_1
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }
            Text {
                id: exept_text_2
                anchors.top: exept_text.bottom
                anchors.topMargin: 8
                text: qsTr("Вы уверены, что хотите выйти из аккаунта? ")
                font.weight: 400
                font.pixelSize: 14
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                color:color_exept_text_2
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }
        }
    }
    Rectangle {
        id: button_container
        anchors.top: text_popup.bottom
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 270
        Rectangle {
            id: button_cancel
            height: 38
            width: 84
            border.color: Theme.isDarkTheme ? "#000000" : "#D1D5DB"
            Behavior on border.color {
                ColorAnimation {
                    duration: 250
                }
            }
            border.width: 1
            radius: 4
            color:color_button_cancel
            Behavior on color {
                ColorAnimation {
                    duration: 250
                }
            }
            Text {
                id: cancel
                text: qsTr("Отмена")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: color_text_cancel
                font.weight: 500
                font.pixelSize: 14
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    popup_exit.close()
                }
            }
        }
        Rectangle {
            id: button_accept
            anchors.left: button_cancel.right
            anchors.leftMargin: 12
            height: 38
            width: 121
            color: "#DC2626"
             border.color: "#DC2626"
            border.width: 1
            radius: 4
            Text {
                id: accept
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Подтвердить ")
                color:  "#FFFFFF"
                font.weight: 500
                font.pixelSize: 14
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    databaseManager.logoutUser();
                    popup_exit.close();
                }
            }
        }
    }
    AuthorizationForm {
        id: authorizationForm
    }

}
