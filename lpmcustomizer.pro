# Add more folders to ship with the application, here
#folder_01.source = qml/lpmcustomizer
#folder_01.target = qml
#DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
#QML_IMPORT_PATH =

#symbian:TARGET.UID3 = 0xE0EDAF8C

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
#symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=
CONFIG += declarative qdeclarative-boostable
CONFIG += qtsparql
CONFIG += release
LIBS += -lgq-gconf
DEFINES += QT_NO_DEBUG_OUTPUT

QMAKE_RESOURCE_FLAGS += -threshold 30 -compress 9

# Add dependency to symbian components
# CONFIG += qtquickcomponents

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    platformintegration.cpp \
    galleryitem.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

HEADERS += \
    platformintegration.h \
    galleryitem.h

OTHER_FILES += \
    qml/lpmcustomizer/main.qml \
    qml/lpmcustomizer/MainPage.qml \
    qml/lpmcustomizer/GalleryPicker.qml \


contains(MEEGO_EDITION,harmattan) {
    desktopfile.files = $${TARGET}.desktop
    desktopfile.path = /usr/share/applications

    splash.files = lpmc-splash.png
    splash.path = /opt/lpmcustomizer

    img.files = no-logo.png
    img.path = /opt/lpmcustomizer

    INSTALLS += desktopfile splash img
}

RESOURCES += \
    resource.qrc




contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/lpmcustomizer/bin
    INSTALLS += target
}
