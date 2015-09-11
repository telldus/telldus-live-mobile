#ifndef TLISTMODEL_H
#define TLISTMODEL_H

#include <QAbstractListModel>

class TListModel : public QAbstractListModel
{
	Q_OBJECT
	Q_PROPERTY(int length READ rowCount)
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit TListModel(const QByteArray &role = "", QObject *parent = 0);
	~TListModel();

	virtual QHash<int, QByteArray> roleNames() const;
	virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
	virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
	void append(QObject *v);
	void append(const QList<QObject *> &objects);

	void clear();

	Q_INVOKABLE QVariant get(int row) const;
	Q_INVOKABLE void splice(int row, int count);

signals:
	void countChanged();
	void childItemChanged();

private:
	class PrivateData;
	PrivateData *d;

};

#endif // TLISTMODEL_H
