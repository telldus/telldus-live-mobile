#include "Logger.h"

#include <QRegExp>
#include <QDateTime>
#include <QCoreApplication>
#include <QElapsedTimer>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonDocument>

class Logger::PrivateData {
public:
	static Logger *instance;
	QElapsedTimer timer;
};

Logger *Logger::PrivateData::instance = 0;

Logger * Logger::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new Logger();
	}
	return PrivateData::instance;
}

qint64 Logger::getElapsedTime() {
	return d->timer.elapsed();
}

Logger::Logger(QObject *parent):QObject(parent) {
	d = new PrivateData;
	d->timer.start();
	qInstallMessageHandler(Logger::errorHandler);
}

Logger::~Logger() {
	delete d;
}

void Logger::errorHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
#if RELEASE_BUILD
	QJsonObject logData;
	QString logSection = "MISC";
	QString logDataDirection;
	QString logMessage;

	QByteArray localMsg = msg.toLocal8Bit();

	if (localMsg.startsWith("QSslSocket")) {
		return;
	}

	QStringList args = QCoreApplication::arguments();
	QString logFilter;
	QByteArray localLogFilter = logFilter.toLocal8Bit();
	for(int i = 1; i < args.length(); ++i) {
		if (args.at(i) == "--log-filter") {
			logFilter = args.at(i+1);
			++i;
			continue;
		}
	}

	logMessage = localMsg.constData();

	QRegExp logRegExp("\\[([^\\[]+)\\] (.*)");
	if(logRegExp.indexIn(localMsg) > -1) {
		logSection = logRegExp.cap(1);
		logMessage = logRegExp.cap(2);
		QRegExp logDataDirectionRegExp("\\[([^\\[]+)\\] (<<|>>) (.*)");
		if(logDataDirectionRegExp.indexIn(localMsg) > -1) {
			logDataDirection = (logDataDirectionRegExp.cap(2) == "<<" ? "received" : "sent");
			logMessage = logDataDirectionRegExp.cap(3);
		}
	}

	if (logFilter == logSection || logFilter == "") {
#ifdef PLATFORM_DESKTOP
		switch (type) {
#if QT_VERSION >= 0x050500
			case QtInfoMsg:
				logData.insert("level", QJsonValue(30));
#endif
			case QtDebugMsg:
				logData.insert("level", QJsonValue(20));
				break;
			case QtWarningMsg:
				logData.insert("level", QJsonValue(40));
				break;
			case QtCriticalMsg:
				logData.insert("level", QJsonValue(50));
				break;
			case QtFatalMsg:
				logData.insert("level", QJsonValue(60));
		}
		logData.insert("time", QJsonValue(QDateTime::currentDateTimeUtc().toString(Qt::ISODate)));
		logData.insert("msg", QJsonValue(logMessage));
		logData.insert("section", QJsonValue(logSection));
		logData.insert("elapsed_time", QJsonValue(Logger::instance()->getElapsedTime()));
		if(logDataDirection != "") {
			logData.insert("dataDirection", QJsonValue(logDataDirection));
		}

		fprintf(stdout, "%s\n", QJsonDocument(logData).toJson(QJsonDocument::Compact).constData());
		fflush(stdout);
#else
		switch (type) {
#if QT_VERSION >= 0x050500
			case QtInfoMsg:
#endif
			case QtDebugMsg:
				fprintf(stderr, "%.3f [DBG] %s:%d\n - %s\n", Logger::instance()->getElapsedTime(), context.file, context.line, localMsg.constData());
				break;
			case QtWarningMsg:
				fprintf(stderr, "%.3f [WRN] %s:%d\n - %s\n", Logger::instance()->getElapsedTime(), context.file, context.line, localMsg.constData());
				break;
			case QtCriticalMsg:
				fprintf(stderr, "%.3f [CRT] %s:%d\n - %s\n", Logger::instance()->getElapsedTime(), context.file, context.line, localMsg.constData());
				break;
			case QtFatalMsg:
				fprintf(stderr, "%.3f [FTL] %s:%d\n - %s\n", Logger::instance()->getElapsedTime(), context.file, context.line, localMsg.constData());
				abort();
		}
#endif
	}
#endif // if RELEASE_BUILD
}