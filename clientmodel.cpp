// #include "ClientModel.h"
// #include "DatabaseManager.h"
// #include <QDebug>

// ClientModel::ClientModel(QObject *parent) : QAbstractListModel(parent)
// {
//     refresh();
// }

// int ClientModel::rowCount(const QModelIndex &parent) const
// {
//     Q_UNUSED(parent)
//     return m_clients.count();
// }

// QVariant ClientModel::data(const QModelIndex &index, int role) const
// {
//     if (!index.isValid() || index.row() >= m_clients.count())
//         return QVariant();

//     const QVariantMap &client = m_clients.at(index.row());

//     switch (role) {
//     case IdRole:
//         return client["id"];
//     case FullNameRole:
//         return client["full_name"];
//     case CompanyRole:
//         return client["activity_type"];
//     case PhoneRole:
//         return client["phone"];
//     case InnRole:
//         return client["inn"];
//     case ActivityTypeRole:
//         return client["activity_type"];
//     case PaymentStatusRole:
//         return client["payment_type"];
//     default:
//         return QVariant();
//     }
// }

// QHash<int, QByteArray> ClientModel::roleNames() const
// {
//     QHash<int, QByteArray> roles;
//     roles[IdRole] = "clientId";
//     roles[FullNameRole] = "fullName";
//     roles[CompanyRole] = "company";
//     roles[PhoneRole] = "phone";
//     roles[InnRole] = "inn";
//     roles[ActivityTypeRole] = "activityType";
//     roles[PaymentStatusRole] = "paymentStatus";
//     return roles;
// }

// void ClientModel::refresh()
// {
//     beginResetModel();

//     m_clients.clear();
//     DatabaseManager* dbManager = DatabaseManager::instance();
//     if (dbManager && dbManager->isAuthenticated()) {
//         QVariantList clients = dbManager->getClients(dbManager->currentUserId());
//         for (const QVariant &clientVariant : clients) {
//             m_clients.append(clientVariant.toMap());
//         }
//     }

//     endResetModel();
// }

// QStringList ClientModel::getFilters(int clientId) const
// {
//     if (clientId >= 0 && clientId < m_clients.count()) {
//         return m_clients.at(clientId)["filters"].toStringList();
//     }
//     return QStringList();
// }

// void ClientModel::addClient(const QVariantMap &clientData)
// {
//     beginInsertRows(QModelIndex(), m_clients.count(), m_clients.count());
//     m_clients.append(clientData);
//     endInsertRows();
// }

// QVariantMap ClientModel::getClient(int index) const
// {
//     if (index >= 0 && index < m_clients.count()) {
//         return m_clients.at(index);
//     }
//     return QVariantMap();
// }
