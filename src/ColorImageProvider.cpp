#include "ColorImageProvider.h"
#include <QDebug>
#include <QRegularExpression>
#include <QRegularExpressionMatch>

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
		iconColor = match.captured("iconColor");
	}

	int width = 320;
	int height = 320;

	QPixmap pixmap(width, height);
	pixmap.loadFromData("<?xml version=\"1.0\" encoding=\"utf-8\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"><svg version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\" width=\"320px\" height=\"320px\" viewBox=\"0 0 320 320\" enable-background=\"new 0 0 320 320\" xml:space=\"preserve\"><polygon fill=\"#" + iconColor.toLatin1() + "\" points=\"160,12.587 198.057,123.181 315,125.2 221.578,195.57 255.796,307.413 160,240.309 64.204,307.413 98.422,195.57 5,125.2 121.942,123.181 \"/></svg>");
	return pixmap;
}