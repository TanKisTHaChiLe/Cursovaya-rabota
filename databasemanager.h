#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantMap>
#include <QSqlError>
#include <QProcess>
#include <QThread>
#include <QSettings>
class DatabaseManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionChanged)
    Q_PROPERTY(int currentUserId READ currentUserId NOTIFY currentUserIdChanged)
    Q_PROPERTY(bool isAuthenticated READ isAuthenticated NOTIFY authenticationChanged)

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    // Основные методы
    Q_INVOKABLE bool initializeDatabase();
    bool isConnected() const;
    bool isAuthenticated() const;
    int currentUserId() const;

    // Методы пользователей
    Q_INVOKABLE bool registerUser(const QString &username, const QString &password);
    Q_INVOKABLE bool authenticateUser(const QString &username, const QString &password);
    Q_INVOKABLE void logoutUser();

    // Методы клиентов
    // Q_INVOKABLE bool addClient(int userId, const QVariantMap &clientData);
    Q_INVOKABLE QVariantList getClients(int userId);
    Q_INVOKABLE bool saveClient(const QVariantMap &clientData);

signals:
    void connectionChanged(bool connected);
    void currentUserIdChanged();
    void authenticationChanged();
    void loginSuccess();
    void loginFailed(const QString &error);
    void logoutSuccess();
    void connectionError(const QString &errorMessage);
    void clientSaved(bool success);  // Новый сигнал
    void clientsUpdated();

public slots:
    void forceLogout();
    void reconnect();
    void shutdownPostgresServer(); // Новый метод

private:
    QSqlDatabase m_db;
    int m_currentUserId = -1;
    bool m_wasServerStartedByApp = false; // Флаг, указывающий, что сервер был запущен приложением

    // Вспомогательные методы
    bool isServerAvailable();
    bool startPostgresService();
    bool startPostgresProcess();
    bool startPostgresProcessManually();
    QString hashPassword(const QString &password);
    void cleanupConnection();
    bool verifyDatabaseConfiguration();

#ifdef Q_OS_WINDOWS
    QString getPostgresServiceName() const;
    QString getPostgresInstallPath() const;
#endif
};

#endif // DATABASEMANAGER_H
