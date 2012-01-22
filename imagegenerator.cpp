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

    QStringList parts = id.split('/');
    // first part is symbol
    QString symbolSrc = parts.takeAt(0);
    // second part font size
    QString fontSize = parts.takeAt(0);
    // and rest is text
    QString text = parts.join("/");

    QPixmap pixmap(120, 120);
    pixmap.fill(QColor(Qt::black));

    QPainter painter(&pixmap);
    QFont f("Nokia Pure Text", fontSize.toInt());
    //QFont f("Arial", fontSize.toInt());

    QFontMetrics fm(f);
    QRect boundingBox = fm.boundingRect(QRect(0, 0, 120, 120), Qt::AlignLeft & Qt::AlignTop, text, 0, 0);

    painter.setFont(f);
    painter.setPen(Qt::white);
    painter.drawText(boundingBox, Qt::AlignLeft, text);


    if(symbolSrc != "0") {
        QPixmap symbol(":/img/" + symbolSrc);
        int height = boundingBox.height();
        QRect target(0, height,  120 - height, 120 - height);
        QRect source(0, 0, 40, 40);
        if(height > 0) {
            painter.drawPixmap(target, symbol, source);
        }
    }


    return pixmap;
}
