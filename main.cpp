#include <QtGui/QApplication>
//#include "qmlapplicationviewer.h"
#include <QtDeclarative>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QDeclarativeView>

#include "platformintegration.h"
#include "imagegenerator.h"
#include "imagesaver.h"

#include "galleryitem.h"

#include <applauncherd/MDeclarativeCache>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    qDebug() << "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.";
    QApplication *app = MDeclarativeCache::qApplication(argc, argv);
    app->setOrganizationName("frals");
    app->setOrganizationDomain("frals.se");
    app->setApplicationName("lpmcustomizer");

    QFont font = QFont("Nokia Pure Text Light");
    app->setFont(font);

    QDeclarativeView *view = MDeclarativeCache::qDeclarativeView();
    QDeclarativeContext *ctx = view->rootContext();

    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view->setInputMethodHints(Qt::ImhNoPredictiveText);

    qmlRegisterType<GalleryItem>("LPM", 1, 0, "GalleryItem");
    //qmlRegisterUncreatableType<GalleryModel>("LPM", 1, 0, "GalleryModel", "You can't create this!");

    PlatformIntegration *p = new PlatformIntegration(ctx);
    ImageGenerator *ig = new ImageGenerator();
    ImageSaver *is = new ImageSaver(ig);

    QObject::connect(is, SIGNAL(imageSaved(QString)), p, SLOT(onImageSaved(QString)));

    view->engine()->addImageProvider(QString("logocreator"), ig);

    ctx->setContextProperty("platform", p);
    ctx->setContextProperty("imageSaver", is);

    p->updateGallery();

    QObject::connect(view->engine(), SIGNAL(quit()), app, SLOT(quit()));

//    QString pathInInstallDir = QCoreApplication::applicationDirPath()
//            + QLatin1String("/../") + "qml/lpmcustomizer";

    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();

//    QmlApplicationViewer viewer;
//    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
//    viewer.setMainQmlFile(QLatin1String("qml/LPMCustomizer/main.qml"));
//    viewer.showExpanded();

    return app->exec();
}
