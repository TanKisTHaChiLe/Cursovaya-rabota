#include "DatabaseManager.h"
#include <QCryptographicHash>
#include <QDebug>
#include <QSqlRecord>
#include <QFile>
#include <QStandardPaths>
#include <QDate>
#include <QFileInfo>
#include <QDir>
#include  <iostream>
DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{
    if (!initializeDatabase()) {
        emit connectionError(tr("Не удалось подключиться к базе данных"));
    }
}

DatabaseManager::~DatabaseManager()
{
    cleanupConnection();
    if (m_wasServerStartedByApp) {
        shutdownPostgresServer();
    }
}
bool DatabaseManager::initializeDatabase()
{
    cleanupConnection();

    // Настройка подключения
    m_db = QSqlDatabase::addDatabase("QPSQL");
    m_db.setHostName("localhost");
    m_db.setPort(5432);
    m_db.setDatabaseName("postgres");
    m_db.setUserName("postgres");
    m_db.setPassword("zukozuko_2019A1");
    m_db.setConnectOptions("connect_timeout=5");
    if(m_db.isOpen()){
        qDebug() << "PostgreSQL service stopped successfully";

    }
    // Проверка конфигурации
    if (!verifyDatabaseConfiguration()) {
        emit connectionError(tr("Неверная конфигурация базы данных"));
        return false;
    }

    // Проверка доступности сервера
    if (!isServerAvailable()) {
        qDebug() << "PostgreSQL server is not running, attempting to start...";

#ifdef Q_OS_WINDOWS
        if (startPostgresService() || startPostgresProcessManually()) {
            m_wasServerStartedByApp = true;
            qDebug() << "PostgreSQL server started by application";
        } else {
            emit connectionError(tr("Не удалось запустить службу PostgreSQL"));
            return false;
        }
#else
        if (startPostgresProcess()) {
            m_wasServerStartedByApp = true;
            qDebug() << "PostgreSQL server started by application";
        } else {
            emit connectionError(tr("Не удалось запустить процесс PostgreSQL"));
            return false;
        }
#endif

        QThread::sleep(5);
    }

    if (!m_db.open()) {
        QString error = m_db.lastError().text();
        qCritical() << "DB Connection Error:" << error;
        emit connectionError(tr("Ошибка подключения: ") + error);
        return false;
    }

    emit connectionChanged(true);
    qDebug() << "Successfully connected to PostgreSQL";
    return true;
}

void DatabaseManager::shutdownPostgresServer()
{
    qDebug() << "Attempting to shutdown PostgreSQL server...";

#ifdef Q_OS_WINDOWS
    QString serviceName = getPostgresServiceName();
    if (!serviceName.isEmpty()) {
        QProcess process;
        process.start("net", {"stop", serviceName});
        if (process.waitForFinished(10000)) {
            qDebug() << "PostgreSQL service stopped successfully";
        } else {
            qWarning() << "Failed to stop PostgreSQL service:" << process.errorString();
        }
    }

    // Дополнительная попытка через pg_ctl
    QString pgPath = getPostgresInstallPath() + "\\bin\\pg_ctl.exe";
    QFileInfo pgFile(pgPath);
    if (pgFile.exists()) {
        QProcess process;
        process.start(pgPath, {"stop", "-D", getPostgresInstallPath() + "\\data"});
        if (process.waitForFinished(10000)) {
            qDebug() << "PostgreSQL stopped via pg_ctl";
        } else {
            qWarning() << "Failed to stop PostgreSQL via pg_ctl:" << process.errorString();
        }
    }
#else
    QProcess process;
    process.start("pg_ctl", {"stop", "-D", "/usr/local/var/postgres"});
    if (process.waitForFinished(10000)) {
        qDebug() << "PostgreSQL server stopped successfully";
    } else {
        qWarning() << "Failed to stop PostgreSQL server:" << process.errorString();
    }
#endif
}

