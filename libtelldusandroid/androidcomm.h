#ifndef ANDROIDCOMM_H
#define ANDROIDCOMM_H

#include <QObject>
#include <android/log.h>
#include <jni.h>

class AndroidComm: public QObject
{
	Q_OBJECT

public:
	~AndroidComm();

	static AndroidComm *instance();

	void setupVM(JavaVM *vm);

	void pickedImage(const QString &imgurl);
	Q_INVOKABLE void pickImage();

signals:
	void imagePicked(const QString &imgurl);

public slots:


private slots:


private:
	explicit AndroidComm(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
};

#endif // ANDROIDCOMM_H
