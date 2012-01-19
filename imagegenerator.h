#ifndef IMAGEGENERATOR_H
#define IMAGEGENERATOR_H

#include <QDeclarativeImageProvider>

class ImageGenerator : public QDeclarativeImageProvider
{
public:
    explicit ImageGenerator();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

    
signals:
    
public slots:
    
};

#endif // IMAGEGENERATOR_H