bool DatabaseManager::isServerAvailable()
{
    QSqlDatabase testDb = QSqlDatabase::addDatabase("QPSQL", "test_connection");
    testDb.setHostName("localhost");
    testDb.setDatabaseName("postgres");
    testDb.setUserName("postgres");
    testDb.setConnectOptions("connect_timeout=2");

    bool ok = testDb.open();
    if (ok) {
        testDb.close();
    }
    // Важно: удаляем соединение после использования
    QSqlDatabase::removeDatabase("test_connection"); // Добавлена эта строка
    return ok;
}
#ifdef Q_OS_WINDOWS
bool DatabaseManager::startPostgresService()
{
    QString serviceName = getPostgresServiceName();
    if (serviceName.isEmpty()) {
        qCritical() << "PostgreSQL service not found";
        return false;
    }

    QProcess process;
    process.setProcessChannelMode(QProcess::MergedChannels);
    process.start("net", {"start", serviceName});

    if (!process.waitForFinished(10000)) {
        qCritical() << "Service start timeout:" << process.errorString();
        return false;
    }

    if (process.exitCode() != 0) {
        QString error = QString::fromLocal8Bit(process.readAllStandardError());
        if (error.isEmpty()) {
            error = QString::fromLocal8Bit(process.readAllStandardOutput());
        }
        qCritical() << "Failed to start service:" << error;

        // Дополнительная попытка запуска через pg_ctl
        return startPostgresProcessManually();
    }

    return true;
}


QString DatabaseManager::getPostgresInstallPath() const
{
    // Проверяем стандартные пути установки
    const QStringList possiblePaths = {
        "C:\\Program Files\\PostgreSQL\\17",
        "C:\\Program Files\\PostgreSQL\\16",
        "C:\\Program Files\\PostgreSQL\\15",
        "C:\\Program Files\\PostgreSQL\\14",
        "C:\\Program Files\\PostgreSQL\\13",
        "D:\\Program Files\\PostgreSQL\\17",
        "D:\\Program Files\\PostgreSQL\\16"
    };

    // Проверяем каждый путь
    for (const QString &path : possiblePaths) {
        QDir dir(path);
        if (dir.exists() && dir.exists("bin") && dir.exists("data")) {
            return path;
        }
    }

    // Если не нашли в стандартных путях, проверяем реестр
    QSettings registry("HKEY_LOCAL_MACHINE\\SOFTWARE\\PostgreSQL", QSettings::NativeFormat);
    QStringList groups = registry.childGroups();
    if (!groups.isEmpty()) {
        QString latestVersion = groups.last();
        QString installDir = registry.value(latestVersion + "/InstallDir").toString();
        if (!installDir.isEmpty()) {
            return installDir;
        }
    }

    // Если ничего не нашли, возвращаем путь по умолчанию
    return "D:\\Program Files\\PostgreSQL\\17";
}

bool DatabaseManager::startPostgresProcessManually()
{
    QString pgPath = "D:\\Program Files\\PostgreSQL\\17\\bin\\pg_ctl.exe";
    QProcess process;
    process.setProcessChannelMode(QProcess::MergedChannels);
    process.start(pgPath, {"start", "-D", "D:\\Program Files\\PostgreSQL\\17\\data"});

    if (!process.waitForFinished(10000)) {
        qCritical() << "Manual start timeout:" << process.errorString();
        return false;
    }

    if (process.exitCode() != 0) {
        QString error = QString::fromLocal8Bit(process.readAllStandardError());
        qCritical() << "Manual start failed:" << error;
        return false;
    }

    return true;
}

QString DatabaseManager::getPostgresServiceName() const
{
    // Можно реализовать автоматический поиск службы
    return "postgresql-x64-17";
}
#else
bool DatabaseManager::startPostgresProcess()
{
    QProcess process;
    process.start("pg_ctl", {"start", "-D", "/usr/local/var/postgres"});

    if (!process.waitForFinished(5000)) {
        qCritical() << "Process start timeout:" << process.errorString();
        return false;
    }

    return process.exitCode() == 0;
}
#endif

void DatabaseManager::cleanupConnection()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
    if (QSqlDatabase::contains(QSqlDatabase::defaultConnection)) {
        QSqlDatabase::removeDatabase(QSqlDatabase::defaultConnection);
    }
}

bool DatabaseManager::verifyDatabaseConfiguration()
{
    if (m_db.hostName().isEmpty() ||
        m_db.databaseName().isEmpty() ||
        m_db.userName().isEmpty()) {
        qCritical() << "Database configuration error:"
                    << "\nHost:" << m_db.hostName()
                    << "\nDatabase:" << m_db.databaseName()
                    << "\nUser:" << m_db.userName();
        return false;
    }
    return true;
}

