#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "DatabaseManager.h"
#include "ExcelExporter.h"
#include <QProcess>
#include <QThread>
#include <QFile>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Настройка формата логов
    qSetMessagePattern("[%{time hh:mm:ss}] %{type} %{file}:%{line} - %{message}");

    // Регистрация темы
    qmlRegisterSingletonType(QUrl("qrc:/Components/Theme.qml"), "AppTheme", 1, 0, "Theme");

    qmlRegisterSingletonType(QUrl("qrc:/Components/UserSession.qml"),"com.example", 1, 0, "UserSession");

    qmlRegisterType<ExcelExporter>("com.company.exporter", 1, 0, "ExcelExporter");

    // Создание и регистрация DatabaseManager
    DatabaseManager* dbManager = new DatabaseManager();
    qmlRegisterSingletonInstance<DatabaseManager>("CRM.Database", 1, 0, "DatabaseManager", dbManager);

    qmlRegisterType<DatabaseManager>("CRM.Database", 1, 1, "DatabaseManager");

    // Обработка завершения приложения
    QObject::connect(&app, &QGuiApplication::aboutToQuit, [dbManager]() {
        qDebug() << "Application is quitting, performing cleanup...";
        dbManager->forceLogout();
        dbManager->shutdownPostgresServer(); // Вызов остановки сервера
        delete dbManager;
    });

    QQmlApplicationEngine engine;

    // Обработка ошибок создания QML-объектов
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() {
                         qCritical() << "Failed to create QML objects!";
                         QCoreApplication::exit(-1);
                     },
                     Qt::QueuedConnection);

    // Загрузка главного QML-файла
    engine.loadFromModule("CRM-system", "Main");

    return app.exec();
}
