#include "platformintegration.h"

#include <QDebug>

//Q_DECLARE_METATYPE(QList<QObject*>*);

PlatformIntegration::PlatformIntegration(QDeclarativeContext *ctx, QObject *parent) :
    QObject(parent),
    m_ctx(ctx),
    m_updatingGalleryModel(false),
    m_sparqlConnection(0),
    m_sparqlQuery(0),
    m_sparqlResult(0),
    m_operatorlogo(0),
    m_qsettings(0)
{
    m_qsettings = new QSettings;
    //m_galleryModel = new GalleryModel(new GalleryItem(""), this);
    m_list = new QList<QObject*>();

    m_sparqlConnection = new QSparqlConnection("QTRACKER");
    m_sparqlQuery = new QSparqlQuery("select nie:url(?photo) nfo:width(?photo) nfo:height(?photo) where { ?photo a nmm:Photo . } ");

    m_operatorlogo = new GConfItem("/desktop/meego/screen_lock/low_power_mode/operator_logo");
    connect(m_operatorlogo, SIGNAL(valueChanged()), this, SLOT(operatorLogoChangedSlot()));

    qDebug() << __PRETTY_FUNCTION__ << "Status:" << m_qsettings->fileName();

}

PlatformIntegration::~PlatformIntegration()
{
    qDebug() << __PRETTY_FUNCTION__;
    if(m_sparqlConnection) delete m_sparqlConnection;
    if(m_operatorlogo) delete m_operatorlogo;
    if(m_qsettings) delete m_qsettings;
}

QList<QObject*>* PlatformIntegration::galleryModel() const
{
    qDebug() << __PRETTY_FUNCTION__ << m_list;
    return m_list;
}

bool PlatformIntegration::firstLaunchDone() const
{
    QVariant ret = m_qsettings->value("firstlaunchDone");
    return ret.toBool();
}

void PlatformIntegration::setFirstLaunchDone()
{
    qDebug() << __PRETTY_FUNCTION__;
    m_qsettings->setValue("firstlaunchDone", true);
    m_qsettings->sync();
    qDebug() << __PRETTY_FUNCTION__ << "Status:" << m_qsettings->status();
}

bool PlatformIntegration::updating() const
{
    return m_updatingGalleryModel;
}

void PlatformIntegration::updateGallery()
{
    qDebug() << __PRETTY_FUNCTION__;
    if(m_updatingGalleryModel) return;

    m_updatingGalleryModel = true;
    emit updatingChanged();

//    if(m_sparqlResult) {
//        m_sparqlResult->disconnect();
//        m_sparqlResult->deleteLater();
//    }

    m_sparqlResult = m_sparqlConnection->exec(*m_sparqlQuery);

    bool ok = connect(m_sparqlResult, SIGNAL(finished()), this, SLOT(sparqlFinished()), Qt::UniqueConnection);
    Q_ASSERT(ok); Q_UNUSED(ok);

    emit galleryModelChanged();
}

void PlatformIntegration::sparqlFinished()
{
    qDebug() << __PRETTY_FUNCTION__;
    if(m_sparqlResult) {
        m_list->clear();

        while(m_sparqlResult->next()) {
            QString path = m_sparqlResult->binding(0).value().toString();

            if(path.startsWith("file:")) {
                path = QUrl::fromPercentEncoding(path.toUtf8());
                path = path.right(path.length() - 7);
            }

            if(m_list) {
                m_list->insert(0, new GalleryItem(
                                           path/*,
                                           m_sparqlResult->binding(1).value().toInt(),
                                           m_sparqlResult->binding(2).value().toInt()*/
                                           ));
            }
        }
    }
    addNoLogo();
    m_updatingGalleryModel = false;
    m_ctx->setContextProperty("platformGalleryModel", QVariant::fromValue(*m_list));
    emit updatingChanged();
}

int PlatformIntegration::indexOf(const QString& path)
{
    qDebug() << __PRETTY_FUNCTION__ << path;
    int index = -1;
    if(!m_list) return index;
    if(path == "") return 0;
    QString p = path;
    p = p.remove("file://");
    qDebug() << p;
    for(int i = 0; i < m_list->size(); i++) {
        GalleryItem* item = qobject_cast<GalleryItem*>(m_list->at(i));
        if(item) {
            if(item->filepath() == p) {
                index = i;
                break;
            }
        }
    }
    return index;
}

void PlatformIntegration::addNoLogo()
{
    qDebug() << __PRETTY_FUNCTION__;
    if(m_list /*&& operatorLogo() != ""*/) {
        //if(m_list->at(0)->filepath() != "/opt/lpmcustomizer/no-logo.png") {
            m_list->insert(0, new GalleryItem(
                                       "/opt/lpmcustomizer/no-logo.png"/*,
                                       m_sparqlResult->binding(1).value().toInt(),
                                       m_sparqlResult->binding(2).value().toInt()*/
                                       ));
            //emit galleryModelChanged();
        //}
    }

}

void PlatformIntegration::operatorLogoChangedSlot()
{
    qDebug() << __PRETTY_FUNCTION__ << m_operatorlogo->value();
    emit operatorLogoChanged();
}

void PlatformIntegration::setOperatorLogo(const QString &path)
{
    qDebug() << __PRETTY_FUNCTION__ << path;
    m_operatorlogo->set(path);
}

QString PlatformIntegration::operatorLogo() const
{
    return m_operatorlogo->value().toString();
}

void PlatformIntegration::onImageSaved(const QString &path)
{
    setOperatorLogo("");
    setOperatorLogo(path);
}
