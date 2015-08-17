#ifndef COLORIMAGEPROVIDER_H
#define COLORIMAGEPROVIDER_H

#include <QSize>
#include <QColor>
#include <QQuickImageProvider>
#include <QPixmap>

class ColorImageProvider : public QQuickImageProvider
{
public:
	ColorImageProvider();
	QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

signals:

private slots:

private:
};

#endif // COLORIMAGEPROVIDER_H