QString DatabaseManager::hashPassword(const QString &password)
{
    return QCryptographicHash::hash(
               password.toUtf8(),
               QCryptographicHash::Sha256
               ).toHex();
}

bool DatabaseManager::registerUser(const QString &username, const QString &password)
{
    if (!isConnected()) {
        emit connectionError(tr("Нет подключения к базе данных"));
        return false;
    }

    QSqlQuery query(m_db);
    query.prepare("INSERT INTO users (username, password_hash, created_at) VALUES (?, ?, CURRENT_TIMESTAMP)");
    query.addBindValue(username);
    query.addBindValue(hashPassword(password));

    if (!query.exec()) {
        QString error = query.lastError().text();
        qWarning() << "Failed to register user:" << error;
        emit connectionError(tr("Ошибка регистрации: ") + error);
        return false;
    }
    return true;
}

bool DatabaseManager::authenticateUser(const QString &username, const QString &password)
{
    if (!isConnected()) {
        emit loginFailed(tr("Нет подключения к базе данных"));
        return false;
    }

    QSqlQuery query(m_db);
    query.prepare("SELECT id FROM users WHERE username = ? AND password_hash = ?");
    query.addBindValue(username);
    query.addBindValue(hashPassword(password));

    if (query.exec() && query.next()) {
        m_currentUserId = query.value(0).toInt();
        emit currentUserIdChanged();
        emit authenticationChanged();
        emit loginSuccess();
        return true;
    }

    emit loginFailed(tr("Неверное имя пользователя или пароль"));
    return false;
}

void DatabaseManager::logoutUser()
{
    qDebug() << "Logging out user ID:" << m_currentUserId;
    m_currentUserId = -1;
    emit currentUserIdChanged();
    emit authenticationChanged();
    emit logoutSuccess();
}

void DatabaseManager::forceLogout()
{
    logoutUser();
    cleanupConnection();
}

bool DatabaseManager::saveClient(const QVariantMap &clientData)
{
    if (!isConnected()) {
        emit connectionError(tr("Нет подключения к базе данных"));
        return false;
    }

    // Собираем строку для поиска заранее
    QString searchText = QString("%1 %2 %3")
                             .arg(clientData["fullName"].toString())
                             .arg(clientData["phone"].toString())
                             .arg(clientData["inn"].toString());

    // Формируем базовый запрос без to_tsvector
    QString sql = QString(
                      "INSERT INTO clients ("
                      "user_id, full_name, phone, inn, activity_type, "
                      "service_start_date, tax_system, psn, employees_count, "
                      "has_kkt, payment_type,"
                      "jan_amount, feb_amount, mar_amount, apr_amount, "
                      "may_amount, jun_amount, jul_amount, aug_amount, "
                      "sep_amount, oct_amount, nov_amount, dec_amount, "
                      "q1_amount, q2_amount, q3_amount, q4_amount, "
                      "created_at, updated_at, search_vector, individualaccount"
                      ") VALUES ("
                      "%1, '%2', '%3', '%4', '%5', "
                      "'%6', '%7', '%8', %9, "
                      "'%10', '%11', "
                      "%13, %14, %15, %16, "
                      "%17, %18, %19, %20, "
                      "%21, %22, %23, %24, "
                      "%25, %26, %27, %28, "
                      "CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, "
                      "to_tsvector('%29'), %12"
                      ")")
                      .arg(m_currentUserId)
                      .arg(clientData["fullName"].toString().replace("'", "''"))
                      .arg(clientData["phone"].toString().replace("'", "''"))
                      .arg(clientData["inn"].toString().replace("'", "''"))
                      .arg(clientData["activityType"].toString().replace("'", "''"))
                      .arg(QDate::fromString(clientData["startDate"].toString(), "dd.MM.yyyy").toString("yyyy-MM-dd"))
                      .arg(clientData["taxationMode"].toString().replace("'", "''"))
                      .arg(clientData["ppsn"].toString().replace("'", "''"))
                      .arg(clientData["employees"].toInt())
                      .arg(clientData["kkt"].toString().replace("'", "''"))
                      .arg(clientData["paymentFrequency"].toString().replace("'", "''"))
                      .arg(clientData["individualAccount"].toDouble())
                      .arg(clientData["jan"].toDouble())
                      .arg(clientData["feb"].toDouble())
                      .arg(clientData["march"].toDouble())
                      .arg(clientData["apr"].toDouble())
                      .arg(clientData["may"].toDouble())
                      .arg(clientData["jun"].toDouble())
                      .arg(clientData["jul"].toDouble())
                      .arg(clientData["aug"].toDouble())
                      .arg(clientData["sep"].toDouble())
                      .arg(clientData["oct"].toDouble())
                      .arg(clientData["nov"].toDouble())
                      .arg(clientData["dec"].toDouble())
                      .arg(clientData["q1"].toDouble())
                      .arg(clientData["q2"].toDouble())
                      .arg(clientData["q3"].toDouble())
                      .arg(clientData["q4"].toDouble())
                      .arg(searchText.replace("'", "''"));

    QSqlQuery query(m_db);
    if (!query.exec(sql)) {
        qCritical() << "SQL Error:" << query.lastError().text();
        qCritical() << "Executed query:" << sql;
        return false;
    }
    emit clientsUpdated();
    //getClients(m_currentUserId);
    return true;
}

