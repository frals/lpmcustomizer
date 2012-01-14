#include "galleryitem.h"

#include <QDebug>

GalleryItem::GalleryItem(const QString &source, qint32 width, qint32 height,
                     bool portrait, QObject *parent) :
    QObject(parent),
    m_filepath(source),
    m_portrait(portrait)
{
        m_aspectRatio = double(width) / double(height);
        emit dataChanged();
}

bool GalleryItem::operator==(const GalleryItem& other) const
{
    qDebug() << __PRETTY_FUNCTION__ << "this" << this->filepath() << "other" << other.filepath();
    if(this->filepath() == other.filepath())
        return true;
    return false;
}

void GalleryItem::setRoleNames(QHash<int, QByteArray> &roleNames)
{
    roleNames[FilePathRole] = "filepath";
    roleNames[AspectRatioRole] = "aspectRatio";
    roleNames[PortraitRole] = "portrait";
}

QVariant GalleryItem::data(int role) const
{
    switch(role){
    case FilePathRole: return m_filepath;
    case AspectRatioRole: return m_aspectRatio;
    case PortraitRole: return m_portrait;
    default: return QVariant();
    }
}

QString GalleryItem::filepath() const
{
    //qDebug() << __PRETTY_FUNCTION__;
    return m_filepath;
}

double GalleryItem::aspectRatio() const
{
    //qDebug() << __PRETTY_FUNCTION__;
    return m_aspectRatio;
}

bool GalleryItem::portrait() const
{
    qDebug() << __PRETTY_FUNCTION__;
    return m_portrait;
}
