#ifndef USER_H
#define USER_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>
#include <QDateTime>

class User : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString firstname READ firstname NOTIFY firstnameChanged)
	Q_PROPERTY(QString lastname READ lastname NOTIFY lastnameChanged)
	Q_PROPERTY(QString email READ email NOTIFY emailChanged)
	Q_PROPERTY(double credits READ credits NOTIFY creditsChanged)
public:
	explicit User(QObject *parent = 0);
	~User();

	QString firstname() const;
	QString lastname() const;
	QString email() const;
	double credits() const;

signals:
	void firstnameChanged();
	void lastnameChanged();
	void emailChanged();
	void creditsChanged();

private slots:
	void fetchData() const;
	void onInfoReceived(const QVariantMap &);

private:
	class PrivateData;
	PrivateData *d;
};

#endif // USER_H
