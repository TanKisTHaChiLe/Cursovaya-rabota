// #ifndef CLIENTMODEL_H
// #define CLIENTMODEL_H

// #include <QAbstractListModel>
// #include <QObject>

// class ClientModel : public QAbstractListModel
// {
//     Q_OBJECT
// public:
//     enum ClientRoles {
//         IdRole = Qt::UserRole + 1,
//         FullNameRole,
//         CompanyRole,
//         PhoneRole,
//         InnRole,
//         ActivityTypeRole,
//         PaymentStatusRole
//     };

//     explicit ClientModel(QObject *parent = nullptr);

//     int rowCount(const QModelIndex &parent = QModelIndex()) const override;
//     QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
//     QHash<int, QByteArray> roleNames() const override;

//     Q_INVOKABLE void refresh();
//     Q_INVOKABLE void addClient(const QVariantMap &clientData);
//     Q_INVOKABLE QVariantMap getClient(int index) const;

//     Q_INVOKABLE QStringList getFilters(int clientId) const;

// private:
//     QVector<QVariantMap> m_clients;
// };

// #endif // CLIENTMODEL_H