QVariantList DatabaseManager::getClients(int userId)
{
    QVariantList clientsList;

    if (!isConnected()) {
        emit connectionError(tr("Нет подключения к базе данных"));
        return clientsList;
    }

    QSqlQuery query(m_db);
    query.prepare("SELECT * FROM clients WHERE user_id = ?");
    query.addBindValue(userId);

    if (!query.exec()) {
        QString error = query.lastError().text();
        qWarning() << "Failed to fetch clients:" << error;
        emit connectionError(tr("Ошибка получения клиентов: ") + error);
        return clientsList;
    }

    while (query.next()) {
        QVariantMap clientData;
        QSqlRecord record = query.record();

        for (int i = 0; i < record.count(); ++i) {
            clientData[record.fieldName(i)] = record.value(i);
        }

        clientsList.append(clientData);
    }
    //qDebug() << "Clients list:" << clientsList;
    return clientsList;
}

QVariantList DatabaseManager::filterClients(QVariantList clientsList,QString fil1, QString fil2)
{
    QVariantList filterClientsList;
    if(clientsList.length()==0 || (fil1.length()==0 && fil2.length()==0)) return clientsList;
    int a = 0;
    if(fil2 == "Оплачено") {
        a = 1;
       // qDebug()<<true;
    }
    if(fil2.length() == 0) a = -1;
    for (const QVariant client : clientsList) {
        QVariantMap clientMap = client.toMap();
        QString taxSystem = clientMap["tax_system"].toString();
        int payment_type = clientMap["individualaccount"].toInt();
        //qDebug()<<taxSystem<<" "<<fil1<<" "<<a;
        if(fil1.length()!=0 && fil2.length()!=0){
            if(fil1 == taxSystem && ((a==1 && payment_type>=a) || (a==0 && payment_type<=a))){

                filterClientsList.append(client);
            }
        }
        else{
            if(fil1 == taxSystem || (a==1 && payment_type>=a) || (a==0 && payment_type<=a)){

                filterClientsList.append(client);
            }
        }

        //qDebug() << "Client:" << payment_type << "Tax system:" << taxSystem;
    }
    //clientsFilterd();
   // qDebug()<<filterClientsList;
     return filterClientsList;
}

// QString DatabaseManager::getSaveFileName(const QString &defaultName)
// {
//     QString path = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
//     if (!defaultName.isEmpty()) {
//         path += "/" + defaultName;
//     }

//     return QFileDialog::getSaveFileName(nullptr,
//                                         "Сохранить CSV",
//                                         path,
//                                         "CSV Files (*.csv)");
// }

int DatabaseManager::currentUserId() const
{
    return m_currentUserId;
}

bool DatabaseManager::isConnected() const
{
    return m_db.isOpen() && m_db.isValid();
}

bool DatabaseManager::isAuthenticated() const
{
    return m_currentUserId != -1;
}

void DatabaseManager::reconnect()
{
    if (!isConnected()) {
        initializeDatabase();
    }
}
