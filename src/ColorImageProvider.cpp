#include "ColorImageProvider.h"
#include <QDebug>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QFile>
#include <QPainter>
#include <QSvgRenderer>

ColorImageProvider::ColorImageProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap) {
}

QPixmap ColorImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
	QString iconName;
	QString iconColor;

	QRegularExpression re("^(?<iconName>\\w+)/#(?<iconColor>\\w+)$");
	QRegularExpressionMatch match = re.match(id);

	if (match.hasMatch()) {
		iconName = match.captured("iconName");
		iconColor = "#" + match.captured("iconColor").replace(QString("#"), QString(""));
	}

	int width = 128;
	int height = 128;

	if (size) {
		*size = QSize(width, height);
	}
	QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width, requestedSize.height() > 0 ? requestedSize.height() : height);
	pixmap.fill(Qt::transparent);
	QPainter painter(&pixmap);
	painter.setRenderHint(QPainter::Antialiasing, true);

	QFile file(":/resources/svgts/" + iconName + ".svgt");
	if (file.exists()) {
		if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
			QTextStream textStream(&file);
			QString svgData(textStream.readAll().replace(QString("{color}"), iconColor));
			QSvgRenderer svg(svgData.toLatin1());
			svg.render(&painter);
			return pixmap;
		}
	}

	iconColor = "990000";
	QPen pen(Qt::red, 0);
	painter.setPen(pen);
	QBrush brush(Qt::green);
	painter.setBrush(brush);
	painter.drawEllipse(0, 0, pixmap.size().width(), pixmap.size().height());
	return pixmap;
}