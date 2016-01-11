#ifndef LOGGER_H
#define LOGGER_H

#include <QObject>

class Logger : public QObject
{
	Q_OBJECT

public:
	virtual ~Logger();
	static Logger *instance();
	qint64 getElapsedTime();

private:
	explicit Logger(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
	static void errorHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg);

};

#endif // LOGGER_H