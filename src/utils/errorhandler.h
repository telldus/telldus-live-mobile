#ifndef ERRORHANDLER_H
#define ERRORHANDLER_H

void errorHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
	QByteArray localMsg = msg.toLocal8Bit();
	switch (type) {
		case QtDebugMsg:
			fprintf(stderr, "[\033[1;36mDBG\033[0m] \033[1;36m%s\033[0m:\033[1;36m%d\033[0m\n", context.file, context.line);
			fprintf(stderr, "  %s\n", localMsg.constData());
			break;
//		case QtInfoMsg:
//			fprintf(stderr, "[\033[1;36mINF\033[0m] \033[1;36m%s\033[0m:\033[1;36m%d\033[0m\n", context.file, context.line);
//			fprintf(stderr, "[\033[1;36mINF\033[0m] %s\n", localMsg.constData());
//			break;
		case QtWarningMsg:
			fprintf(stderr, "[\033[1;33mDBG\033[0m] \033[1;33m%s\033[0m:\033[1;33m%d\033[0m\n", context.file, context.line);
			fprintf(stderr, "[\033[1;33mWRN\033[0m] %s\n", localMsg.constData());
			break;
		case QtCriticalMsg:
			fprintf(stderr, "[\033[31mDBG\033[0m] \033[31m%s\033[0m:\033[31m%d\033[0m\n", context.file, context.line);
			fprintf(stderr, "[\033[31mCRL\033[0m] %s\n", localMsg.constData());
			break;
		case QtFatalMsg:
			fprintf(stderr, "[\033[31mDBG\033[0m] \033[31m%s\033[0m:\033[31m%d\033[0m\n", context.file, context.line);
			fprintf(stderr, "[\033[31mFTL\033[0m] %s\n", localMsg.constData());
			abort();
	}
}

#endif // ERRORHANDLER_H