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
    qDebug() << id;
    QStringList parts = id.split('/');
    // first part is alignment (left, center, right)
    QString alignment = parts.takeAt(0);
    // second part is symbol
    QString symbolSrc = parts.takeAt(0);
    // third part font size
    QString fontSize = parts.takeAt(0);
    // and rest is text
    QString text = parts.join("/");

    QPixmap pixmap(120, 120);
    pixmap.fill(QColor(Qt::black));

    QPainter painter(&pixmap);
    QFont f("Nokia Pure Text", fontSize.toInt());

    Qt::AlignmentFlag align = Qt::AlignLeft;
    if(alignment == "center") {
        align = Qt::AlignHCenter;
    } else if(alignment == "right") {
        align = Qt::AlignRight;
    }

    QFontMetrics fm(f);
    QRect boundingBox = fm.boundingRect(QRect(0, 0, 120, 120), align, text, 0, 0);

    painter.setFont(f);
    painter.setPen(Qt::white);
    painter.drawText(boundingBox, align, text);


    if(symbolSrc != "0") {
        QPixmap symbol(":/img/" + symbolSrc + "_white.png");
        int height = boundingBox.height();
        int start = 0;
        if(alignment == "center")
            start = 60 - ((120 - height) / 2);
        else if(alignment == "right")
            start = 120 - (120 - height);
        QRect target(start, height, 120 - height, 120 - height);
        QRect source(0, 0, 100, 100);
        if(height > 0) {
            painter.drawPixmap(target, symbol, source);
        }
    }


    return pixmap;
}
