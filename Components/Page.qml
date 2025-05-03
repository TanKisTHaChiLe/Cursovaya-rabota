import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import AppTheme 1.0
import "."
import ".."

Rectangle {
    id:page
    width: 1200
    height: 700
    property real originalWidth: 1200
    property real originalHeight: 700
    property real scaleFactor: Math.min(width / originalWidth, height / originalHeight)
    //property bool isDarkTheme: Theme.isDarkTheme
    property color body_Background: Theme.isDarkTheme ? "#111827" : "#F2F4F4"
    property color block_Background: Theme.isDarkTheme ? "#1F2937" :  "#FFFFFF"
    color: body_Background
    Behavior on color {
        ColorAnimation {
            duration: 250
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(action_menu.visible){
                action_menu.visible = false
            }
            if(formExit.visible){
                formExit.visible = false
            }
        }
    }
    Rectangle {
        id: header
        height: header_container.height
        color: block_Background
        Behavior on color {
            ColorAnimation {
                duration: 250
            }
        }
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        Rectangle{
            id: header_container
            anchors.left: parent.left
            anchors.leftMargin: 32
            anchors.right: parent.right
            anchors.rightMargin: 32
            height: name.height + 40
            color:parent.color


            Text {
                id: name
                text: qsTr("Иван Петров")
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.right: parent.right
                font.weight: 400
                font.pixelSize: 16
                z:2
                color:Theme.isDarkTheme ? "#E5E7EB" : "#374151"
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
                font.family: "fonts/Roboto_Condensed-Regular.ttf"
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        action_menu.visible = !action_menu.visible
                    }
                }
            }
        }
        Rectangle {
            id: header_container_border_bottom
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: Theme.isDarkTheme ? "#1F2937": "#E5E7EB"
            Behavior on color {
                ColorAnimation {
                    duration: 250
                }
            }
        }
    }
    Rectangle {
        id: top_bar
        anchors.top:header.bottom
        anchors.topMargin: 48
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.right: parent.right
        anchors.rightMargin: 32
        radius: 8
        height: (top_bar_container.height + 48)*scaleFactor
        color:block_Background
        Behavior on color {
            ColorAnimation {
                duration: 250
            }
        }
        RowLayout {
            id: top_bar_container
            anchors.top:parent.top
            anchors.topMargin: 24*scaleFactor
            anchors.left:parent.left
            anchors.leftMargin: 24
            Rectangle {
                id: table_button
                height:table_button_text.height + 16*scaleFactor
                width: table_button_text.width +32*scaleFactor + table_button_image.width + 7
                border.color: Theme.isDarkTheme ? "#110000" : "#000000"
                border.width: 1
                radius: 4
                color: Theme.isDarkTheme ? "#131927" : "#000000"
                function calculateButtonColor() {
                    buttonColor = Theme.isDarkTheme ? "#131927" : "#000000"
                    hoverColor= Theme.isDarkTheme ? "#4B5563" :"#1F2937"
                    color = buttonColor
                }
                property color buttonColor
                property color hoverColor
                Component.onCompleted: calculateButtonColor()

               Connections {
                   target: Theme // Слушаем изменения в синглтоне!
                   function onIsDarkThemeChanged(){ table_button.calculateButtonColor()}
               }
                // Component.onCompleted: {
                //     calculateButtonColor()
                // }
                // Connections {
                //     target: page
                //     onIsDarkThemeChanged: {
                //         table_button.calculateButtonColor()
                //     }
                // }
                Behavior on color {
                    ColorAnimation { duration: 250 }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        parent.color = parent.hoverColor
                    }
                    onExited: {
                        parent.color = parent.buttonColor
                    }
                }


                Image {
                    id: table_button_image
                    source: "qrc:/images/Table.svg"
                    width: 16*scaleFactor
                    height: 14*scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left;
                    anchors.leftMargin: 16*scaleFactor
                }

                Text {
                    id: table_button_text
                    text: qsTr("Сформировать таблицу")
                    font.weight: 400
                    font.pixelSize: 16*scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:table_button_image.right
                    anchors.leftMargin: 7
                    color: "#FFFFFF"
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                }
            }
            Rectangle {
                id: push_client_button
                height:push_client_button_text.height + 16*scaleFactor
                width: push_client_button_text.width + 30*scaleFactor + push_client_button_image.width + 7
                radius: 4
                anchors.left: table_button.right
                anchors.leftMargin: 16*scaleFactor
                border.color: Theme.isDarkTheme ? "#110000" : "#000000"
                border.width: 1
                color: Theme.isDarkTheme ? "#131927" : "#000000"
                function calculateButtonColor() {
                    buttonColor = Theme.isDarkTheme ? "#131927" : "#000000"
                    hoverColor= Theme.isDarkTheme ? "#4B5563" :"#1F2937"
                    color = buttonColor
                }
                property color buttonColor
                property color hoverColor
                Component.onCompleted: calculateButtonColor()

               Connections {
                   target: Theme // Слушаем изменения в синглтоне!
                   function onIsDarkThemeChanged(){ push_client_button.calculateButtonColor()}
               }
                // Component.onCompleted: {
                //     calculateButtonColor()
                // }
                // Connections {
                //     target: page
                //     onIsDarkThemeChanged: {
                //         push_client_button.calculateButtonColor()
                //     }
                // }
                Behavior on color {
                    ColorAnimation { duration: 250 }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        parent.color = parent.hoverColor
                    }
                    onExited: {
                        parent.color = parent.buttonColor
                    }
                }
                Image {
                    id: push_client_button_image
                    source: "qrc:/images/add.svg"
                    width: 14*scaleFactor
                    height: 16*scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15*scaleFactor
                }
                Text {
                    id: push_client_button_text
                    text: qsTr("Добавить клиента")
                    font.weight: 400
                    font.pixelSize: 16*scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:push_client_button_image.right
                    anchors.leftMargin: 7
                    color: "#FFFFFF"
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                }
            }
            Rectangle {
                id: filter_button
                height:filter_button_text.height + 16*scaleFactor
                width: filter_button_text.width + 30*scaleFactor +filter_button_image.width +8
                color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                radius: 4
                anchors.left: push_client_button.right
                anchors.leftMargin: 16*scaleFactor
                border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                Behavior on border.color {
                    ColorAnimation {
                        duration: 250
                    }
                }
                border.width: 1
                function calculateButtonColor() {
                    buttonColor = Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                    hoverColor= Theme.isDarkTheme ? "#4B5563" :"#F3F4F6"
                    color = buttonColor
                }
                property color buttonColor
                property color hoverColor
                Component.onCompleted: calculateButtonColor()

               Connections {
                   target: Theme // Слушаем изменения в синглтоне!
                   function onIsDarkThemeChanged(){ filter_button.calculateButtonColor()}
               }
                // Component.onCompleted: {
                //     calculateButtonColor()
                // }
                // Connections {
                //     target: page
                //     onIsDarkThemeChanged: {
                //         filter_button.calculateButtonColor()
                //     }
                // }
                Behavior on color {
                    ColorAnimation { duration: 250 }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        parent.color = parent.hoverColor
                    }
                    onExited: {
                        parent.color = parent.buttonColor
                    }
                }

                Image {
                    id: filter_button_image
                    source: "qrc:/images/addFilterLightTheme.svg"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15*scaleFactor
                    width: 16*scaleFactor
                    height: 14*scaleFactor
                    opacity: Theme.isDarkTheme ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                        }
                    }
                }

                Image {
                    id: filter_button_image_2
                    source: "qrc:/images/addFilterDarkTheme.svg"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15*scaleFactor
                    width: 16*scaleFactor
                    height: 14*scaleFactor
                    opacity: Theme.isDarkTheme ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                        }
                    }
                }

                Text {
                    id: filter_button_text
                    text: qsTr("Добавить фильтр")
                    font.weight: 400
                    font.pixelSize: 16*scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:filter_button_image.right
                    anchors.leftMargin: 8
                    color:Theme.isDarkTheme ? "#E5E7EB" : "#374151"
                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }
                    }
                    font.family: "fonts/Roboto_Condensed-Regular.ttf"
                }
            }
        }
        Rectangle {
            id: form_search_client
            height: search_client.height +10*scaleFactor
            width: search_client.width + 40*scaleFactor + search_client_image.width + 12
            border.color: Theme.isDarkTheme ? "#374151" : "#D1D5DB"
            color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
            Behavior on color {
                ColorAnimation { duration: 250 }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: 250
                }
            }
            border.width: 1
            radius: 6
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 24
            Image {
                id: search_client_image
                source: "qrc:/images/magnifier.svg"
                width: 16*scaleFactor
                height: 16*scaleFactor
                anchors.left: parent.left
                anchors.leftMargin: 12*scaleFactor
                anchors.verticalCenter: parent.verticalCenter
            }
            TextField {
                id: search_client
                anchors.left: search_client_image.right
                anchors.leftMargin: 12
                anchors.top: parent.top
                anchors.topMargin: 5*scaleFactor
                placeholderText: "Поиск клиентов..."
                placeholderTextColor: "#6B7280"
                font.family: "fonts/Roboto_Condensed-Regular.ttf"
                font.weight: 400
                font.pixelSize: 16*scaleFactor
                background: null
                color: "#000000"
            }
        }
    }
    ColumnLayout {

        id: list_clients
        spacing: 20
        anchors.top: top_bar.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.right: parent.right
        anchors.rightMargin: 32
        Rectangle {
            id: client
            height: client_content.height
            Layout.fillWidth: true
            color: block_Background
            Behavior on color {
                ColorAnimation {
                    duration: 250
                }
            }
            border.width: 0
            border.color: "#6B7280"
            radius: 8
            Behavior on border.width {
                NumberAnimation {
                    duration: 100
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    parent.border.width = 1.5
                }
                onExited: {
                    parent.border.width = 0
                }
            }
            RowLayout {
                id: client_content
                anchors {
                    left: parent.left
                    leftMargin: 24
                    top: parent.top
                    right: parent.right
                    rightMargin: 24
                    }
                height: client_content_data.height + 48*scaleFactor
                ColumnLayout {
                    id: client_content_data
                    spacing: 5*scaleFactor
                    Text {
                        id: client_content_data_name
                        text: qsTr("Александр Иванов")
                        font.weight: 500
                        font.pixelSize: 20*scaleFactor
                        font.family: "fonts/Roboto_SemiCondensed-Medium.ttf"
                        color: Theme.isDarkTheme ? "#FFFFFF" : "#000000"
                        Behavior on color {
                            ColorAnimation {
                                duration: 250
                            }
                        }
                    }
                    Text {
                        id: client_content_data_company
                        text: qsTr("ООО Технопром")
                        font.weight: 400
                        font.pixelSize: 16*scaleFactor
                        lineHeight: 1.2
                        color: Theme.isDarkTheme ? "#9CA3AF" : "#4B5563"
                        Behavior on color {
                            ColorAnimation {
                                duration: 250
                            }
                        }
                        font.family: "fonts/Roboto_Condensed-Regular.ttf"
                    }
                    RowLayout {
                        id:client_content_data_filter_list
                        height: client_content_data_filter_item.height
                        Rectangle {
                            id: client_content_data_filter_item
                            implicitHeight: client_content_data_filter_item_filter.height+ 5*scaleFactor
                            implicitWidth: client_content_data_filter_item_filter.width + 20*scaleFactor
                            radius: 9999
                            color: "#DBEAFE"
                            Text {
                                id: client_content_data_filter_item_filter
                                text: qsTr("IT услуги")
                                font.weight: 500
                                font.pixelSize: 12*scaleFactor
                                anchors.top: parent.top
                                anchors.topMargin: 2*scaleFactor
                                anchors.left: parent.left
                                anchors.leftMargin: 10*scaleFactor
                                color: "#1E40AF"
                                font.family: "fonts/Roboto_SemiCondensed-Medium.ttf"
                            }
                        }
                    }
                }
                Rectangle {
                    id: pay_indicator
                    //anchors.right: client_content.right
                    Layout.alignment: Qt.AlignRight
                    // Вместо height и width писать те же свойства, но implicit
                    implicitHeight: pay_indicator_text.height + 16*scaleFactor
                    implicitWidth: pay_indicator_text.width + 30*scaleFactor + pay_indicator_image.width + 8
                    radius: 9999
                    color: "#DCFCE7"
                    Image {
                        id: pay_indicator_image
                        source: "qrc:/images/Tick.svg"
                        width: 16*scaleFactor
                        height: 16*scaleFactor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16*scaleFactor
                    }
                    Text {
                        id: pay_indicator_text
                        text: qsTr("Оплачено")
                        color: "#166534"
                        font.weight: 500
                        font.pixelSize: 16*scaleFactor
                        lineHeight: 1
                        anchors.left: pay_indicator_image.right
                        anchors.leftMargin: 8
                        anchors.top: parent.top
                        anchors.topMargin: 8*scaleFactor
                        font.family: "fonts/Roboto_SemiCondensed-Medium.ttf"
                        // verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }


    ActionMenu {
        id:action_menu
        visible:false
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 32
        anchors.topMargin: 58

    }

    FormExit {
        id: formExit
         visible:false
    }
}
