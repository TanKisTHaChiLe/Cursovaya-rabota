import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import AppTheme 1.0
import CRM.Database 1.0


import "."
Rectangle {
    id: add_client_form
    // width: 1200*scaleFactor
    // height: 700*scaleFactor
    visible: true
    property real originalWidth: 1200
    property real originalHeight: 700
    property real scaleFactor: Math.min(width / originalWidth, height / originalHeight)
    property real scaleWidth: 1200/1440
    property real scaleHeight: 700/1024
    color: Theme.isDarkTheme ? "#111827" : "#F2F4F4"

    signal saveClient(var clientData)

    Rectangle {
        id: add_client_form_container
        color: Theme.isDarkTheme ? "#111827" : "#F2F4F4"
        anchors.horizontalCenter: parent.horizontalCenter
        width: header.width
        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.topMargin: 40*scaleHeight
            // anchors.left: parent.left
            // anchors.leftMargin: 32*scaleWidth
            width: 1376*scaleWidth*scaleFactor
            height: 38*scaleHeight*scaleFactor
            color: Theme.isDarkTheme ? "#111827" : "#F2F4F4"
            Text {
                anchors.left: parent.left
                id: header_text
                text: qsTr("Информация о клиенте")
                font.weight: 600
                font.pixelSize: 24*scaleFactor*scaleWidth
                font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                color:Theme.isDarkTheme ? "#FFFFFF" : "#111827"
            }
            Rectangle {
                id: save_batton
                anchors.right: close_button.left
                anchors.rightMargin: 16*scaleFactor*scaleWidth
                radius: 4
                border.color: "#2563EB"
                border.width: 1
                height: 38*scaleFactor*scaleHeight
                width: 125*scaleFactor*scaleWidth
                color: Theme.isDarkTheme ? "#1F2937" : "#2563EB"
                // MouseArea {
                //     anchors.fill: parent
                //     hoverEnabled: true
                //     cursorShape: Qt.PointingHandCursor
                //     onClicked: {
                //         stackView.pop();
                //     }
                // }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Подготовка данных в формате, соответствующем SQL-запросу
                        var clientData = {
                            // Основная информация
                            fullName: input_name.text,
                            phone: input_name2.text,
                            inn: input_name3.text,
                            activityType: input_name4.text,
                            startDate: input_name5.text,  // Ожидается формат "dd.MM.yyyy"

                            // Налоговая информация
                            taxationMode: comboBox1.currentText,
                            ppsn: input_name7.text,

                            // Числовые данные
                            employees: input_name8.text || 0,

                            // Дополнительная информация
                            kkt: input_name9.text,

                            // Платежная информация
                            paymentFrequency: comboBox.currentText,
                            //paymentAmount: input_name11.text,
                            individualAccount: input_name12.text || 0,

                            // Квартальные платежи
                            q1: input_q1.text || "0",  // Значения по умолчанию, если поля пустые
                            q2: input_q2.text || "0",
                            q3: input_q3.text || "0",
                            q4: input_q4.text || "0",

                            // Месячные
                            jan: input_jan.text || "0",
                            feb: input_feb.text || "0",
                            march: input_march.text || "0",
                            apr: input_apr.text || "0",
                            may: input_may.text || "0",
                            jun: input_jun.text || "0",
                            jul: input_jul.text || "0",
                            aug: input_aug.text || "0",
                            sep: input_sep.text || "0",
                            oct: input_oct.text || "0",
                            nov: input_nov.text || "0",
                            dec: input_dec.text || "0"
                        };

                        // Валидация обязательных полей
                        if (!clientData.fullName || !clientData.phone || !clientData.inn) {
                            console.error("Обязательные поля не заполнены!");
                            return;
                        }

                        // Проверка формата даты
                        var dateRegex = /^\d{2}\.\d{2}\.\d{4}$/;
                        if (!dateRegex.test(clientData.startDate) && clientData.startDate.length!==0) {
                            console.error("Некорректный формат даты! Используйте dd.MM.yyyy");
                            return;
                        }

                        // Отправка данных в C++ метод
                        var result = DatabaseManager.saveClient(clientData);
                        console.log("Результат сохранения:", result);
                        if (result) stackView.pop();

                        // add_client_form.saveClient(clientData);
                        // console.log(add_client_form.saveClient(clientData))
                        // stackView.pop();
                    }
                }

                Rectangle{
                    anchors.centerIn: parent
                    width: save_batton_text.width+7+save_batton_image.width
                    height: save_batton_text.height
                    color: Theme.isDarkTheme ? "#1F2937" : "#2563EB"

                    Image {
                         id: save_batton_image
                         anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/images/DiscretLightTheme.svg"
                        width: 12.25*scaleFactor*scaleHeight
                        height: 12.25*scaleFactor*scaleWidth
                        opacity: Theme.isDarkTheme ? 0 : 1
                     }
                    Image {
                         id: save_batton_image_dark
                         anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/images/DiscretDarkTheme.svg"
                        width: 12.25*scaleFactor*scaleHeight
                        height: 12.25*scaleFactor*scaleWidth
                        opacity: Theme.isDarkTheme ? 1 : 0
                     }
                    Text {
                        id: save_batton_text
                        anchors.left: save_batton_image.right
                        anchors.leftMargin: 7
                        text: qsTr("Сохранить")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#3B82F6" : "#FFFFFF"
                    }
                }

            }
            Rectangle {
                id:close_button
                anchors.right: end_button.left
                anchors.rightMargin: 16*scaleFactor*scaleWidth
                width: 118*scaleFactor*scaleWidth
                height: 38*scaleFactor*scaleHeight
                radius: 4
                border.width: 1
                color: Theme.isDarkTheme ? "#1F2937" : "#FFFFFF"
                border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                Rectangle {
                    id: close_button_container
                    width: close_button_text.width+8+close_button_image.width
                    height: close_button_text.height
                    anchors.centerIn: parent
                    color: Theme.isDarkTheme ? "#1F2937" : "#FFFFFF"
                    Image {
                        id: close_button_image
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/images/CloseLightTheme.svg"
                        width: 8.75*scaleFactor*scaleHeight
                        height: 8.75*scaleFactor*scaleWidth
                        opacity: Theme.isDarkTheme ? 0 : 1
                    }
                    Image {
                        id: close_button_image_dark
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/images/CloseDarkTheme.svg"
                        width: 8.75*scaleFactor*scaleHeight
                        height: 8.75*scaleFactor*scaleWidth
                        opacity: Theme.isDarkTheme ? 1 : 0
                    }
                    Text {
                        id: close_button_text
                        anchors.left: close_button_image.right
                        anchors.leftMargin: 8
                        text: qsTr("Отменить")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        stackView.pop();
                    }
                }
            }
            Rectangle {
                id: end_button
                anchors.right: header.right
                width: 228*scaleFactor*scaleWidth
                height: 38*scaleFactor*scaleHeight
                radius: 4
                border.width: 1
                border.color: "#FDE047"
                color: Theme.isDarkTheme ? "#1F2937" : "#FFFFFF"
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        stackView.pop();
                    }
                }
                Rectangle {
                    id: end_button_container
                    width: end_button_text.width+8+end_button_image.width
                    height: end_button_text.height
                    anchors.centerIn: parent
                    color: Theme.isDarkTheme ? "#1F2937" : "#FFFFFF"
                    Image {
                        id: end_button_image
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/images/EndLightTheme.svg"
                        width: 12.25*scaleFactor*scaleHeight
                        height: 8.75*scaleFactor*scaleWidth
                        opacity: Theme.isDarkTheme ? 0 : 1
                    }
                    Image {
                        id: end_button_image_dark
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/images/EndDarkTheme.svg"
                        width: 12.25*scaleFactor*scaleHeight
                        height: 8.75*scaleFactor*scaleWidth
                        opacity: Theme.isDarkTheme ? 1 : 0
                    }
                    Text {
                        id: end_button_text
                        anchors.left: end_button_image.right
                        anchors.leftMargin: 8
                        text: qsTr("Завершить обслуживание")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#EAB308" : "#A16207"
                    }
                }
            }
        }
        Rectangle {
            id: form_container
            anchors.top: header.bottom
            anchors.topMargin: 35*scaleFactor*scaleHeight
            height: 796*scaleHeight*scaleFactor
            width: 1376*scaleFactor*scaleWidth
            radius: 8
            color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
            Grid {
                id: grid_container1
                columns: 4
                rows: 3
                topPadding:24*scaleFactor*scaleHeight
                leftPadding: 24*scaleFactor*scaleWidth
                rightPadding: 24*scaleFactor*scaleWidth
                columnSpacing :16*scaleFactor*scaleWidth
                rowSpacing: 24*scaleFactor*scaleHeight
                Rectangle {
                    id: name
                    height: name_text.height + 4 + name_input.height
                    width: name_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text
                        text: qsTr("ФИО клиента")
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            placeholderText: "Иванов Иван Иванович"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth

                        }
                    }
                }
                Rectangle {
                    id: name2
                    height: name_text2.height + 4 + name_input2.height
                 width: name_input2.width
                 color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text2
                        text: qsTr("Контактный телефон")
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input2
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text2.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            placeholderText: "+79991234567"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name3
                    height: name_text3.height + 4 + name_input3.height
                    width: name_input3.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text3
                        text: qsTr("ИНН")
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input3
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text3.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name3
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                             placeholderText: "7712345678"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name4
                    height: name_text4.height + 4 + name_input4.height
                    width: name_input4.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text4
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Вид деятельности")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input4
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text4.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name4
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            placeholderText: "Розничная торговля"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name5
                    height: name_text5.height + 4 + name_input5.height
                    width: name_input5.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text5
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Дата начала обслуживания")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input5
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text5.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name5
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            placeholderText: "ггггммдд"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name6
                    height: name_text6.height + 4 + name_input6.height
                    width: name_input6.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text6
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Выберите режим налогообложения")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input6
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text6.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        ListModel {
                            id: optionsModel1
                            ListElement { name: "ОСНО" }
                            ListElement { name: "УСН 6%" }
                            ListElement { name: "УСН доходы-расходы" }
                            ListElement { name: "ЕСХН" }
                        }
                        ComboBox {
                            id: comboBox1
                            height: 42*scaleFactor*scaleHeight
                            width: 320*scaleFactor*scaleWidth
                            model: optionsModel1
                            textRole: "name"

                            background: Rectangle {
                                border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                                color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                                border.width: 1
                                radius: 4
                            }

                           font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                            font.pixelSize: 14 *scaleFactor*scaleWidth
                            padding: 8*scaleFactor

                            // onCurrentIndexChanged: {
                            //     // Получаем выбранный вариант
                            //     var selectedOption = comboBox.currentText;
                            //     console.log("Selected option:", selectedOption);

                            //     // Здесь вы можете выполнить дальнейшую обработку с выбранным вариантом
                            //     processSelectedOption(selectedOption);
                            // }
                            delegate: Item {
                                id:delegate
                               width: comboBox1.width
                               height: 40 // Высота каждого элемента

                               Rectangle {
                                   id: itemBackground
                                   color: (index === comboBox1.currentIndex) ? (Theme.isDarkTheme ? "#4B5563" : "#D1D5DB") : (Theme.isDarkTheme ? "#374151" : "#FFFFFF")
                                   anchors.fill: parent

                                   Text {
                                       text: model.name
                                       color: Theme.isDarkTheme ? "#FFFFFF" : "#000000" // Цвет текста
                                       anchors.centerIn: parent
                                   }
                               }

                               MouseArea {
                                   anchors.fill: parent
                                   onClicked: {
                                       comboBox1.currentIndex = index;
                                       comboBox1.popup.visible = false;
                                   }
                               }
                           }
                        }
                    }
                }
                Rectangle {
                    id: name7
                    height: name_text7.height + 4 + name_input7.height
                    width: name_input7.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text7
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("ПСН")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input7
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text7.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name7
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"

                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name8
                    height: name_text8.height + 4 + name_input8.height
                    width: name_input8.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text8
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Работники")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input8
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text8.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name8
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"

                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name9
                    height: name_text9.height + 4 + name_input9.height
                    width: name_input9.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text9
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("ККТ")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input9
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text9.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"

                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name10
                    height: name_text10.height + 4 + name_input10.height
                    width: name_input10.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text10
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Выберите периодичность оплаты")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input10
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text10.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        ListModel {
                            id: optionsModel
                            ListElement { name: "Ежемесячно" }
                            ListElement { name: "Ежеквартально" }
                        }
                        ComboBox {
                            id: comboBox
                            height: 42*scaleFactor*scaleHeight
                            width: 320*scaleFactor*scaleWidth
                            model: optionsModel
                            textRole: "name"

                            background: Rectangle {
                                border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                                color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                                border.width: 1
                                radius: 4
                            }
                            onCurrentIndexChanged: {
                                q1_input.enabled = (currentIndex === 1);
                                q2_input.enabled = (currentIndex === 1);
                                q3_input.enabled = (currentIndex === 1);
                                q4_input.enabled = (currentIndex === 1);
                                oct_input.enabled = (currentIndex === 0);
                                jan_input.enabled = (currentIndex === 0);
                                apr_input.enabled = (currentIndex === 0);
                                jul_input.enabled = (currentIndex === 0);
                                nov_input.enabled = (currentIndex === 0);
                                feb_input.enabled = (currentIndex === 0);
                                may_input.enabled = (currentIndex === 0);
                                aug_input.enabled = (currentIndex === 0);
                                dec_input.enabled = (currentIndex === 0);
                                march_input.enabled = (currentIndex === 0);
                                jun_input.enabled = (currentIndex === 0);
                                sep_input.enabled = (currentIndex === 0);
                            }
                           font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                            font.pixelSize: 14 *scaleFactor*scaleWidth
                            padding: 8*scaleFactor
                            // onCurrentIndexChanged: {
                            //     // Получаем выбранный вариант
                            //     var selectedOption = comboBox.currentText;
                            //     console.log("Selected option:", selectedOption);

                            //     // Здесь вы можете выполнить дальнейшую обработку с выбранным вариантом
                            //     processSelectedOption(selectedOption);
                            // }
                            delegate: Item {
                                id:delegate
                               width: comboBox.width
                               height: 40 // Высота каждого элемента

                               Rectangle {
                                   id: itemBackground2
                                   color: (index === comboBox.currentIndex) ? (Theme.isDarkTheme ? "#4B5563" : "#D1D5DB") : (Theme.isDarkTheme ? "#374151" : "#FFFFFF")
                                   anchors.fill: parent

                                   Text {
                                       text: model.name
                                       color: Theme.isDarkTheme ? "#FFFFFF" : "#000000" // Цвет текста
                                       anchors.centerIn: parent
                                   }
                               }

                               MouseArea {
                                   anchors.fill: parent
                                   onClicked: {
                                       comboBox.currentIndex = index;
                                       comboBox.popup.visible = false;
                                   }
                               }
                           }
                        }
                    }
                }
                Rectangle {
                    id: name11
                    height: name_text11.height + 4 + name_input11.height
                    width: name_input11.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text11
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Сумма платежа")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input11
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text11.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name11
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
                Rectangle {
                    id: name12
                    height: name_text12.height + 4 + name_input12.height
                    width: name_input12.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: name_text12
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Индивидуальный счет")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: Theme.isDarkTheme ? "#D1D5DB" : "#374151"
                    }
                    Rectangle {
                        id: name_input12
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: name_text12.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        TextField {
                            id: input_name12
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            placeholderText: "Баланс"

                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                        }
                    }
                }
            }
            Text {
                id: text
                text: qsTr("Оплаты по кварталам")
                anchors.top: grid_container1.bottom
                anchors.topMargin: 32*scaleFactor*scaleHeight
                anchors.left: parent.left
                anchors.leftMargin: 24*scaleFactor*scaleWidth
                font.family: "fonts/Roboto_Condensed-Regular.ttf"
                font.weight: 500
                color: Theme.isDarkTheme ? "#FFFFFF" : "#111827"
                font.pixelSize: 18*scaleFactor*scaleWidth
            }
            Grid {
                id:grid_container2
                anchors.top: text.bottom

                columns: 4
                rows:1
                spacing: 16*scaleFactor*scaleWidth
                topPadding:16*scaleFactor*scaleHeight
                leftPadding: 24*scaleFactor*scaleWidth
                rightPadding: 24*scaleFactor*scaleWidth
                Rectangle{
                    id: q4
                    height: q4_text.height + 16*scaleFactor*scaleHeight + q4_input.height
                    width: q4_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: q4_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("4 квартал")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                       color: !q4_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: q4_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: q4_text.bottom
                        anchors.topMargin: 16*scaleFactor*scaleHeight
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                            color: "#13000000"
                            visible: !parent.enabled // Показываем затемнение, если родитель отключен
                            radius: 6
                        }
                        TextField {
                            id: input_q4
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                             enabled: parent.enabled
                        }
                    }
                }
                Rectangle{
                    id: q1
                    height: q1_text.height + 16*scaleFactor*scaleHeight + q1_input.height
                    width: q1_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: q1_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("1 квартал")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                       color: !q1_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: q1_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: q1_text.bottom
                        anchors.topMargin: 16*scaleFactor*scaleHeight
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                            color: "#13000000"
                            visible: !parent.enabled // Показываем затемнение, если родитель отключен
                            radius: 6
                        }
                        TextField {
                            id: input_q1
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            text: parent.enabled ? input_name11.text : ""
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle{
                    id: q2
                    height: q2_text.height + 16*scaleFactor*scaleHeight + q2_input.height
                    width: q2_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: q2_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("2 квартал")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !q2_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: q2_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: q2_text.bottom
                        anchors.topMargin: 16*scaleFactor*scaleHeight
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                         enabled: false
                         Rectangle {
                             anchors.fill: parent
                              color: "#13000000"
                             visible: !parent.enabled // Показываем затемнение, если родитель отключен
                             radius: 6
                         }
                        TextField {
                            id: input_q2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                             enabled: parent.enabled
                        }
                    }
                }
                Rectangle{
                    id: q3
                    height: q3_text.height + 16*scaleFactor*scaleHeight + q3_input.height
                    width: q3_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: q3_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("3 квартал")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                       color: !q3_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: q3_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: q3_text.bottom
                        anchors.topMargin: 16*scaleFactor*scaleHeight
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                         enabled: false
                         Rectangle {
                             anchors.fill: parent
                            color: "#13000000"
                             visible: !parent.enabled // Показываем затемнение, если родитель отключен
                             radius: 6
                         }
                        TextField {
                            id: input_q3
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
            }
            Grid {
                id: grid_container3
                anchors.top: grid_container2.bottom
                columns: 4
                rows:3
                spacing: 16*scaleFactor*scaleWidth
                topPadding:16*scaleFactor*scaleHeight
                leftPadding: 24*scaleFactor*scaleWidth
                rightPadding: 24*scaleFactor*scaleWidth

                Rectangle {
                    id: oct
                    height: oct_text.height + 4 + oct_input.height
                    width: oct_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: oct_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Октябрь")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !oct_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: oct_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: oct_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                             color: "#13000000"
                            visible: !parent.enabled // Показываем затемнение, если родитель отключен
                            radius: 6
                        }
                        TextField {
                            id: input_oct
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: jan
                    height: jan_text.height + 4 + jan_input.height
                    width: jan_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: jan_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Январь")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !jan_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: jan_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: jan_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                             color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_jan
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: apr
                    height: apr_text.height + 4 + apr_input.height
                    width: apr_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: apr_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Апрель")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"

                        color: !apr_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: apr_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: apr_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                             color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_apr
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: jul
                    height: jul_text.height + 4 + jul_input.height
                    width: jul_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: jul_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Июль")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !jul_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: jul_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: jul_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                             color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_jul
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: nov
                    height: nov_text.height + 4 + nov_input.height
                    width: nov_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: nov_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Ноябрь")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                         color: !nov_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: nov_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: nov_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                             color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_nov
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: feb
                    height: feb_text.height + 4 + feb_input.height
                    width: feb_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: feb_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Февраль")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !feb_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: feb_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: feb_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                            color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_feb
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: may
                    height: may_text.height + 4 + may_input.height
                    width: may_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: may_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Май")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !may_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id: may_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: may_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                            color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_may
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: aug
                    height: aug_text.height + 4 + aug_input.height
                    width: aug_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: aug_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Август")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !aug_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id:aug_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: aug_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                            color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_aug
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: dec
                    height: dec_text.height + 4 + dec_input.height
                    width: dec_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: dec_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Декабрь")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !dec_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id:dec_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: dec_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                             color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_dec
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            text: parent.enabled ? input_name11.text : ""
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: march
                    height: march_text.height + 4 + march_input.height
                    width: march_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: march_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Март")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                         color: !march_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id:march_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: march_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                             color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_march
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: parent.enabled ? input_name11.text : ""
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: jun
                    height: jun_text.height + 4 + jun_input.height
                    width: jun_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: jun_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Июнь")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !jun_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id:jun_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: jun_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                            color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_jun
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: parent.enabled ? input_name11.text : ""
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
                Rectangle {
                    id: sep
                    height: sep_text.height + 4 + sep_input.height
                    width: sep_input.width
                    color:Theme.isDarkTheme ?"#1F2937" : "#FFFFFF"
                    Text {
                        id: sep_text
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        text: qsTr("Сентябрь")
                        font.weight: 500
                        font.pixelSize: 14*scaleFactor*scaleWidth
                        font.family: "qrc:/fonts/Roboto_Condensed-Regular.ttf"
                        color: !sep_input.enabled ? "#6B7280" : (Theme.isDarkTheme ? "#D1D5DB" : "#374151")
                    }
                    Rectangle {
                        id:sep_input
                        height: 42*scaleFactor*scaleHeight
                        width: 320*scaleFactor*scaleWidth
                        anchors.top: sep_text.bottom
                        anchors.topMargin: 4
                        radius: 6
                        border.width: 1
                        border.color: Theme.isDarkTheme ? "#4B5563" : "#D1D5DB"
                        color: Theme.isDarkTheme ? "#374151" : "#FFFFFF"
                        enabled: false
                        Rectangle {
                            anchors.fill: parent
                            color: "#13000000"
                            visible: !parent.enabled
                            radius: 6
                        }
                        TextField {
                            id: input_sep
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: parent.enabled ? input_name11.text : ""
                            background: null
                            placeholderTextColor: Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            color:Theme.isDarkTheme ? "#FFFFFF" : "#6B7280"
                            font.family: "fonts/Roboto_Condensed-Regular.ttf"
                            font.weight: 400
                            font.pixelSize: 14*scaleFactor*scaleWidth
                            enabled: parent.enabled
                        }
                    }
                }
            }
        }
    }
}
