#ifndef TLISTMODEL_H
#define TLISTMODEL_H

#include <QAbstractListModel>
#include <QScriptValue>

class TListModel : public QAbstractListModel
{
	Q_OBJECT
	Q_PROPERTY(int length READ rowCount)
public:
	explicit TListModel(const QByteArray &role = "", QObject *parent = 0);
	~TListModel();

	virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
	virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
	void append(QObject *v);
	void append(const QList<QObject *> &objects);

	Q_INVOKABLE QVariant get(int row) const;
	Q_INVOKABLE void splice(int row, int count);

private:
	class PrivateData;
	PrivateData *d;

};

#endif // TLISTMODEL_H
