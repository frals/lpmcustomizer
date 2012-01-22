#include "imagesaver.h"

#include <QDebug>

#include <QSize>
#include <QImage>

#include "imagegenerator.h"

ImageSaver::ImageSaver(ImageGenerator *ig, QObject *parent) :
    QObject(parent),
    m_ig(ig)
{
}

void ImageSaver::saveImage(const QString& url)
{
    qDebug() << Q_FUNC_INFO;
    qDebug() << "got pixmap:" << url;

    QPixmap px = m_ig->requestPixmap(url, new QSize(), QSize());
    px.save("/home/user/lpmlogo.png");
    emit imageSaved("/home/user/lpmlogo.png");
}
