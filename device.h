#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>

class Device : public QObject
{
	Q_OBJECT
	Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
	Q_PROPERTY(bool isFavorite READ isFavorite WRITE setIsFavorite NOTIFY isFavoriteChanged)
	Q_PROPERTY(int methods READ methods WRITE setMethods NOTIFY methodsChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(bool online READ online NOTIFY onlineChanged)
	Q_PROPERTY(int state READ state WRITE setState NOTIFY stateChanged)
	Q_PROPERTY(QString stateValue READ stateValue WRITE setStateValue NOTIFY stateValueChanged)
public:
	explicit Device(QObject *parent = 0);
	~Device();

	int id() const;
	void setId(int id);

	bool isFavorite() const;
	void setIsFavorite(bool isFavorite);

	int methods() const;
	void setMethods(int methods);

	QString name() const;
	void setName(const QString &name);

	bool online() const;
	void setOnline(bool online);

	int state() const;
	void setState(int state);

	QString stateValue() const;
	void setStateValue(const QString &stateValue);

signals:
	void idChanged();
	void isFavoriteChanged();
	void methodsChanged();
	void nameChanged();
	void onlineChanged();
	void stateChanged();
	void stateValueChanged();

public slots:
	void turnOff();
	void turnOn();

protected:
	void sendMethod(int action, const QString &value = "");

protected slots:
	void onActionResponse(const QVariantMap &result, const QVariantMap &data);

private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(Device*)

#endif // DEVICE_H
