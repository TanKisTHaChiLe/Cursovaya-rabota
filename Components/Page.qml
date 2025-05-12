import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import AppTheme 1.0
import com.example 1.0
import CRM.Database 1.0
import com.company.exporter 1.0
import QtQuick.Dialogs
import "."
import ".."

Rectangle {
    id:page
    property real originalWidth: 1200
    property real originalHeight: 700
    property real scaleFactor: Math.min(width / originalWidth, height / originalHeight)
    property color body_Background: Theme.isDarkTheme ? "#111827" : "#F2F4F4"
    property color block_Background: Theme.isDarkTheme ? "#1F2937" :  "#FFFFFF"

    property string taxation : ""
    property string payment: ""

    property string exportStatus: ""
        property color exportStatusColor: "green"

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
            if(formFilter.visible){
                formFilter.visible = false
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
                text: qsTr(UserSession.username)
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
                        onClicked: {
                                    // Установим имя файла по умолчанию
                            //var docsPath = StandardPath.writableLocation(StandardPath.DocumentsLocation)

                           saveDialog.open()
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
            ExcelExporter {
                id: excelExporter
            }

            FileDialog {
                id: saveDialog
                title: "Сохранить CSV файл"
                fileMode: FileDialog.SaveFile
                nameFilters: ["CSV Files (*.csv)"]
                defaultSuffix: "csv"
                // Component.onCompleted: {
                //     console.log(localFilePath)
                //     // Должен вывести ["exportToCSV", ...]
                // }
                onAccepted: {
                    //console.log(selectedFile)
                    var localFilePath = selectedFile.toString().replace(/^file:\/\/\//, "");
                    console.log(localFilePath)
                     var result = excelExporter.exportToCSV(DatabaseManager.filterClients(DatabaseManager.getClients(DatabaseManager.currentUserId),taxation,payment), localFilePath)
                     //ExcelExporter.exportToCSV(clientsListView.model, selectedFile)
                    if (result.success) {
                        exportStatus.text = "Файл сохранен: " + result.fileName
                        exportStatus.color = "green"
                    } else {
                        exportStatus.text = "Ошибка: " + (result.error || "Неизвестная ошибка")
                        exportStatus.color = "red"
                    }
                    // exportTimer.start()
                    // var clients = []
                    //        for (var i = 0; i < clientsListView.count; ++i) {
                    //            var client = clientsListView.model.get(i)
                    //            console.log("Клиент", i, ":", JSON.stringify(client)) // Отладка
                    //            clients.push(client)
                    //        }

                    //        // 2. Проверяем массив перед экспортом
                    //        if (clients.length === 0) {
                    //            console.error("Ошибка: массив clients пуст!")
                    //            return
                    //        }

                    //        // 3. Вызываем экспорт
                    //        var result = ExcelExporter.exportToCSV(clients, selectedFile)
                    //        console.log("Результат экспорта:", JSON.stringify(result))
                }
            }

            Label {
                id: exportStatus
                 z:1000
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 20
                }
            }

            Timer {
                id: exportTimer
                interval: 3000
                //z:1000
                onTriggered: exportStatus.text = ""
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
                    onClicked: {
                        stackView.push(add_client)
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
                    onClicked:{
                        formFilter.visible = !formFilter.visible
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
            ApplicationWindow {
                id: formFilter
                width: layout_Container.implicitWidth + 40 * scaleFactor
                height: layout_Container.implicitHeight + 40 * scaleFactor

                background: Rectangle {
                    color: block_Background
                    radius: 8 * scaleFactor
                    border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                    border.width: 1
                    layer.enabled: true

                }

                ColumnLayout {
                    id: layout_Container
                    anchors.fill: parent
                    anchors.margins: 20 * scaleFactor
                    spacing: 16 * scaleFactor

                    CheckBox {
                        id: nalog_filter
                        text: "Налоговая система"
                        font.pixelSize: 16 * scaleFactor
                        font.family: "fonts/Roboto_Condensed-Regular.ttf"
                        Layout.fillWidth: true
                        onCheckedChanged: {
                            if(checked){
                                taxation= comboBox1.currentText
                                 //console.log("Новый выбор (onActivated):", taxation)
                            }
                            else{
                                 taxation= ""
                                //console.log("Новый выбор (onActivated):", taxation)
                            }
                        }
                    }

                    ComboBox {
                        id: comboBox1
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42 * scaleFactor
                        model: ["ОСНО", "УСН 6%", "УСН доходы-расходы", "ЕСХН"]

                        enabled: nalog_filter.checked
                        currentIndex: 0

                        background: Rectangle {
                            border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                            color: enabled ? (Theme.isDarkTheme ? "#374151" : "#FFFFFF") : (Theme.isDarkTheme ? "#1F2937" : "#F3F4F6")
                            radius: 6 * scaleFactor
                        }

                        contentItem: Text {
                            text: comboBox1.displayText
                            font: comboBox1.font
                            color: enabled ? (Theme.isDarkTheme ? "#E5E7EB" : "#111827") : (Theme.isDarkTheme ? "#6B7280" : "#9CA3AF")
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12 * scaleFactor
                            rightPadding: 30 * scaleFactor
                        }

                        delegate: ItemDelegate {
                            width: comboBox1.width
                            height: 40 * scaleFactor
                            highlighted: comboBox1.highlightedIndex === index

                            contentItem: Text {
                                text: modelData
                                color: highlighted ? (Theme.isDarkTheme ? "#FFFFFF" : "#111827") : (Theme.isDarkTheme ? "#E5E7EB" : "#374151")
                                font.pixelSize: 14 * scaleFactor
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12 * scaleFactor
                            }

                            background: Rectangle {
                                color: Theme.isDarkTheme ? "#4B5563" : "#E5E7EB"
                                radius: 4 * scaleFactor
                            }
                        }


                        onActivated: (index) => {
                            taxation= model[index]
                            //console.log("Новый выбор (onActivated):", taxation)
                        }
                    }
                    CheckBox {
                        id: nalog_filter2
                        text: "Оплата"
                        font.pixelSize: 16 * scaleFactor
                        font.family: "fonts/Roboto_Condensed-Regular.ttf"
                        Layout.fillWidth: true
                        onCheckedChanged: {
                            if(checked){
                                payment= comboBox12.currentText
                                 //console.log("Новый выбор (onActivated):", payment)
                            }
                            else{
                                 payment= ""
                                //console.log("Новый выбор (onActivated):", payment)
                            }
                        }
                    }

                    ComboBox {
                        id: comboBox12
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42 * scaleFactor
                        model: ["Оплачено", "Просрочено"]
                        enabled: nalog_filter2.checked
                        currentIndex: 0

                        background: Rectangle {
                            border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                            color: enabled ? (Theme.isDarkTheme ? "#374151" : "#FFFFFF") : (Theme.isDarkTheme ? "#1F2937" : "#F3F4F6")
                            radius: 6 * scaleFactor
                        }

                        contentItem: Text {
                            text: comboBox12.displayText
                            font: comboBox12.font
                            color: enabled ? (Theme.isDarkTheme ? "#E5E7EB" : "#111827") : (Theme.isDarkTheme ? "#6B7280" : "#9CA3AF")
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12 * scaleFactor
                            rightPadding: 30 * scaleFactor
                        }

                        delegate: ItemDelegate {
                            width: comboBox12.width
                            height: 40 * scaleFactor
                            highlighted: comboBox12.highlightedIndex === index

                            contentItem: Text {
                                text: modelData
                                color: highlighted ? (Theme.isDarkTheme ? "#FFFFFF" : "#111827") : (Theme.isDarkTheme ? "#E5E7EB" : "#374151")
                                font.pixelSize: 14 * scaleFactor
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12 * scaleFactor
                            }

                            background: Rectangle {
                                color: Theme.isDarkTheme ? "#4B5563" : "#E5E7EB"
                                radius: 4 * scaleFactor
                            }
                        }
                        onActivated: (index) => {
                            payment= model[index]
                            //console.log("Новый выбор (onActivated):", payment)
                        }

                    }
                    Button {
                        id: addButton
                        text: "Добавить"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42 * scaleFactor
                        //enabled: nalog_filter.checked || nalog_filter2.checked
                        font.pixelSize: 16 * scaleFactor

                        background: Rectangle {
                            radius: 6 * scaleFactor
                            color: addButton.enabled ? (Theme.isDarkTheme ? "#4B5563" : "#D1D5DB") : (Theme.isDarkTheme ? "#1F2937" : "#F3F4F6")
                        }

                        contentItem: Text {
                            text: addButton.text
                            font: addButton.font
                            color: addButton.enabled ? (Theme.isDarkTheme ? "#E5E7EB" : "#111827") : (Theme.isDarkTheme ? "#6B7280" : "#9CA3AF")
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        Component.onCompleted: {
                            console.log("Методы DatabaseManager:", JSON.stringify(Object.keys(DatabaseManager)))
                            // Должен вывести ["exportToCSV", ...]
                        }
                        onClicked: {
                            clientsListView.model = DatabaseManager.filterClients(DatabaseManager.getClients(DatabaseManager.currentUserId),taxation,payment);
                            // taxation= ""
                            //  payment= "";
                            formFilter.close()
                            // Здесь можно добавить логику обработки
                        }
                    }
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
    Connections {
        target: DatabaseManager
        onClientsUpdated: {
                // Здесь вы можете вызвать метод для обновления списка клиентов
                clientsListView.model = DatabaseManager.getClients(DatabaseManager.currentUserId);
            console.log(DatabaseManager.getClients(DatabaseManager.currentUserId))
            }
        // onclientsFilterd: {
        //     clientsListView.model = DatabaseManager.filterClients( clientsListView.model);
        // }
    }

    ListView {
        id: clientsListView
        anchors {
            top: top_bar.bottom
            topMargin: 24
            left: parent.left
            leftMargin: 32
            right: parent.right
            rightMargin: 32
            bottom: parent.bottom
        }
        clip: true
        spacing: 20
        model: DatabaseManager.getClients(DatabaseManager.currentUserId)
        delegate:
            Rectangle {
                       id: client
                       height: client_content.height
                       width: clientsListView.width
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
                                  text: modelData.full_name || qsTr("Имя не указано")
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
                                    text: modelData.inn ? ("ИНН: " + modelData.inn) : qsTr("ИНН не указан")
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
                                           text:modelData.activity_type ? modelData.activity_type : qsTr("Вид деятельности не указан")
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
                               color:(modelData.individualaccount>0) ? "#DCFCE7" : "#FEE2E2"
                               Image {
                                    id: pay_indicator_image
                                    source: "qrc:/images/Tick.svg"
                                    width: 16*scaleFactor
                                    height: 16*scaleFactor
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 16*scaleFactor
                                    opacity: (modelData.individualaccount>0) ? 1 : 0
                               }
                               Image {
                                    id: pay_indicator_image2
                                    source: "qrc:/images/Warning.svg"
                                    width: 16*scaleFactor
                                    height: 16*scaleFactor
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 16*scaleFactor
                                    opacity: (modelData.individualaccount>0) ? 0 : 1
                               }
                               Text {
                                   id: pay_indicator_text
                                   text:(modelData.individualaccount>0) ? qsTr("Оплачено") : qsTr("Просрочено")
                                   color: (modelData.individualaccount>0) ? "#166534" : "#991B1B"
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
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            width: 5
        }

        Label {
            anchors.centerIn: parent
            text: qsTr("Пока нет клиентов")
            visible: clientsListView.count === 0
            font.pixelSize: 16 * scaleFactor
            color: Theme.isDarkTheme ? "#9CA3AF" : "#4B5563"
        }
        Component.onCompleted: {
            if (DatabaseManager.isAuthenticated) {
                DatabaseManager.getClients(DatabaseManager.currentUserId)
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

