#include "ExcelExporter.h"
#include <QCryptographicHash>
#include <QDebug>
#include <QSqlRecord>
#include <QFile>
#include <QStandardPaths>
#include <QDate>
#include <QFileInfo>
#include <QDir>

#include <QTextStream>
#include <QDateTime>



ExcelExporter::ExcelExporter(QObject *parent) : QObject(parent) {}

QVariantMap ExcelExporter::exportToCSV(const QVariantList &clients, const QString &filePath)
{
    QVariantMap result;
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        result["success"] = false;
        result["error"] = file.errorString();
        return result;
    }

    // Записываем BOM для UTF-8 вручную
    file.write("\xEF\xBB\xBF");

    QTextStream out(&file);
    out.setEncoding(QStringConverter::Utf8);

    // Заголовки CSV
    out << "ID;ФИО;ИНН;Телефон;Вид деятельности;Кол-во сотрудников;"
        << "Тип оплаты;Система налогообложения;Дата начала обслуживания;"
        << "Январь;Февраль;Март;Апрель;Май;Июнь;Июль;Август;"
        << "Сентябрь;Октябрь;Ноябрь;Декабрь;1 квартал;2 квартал;"
        << "3 квартал;4 квартал;Лицевой счет"<< "\r";

    // Данные клиентов
    bool firstLine = true;
    for (const QVariant &clientVariant : clients) {

        //out << "\r\n";  // Добавляем перевод строки только перед всеми строками, кроме первой


        QVariantMap client = clientVariant.toMap();
        out << client["id"].toInt() << ";"
            << "\"" << client["full_name"].toString().replace("\"", "\"\"") << "\"" << ";"
            << client["inn"].toString() << ";"
            << client["phone"].toString() << ";"
            << "\"" << client["activity_type"].toString().replace("\"", "\"\"") << "\"" << ";"
            << client["employees_count"].toInt() << ";"
            << "\"" << client["payment_type"].toString().replace("\"", "\"\"") << "\"" << ";"
            << "\"" << client["tax_system"].toString().replace("\"", "\"\"") << "\"" << ";"
            << client["service_start_date"].toDate().toString("dd.MM.yyyy") << ";"
            << QString::number(client["jan_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["feb_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["mar_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["apr_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["may_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["jun_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["jul_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["aug_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["sep_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["oct_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["nov_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["dec_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["q1_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["q2_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["q3_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["q4_amount"].toDouble(), 'f', 2).replace(".", ",") << ";"
            << QString::number(client["individualaccount"].toDouble(), 'f', 2).replace(".", ",")<< "\r";
    }

    file.close();

    // Возвращаем информацию о файле
    QFileInfo fileInfo(filePath);
    result["success"] = true;
    result["filePath"] = filePath;
    result["fileName"] = fileInfo.fileName();
    result["fileSize"] = fileInfo.size();
    result["created"] = QDateTime::currentDateTime().toString(Qt::ISODate);

    return result;
}
