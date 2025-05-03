import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import AppTheme 1.0
import "."
import ".."
// import QtQuick.Controls.Material

Item {
    id: action_menu
    implicitHeight: list_function_container.height
    implicitWidth: list_function_container.width
    visible: false
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.rightMargin: 32
    anchors.topMargin: 58
    Rectangle {
        id:list_function_container
        implicitHeight: list_function.height
        implicitWidth: list_function.width
        radius: 6
        border.width: 1
        border.color:  "#E5E7EB"
        Behavior on border.color {
            ColorAnimation {
                duration: 250
            }
        }

        color:"#FFFFFF"
        ColumnLayout {
            id: list_function
            spacing: 0
            Rectangle {
               id: list_item
               height: 40+1
               width: 192

                Text {
                    id: list_item_text
                    anchors.top:  parent.top
                    anchors.topMargin: 14
                    anchors.left:parent.left
                    anchors.leftMargin: 16
                    text: qsTr("Тема")
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                    font.weight: 400
                    font.pixelSize: 14
                    color: "#374151"
                }

                Switch {
                     id: theme_switch
                     //anchors.top:  parent.top
                      anchors.verticalCenter: parent.verticalCenter
                    // anchors.topMargin: 14
                     anchors.right:parent.right
                     anchors.rightMargin: 9
                     onClicked: {
                         Theme.isDarkTheme = !Theme.isDarkTheme
                     }
                }
                Rectangle {
                      height: 1 // Высота нижней границы
                      color: "#E5E7EB"
                      anchors.bottom: parent.bottom // Привязка к нижнему краю родителя
                      anchors.left: parent.left // Привязка к левому краю родителя
                      anchors.right: parent.right // Привязка к правому краю родителя
                  }
            }
            Rectangle {
                id: exitAccaunt;
                width: 192
                height: 45
                Text {
                    id: exit
                    text: qsTr("Выйти из аккаунта")
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                    font.weight: 400
                    font.pixelSize: 14
                    color: "#DC2626"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:parent.left
                    anchors.leftMargin: 16 
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        popup_exit.show()
                    }
                }

            }
       }
    }
    FormExit {
        id:popup_exit
    }
}


