#ifndef IMAGESAVER_H
#define IMAGESAVER_H

#include <QObject>
#include <QPixmap>
#include <QImage>

class ImageGenerator;

class ImageSaver : public QObject
{
    Q_OBJECT
public:
    explicit ImageSaver(ImageGenerator* ig, QObject *parent = 0);
    
    Q_INVOKABLE void saveImage(const QString& url);

signals:
    void imageSaved(const QString& path);

public slots:

private:
    ImageGenerator *m_ig;
    
};

#endif // IMAGESAVER_H
