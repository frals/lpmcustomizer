#ifndef GALLERYITEM_H
#define GALLERYITEM_H

#include <QObject>
#include <QHash>
#include <QVariant>

class GalleryItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString filepath READ filepath NOTIFY dataChanged)
    Q_PROPERTY(double aspectRatio READ aspectRatio NOTIFY dataChanged)
    Q_PROPERTY(bool portrait READ portrait NOTIFY dataChanged)

public:
    enum AlbumItemRoles {
        FilePathRole = Qt::UserRole + 1,
        AspectRatioRole,
        PortraitRole
    };

    GalleryItem(const QString& source = "", qint32 width = 1, qint32 height = 1,
              bool portrait = false, QObject *parent = 0);

    bool operator==(const GalleryItem& other) const;

    void setRoleNames(QHash<int, QByteArray> &roleNames);

    int compare(const GalleryItem* other) const;
    QVariant data(int role = Qt::DisplayRole) const;

    QString filepath() const;
    double aspectRatio() const;
    bool portrait() const;

signals:
    void dataChanged();

private:
    QString m_filepath;
    double m_aspectRatio;
    bool m_portrait;

};

#endif // GALLERYITEM_H
