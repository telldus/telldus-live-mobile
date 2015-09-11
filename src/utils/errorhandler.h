#ifndef ERRORHANDLER_H
#define ERRORHANDLER_H

#include <QRegExp>

void errorHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
	QByteArray localMsg = msg.toLocal8Bit();
	if (QString(context.file).startsWith("qrc:/resources/qml/")) {
		localMsg.prepend("[QML] ");
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

	QRegExp rx(logFilter);
	rx.setPatternSyntax(QRegExp::Wildcard);
	if (rx.indexIn(localMsg) != -1 || logFilter == "") {
		switch (type) {
#if QT_VERSION >= 0x050500
			case QtInfoMsg:
#endif
			case QtDebugMsg:
				fprintf(stderr, "[\033[1;36mDBG\033[0m] \033[1;36m%s\033[0m:\033[1;36m%d\033[0m\n", context.file, context.line);
				fprintf(stderr, "  %s\n", localMsg.constData());
				break;
			case QtWarningMsg:
				fprintf(stderr, "[\033[1;33mWRN\033[0m] \033[1;33m%s\033[0m:\033[1;33m%d\033[0m\n", context.file, context.line);
				fprintf(stderr, "  %s\n", localMsg.constData());
				break;
			case QtCriticalMsg:
				fprintf(stderr, "[\033[31mCRT\033[0m] \033[31m%s\033[0m:\033[31m%d\033[0m\n", context.file, context.line);
				fprintf(stderr, "  %s\n", localMsg.constData());
				break;
			case QtFatalMsg:
				fprintf(stderr, "[\033[31mFTL\033[0m] \033[31m%s\033[0m:\033[31m%d\033[0m\n", context.file, context.line);
				fprintf(stderr, "  %s\n", localMsg.constData());
				abort();
		}
	}
}

#endif // ERRORHANDLER_H