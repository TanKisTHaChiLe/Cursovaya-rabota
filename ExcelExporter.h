#ifndef EXCELEXPORTER_H
#define EXCELEXPORTER_H

#include <QObject>
#include <QVariant>
#include <QList>

class ExcelExporter : public QObject
{
    Q_OBJECT
public:
    explicit ExcelExporter(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap exportToCSV(const QVariantList &clients, const QString &filePath);
};

#endif // EXCELEXPORTER_H
