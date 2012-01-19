#include "imagegenerator.h"

#include <QDebug>
#include <QPixmap>
#include <QFont>
#include <QPainter>

ImageGenerator::ImageGenerator() :
    QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap)
{



}

QPixmap ImageGenerator::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(size); Q_UNUSED(requestedSize);
    QString text = id;
    int i = text.indexOf('/');
    text.remove(0, i+1);

    QString fontSize = id;
    fontSize.truncate(i);


    QPixmap pixmap(120, 120);
    pixmap.fill(QColor(Qt::black));

    QPainter painter(&pixmap);
    painter.setFont(QFont("Nokia Pure Text", fontSize.toInt()));
    painter.setPen(Qt::white);
    painter.drawText(QRectF(0, 0, 120, 120), Qt::AlignLeft, text);

    return pixmap;
}
