// #include <QGuiApplication>
// #include <QQmlApplicationEngine>
// #include <QtQml>
// #include "DatabaseManager.h"



// int main(int argc, char *argv[])
// {
//     QGuiApplication app(argc, argv);

//     qmlRegisterSingletonType(QUrl("qrc:/Components/Theme.qml"), "AppTheme", 1, 0, "Theme");



//     qmlRegisterSingletonType<DatabaseManager>(
//         "CRM.Database", 1, 0, "DatabaseManager",
//         [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
//             Q_UNUSED(engine)
//             Q_UNUSED(scriptEngine)
//             return new DatabaseManager();
//         }
//         );
// \
//         QQmlApplicationEngine engine2;
// DatabaseManager databaseManager;
//     // Регистрируем databaseManager в QML контексте
//     engine2.rootContext()->setContextProperty("databaseManager", &databaseManager);

//      qmlRegisterType<DatabaseManager>("CRM.Database", 1, 1, "DatabaseManager");


//     QQmlApplicationEngine engine;
//     QObject::connect(
//         &engine,
//         &QQmlApplicationEngine::objectCreationFailed,
//         &app,
//         []() { QCoreApplication::exit(-1); },
//         Qt::QueuedConnection);
//     engine.loadFromModule("CRM-system", "Main");

//     return app.exec();
// }
// main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "DatabaseManager.h"

// int main(int argc, char *argv[])
// {
//     QGuiApplication app(argc, argv);

//     // Регистрация темы
//     qmlRegisterSingletonType(QUrl("qrc:/Components/Theme.qml"), "AppTheme", 1, 0, "Theme");

//     // Регистрация DatabaseManager как синглтона
//     qmlRegisterSingletonType<DatabaseManager>(
//         "CRM.Database", 1, 0, "DatabaseManager",
//         [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
//             Q_UNUSED(engine)
//             Q_UNUSED(scriptEngine)
//             DatabaseManager* dbManager = new DatabaseManager();
//             // Убедимся, что соединение с базой данных установлено
//             if (!dbManager->initializeDatabase()) {
//                 qCritical() << "Failed to initialize database!";
//             }
//             return dbManager;
//         }
//         );

//     // Убрали дублирующую регистрацию и создание экземпляра DatabaseManager

//     QQmlApplicationEngine engine;
//     QObject::connect(
//         &engine,
//         &QQmlApplicationEngine::objectCreationFailed,
//         &app,
//         []() { QCoreApplication::exit(-1); },
//         Qt::QueuedConnection);
//     engine.loadFromModule("CRM-system", "Main");

//     return app.exec();
// }
// #include <QGuiApplication>
// #include <QQmlApplicationEngine>
// #include <QtQml>
// #include "DatabaseManager.h"

// int main(int argc, char *argv[])
// {
//     QGuiApplication app(argc, argv);

//     QSqlDatabase testDb = QSqlDatabase::addDatabase("QPSQL", "health_check");
//     testDb.setHostName("localhost");
//     if (!testDb.open()) {
//         qDebug() << "Запускаем PostgreSQL...";

//         #ifdef Q_OS_WINDOWS
//         QProcess::execute("net start postgresql-x64-15");
//         #elif defined(Q_OS_LINUX)
//         QProcess::execute("sudo systemctl start postgresql");
//         #endif

//         QThread::sleep(3);  // Даем время на запуск
//     }


//     // Регистрация темы
//     qmlRegisterSingletonType(QUrl("qrc:/Components/Theme.qml"), "AppTheme", 1, 0, "Theme");

//     // Создаем экземпляр DatabaseManager до создания QML-движка
//     DatabaseManager* dbManager = new DatabaseManager();

//     // Регистрация DatabaseManager как синглтона
//     qmlRegisterSingletonInstance<DatabaseManager>(
//         "CRM.Database", 1, 0, "DatabaseManager", dbManager);

//     // Инициализация базы данных
//     if (!dbManager->initializeDatabase()) {
//         qCritical() << "Failed to initialize database!";
//         return -1;
//     }

//     // Обработка завершения приложения
//     QObject::connect(&app, &QGuiApplication::aboutToQuit, [dbManager]() {
//         qDebug() << "Application is quitting, performing cleanup...";
//         dbManager->forceLogout();
//     });

//     QQmlApplicationEngine engine;

//     // Обработка ошибок создания QML-объектов
//     QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
//                      &app, []() {
//                          qCritical() << "QML object creation failed!";
//                          QCoreApplication::exit(-1);
//                      },
//                      Qt::QueuedConnection);

//     // Загрузка главного QML-файла
//     engine.loadFromModule("CRM-system", "Main");

//     // Установка контекста для доступа из QML (альтернативный вариант)
//     engine.rootContext()->setContextProperty("databaseManager", dbManager);

//     return app.exec();
// }
//работающий автозапуск
// #include <QGuiApplication>
// #include <QQmlApplicationEngine>
// #include <QtQml>
// #include "DatabaseManager.h"
// #include <QProcess>
// #include <QThread>

// int main(int argc, char *argv[])
// {
//     QGuiApplication app(argc, argv);

//     // Настройка формата логов
//     qSetMessagePattern("[%{time hh:mm:ss}] %{type} %{file}:%{line} - %{message}");

//     // Регистрация темы
//     qmlRegisterSingletonType(QUrl("qrc:/Components/Theme.qml"), "AppTheme", 1, 0, "Theme");

//     // Создание и регистрация DatabaseManager
//     DatabaseManager* dbManager = new DatabaseManager();
//     qmlRegisterSingletonInstance<DatabaseManager>(
//         "CRM.Database", 1, 0, "DatabaseManager", dbManager);

//     // Обработка завершения приложения
//     QObject::connect(&app, &QGuiApplication::aboutToQuit, [dbManager]() {
//         qDebug() << "Application is quitting, performing cleanup...";
//         dbManager->forceLogout();
//         delete dbManager;
//     });

//     QQmlApplicationEngine engine;

//     // Обработка ошибок создания QML-объектов
//     QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
//                      &app, []() {
//                          qCritical() << "Failed to create QML objects!";
//                          QCoreApplication::exit(-1);
//                      },
//                      Qt::QueuedConnection);

//     // Загрузка главного QML-файла
//     engine.loadFromModule("CRM-system", "Main");

//     return app.exec();
// }
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "DatabaseManager.h"
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

    // Создание и регистрация DatabaseManager
    DatabaseManager* dbManager = new DatabaseManager();
    qmlRegisterSingletonInstance<DatabaseManager>(
        "CRM.Database", 1, 0, "DatabaseManager", dbManager);

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
