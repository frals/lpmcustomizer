#ifndef PLATFORMINTEGRATION_H
#define PLATFORMINTEGRATION_H

#include <QObject>
#include <QUrl>

#include <QtSparql/QSparqlConnection>
#include <QtSparql/QSparqlResult>
#include <gconfitem.h>
#include <QDeclarativeContext>
#include <QSettings>
#include <QList>

//#include "gallerymodel.h"
#include "galleryitem.h"


class PlatformIntegration : public QObject
{
    Q_OBJECT

    //Q_PROPERTY(GalleryModel* galleryModel READ galleryModel NOTIFY galleryModelChanged)
    Q_PROPERTY(QList<QObject*>* galleryModel READ galleryModel NOTIFY galleryModelChanged)
    Q_PROPERTY(bool updating READ updating NOTIFY updatingChanged)

    Q_PROPERTY(QString currentLogo READ operatorLogo NOTIFY operatorLogoChanged)

    Q_PROPERTY(bool firstLaunchDone READ firstLaunchDone)
public:
    PlatformIntegration(QDeclarativeContext *ctx, QObject *parent = 0);
    ~PlatformIntegration();

    Q_INVOKABLE void updateGallery();
    Q_INVOKABLE void setOperatorLogo(const QString& path);

    Q_INVOKABLE void addNoLogo();

    bool updating() const;
    QString operatorLogo() const;
    bool firstLaunchDone() const;
    Q_INVOKABLE void setFirstLaunchDone();

    Q_INVOKABLE int indexOf(const QString& path);

    QList<QObject*>* galleryModel() const;

signals:
    void galleryModelChanged();
    void operatorLogoChanged();
    void updatingChanged();

public slots:
    void sparqlFinished();
    void onImageSaved(const QString& path);

private slots:
    void operatorLogoChangedSlot();

private:
    QDeclarativeContext *m_ctx;
    //GalleryModel* m_galleryModel;
    QList<QObject*>* m_list;

    bool m_updatingGalleryModel;
    QSparqlConnection* m_sparqlConnection;
    QSparqlQuery* m_sparqlQuery;
    QSparqlResult* m_sparqlResult;
    GConfItem* m_operatorlogo;
    QSettings* m_qsettings;
};

#endif // PLATFORMINTEGRATION_H
