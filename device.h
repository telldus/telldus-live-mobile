#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QMetaType>

class Device : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool isFavorite READ isFavorite WRITE setIsFavorite NOTIFY isFavoriteChanged)
	Q_PROPERTY(int methods READ methods WRITE setMethods NOTIFY methodsChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(int state READ state WRITE setState NOTIFY stateChanged)
	Q_PROPERTY(QString stateValue READ stateValue NOTIFY stateValueChanged)
public:
	explicit Device(QObject *parent = 0);
	~Device();

	bool isFavorite() const;
	void setIsFavorite(bool isFavorite);

	int methods() const;
	void setMethods(int methods);

	QString name() const;
	void setName(const QString &name);

	int state() const;
	void setState(int state);

	QString stateValue() const;

signals:
	void isFavoriteChanged();
	void methodsChanged();
	void nameChanged();
	void stateChanged();
	void stateValueChanged();

public slots:

private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(Device*)

#endif // DEVICE_H
