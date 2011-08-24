# Add more folders to ship with the application, here
folder_01.source = qml
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xEE098B2B

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

TARGET=tellduscenterlight

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
	tellduslive.cpp \
	tlistmodel.cpp \
	device.cpp \
	sensor.cpp \
	schedulerjob.cpp \
	tellduscenter.cpp \
	devicemodel.cpp \
	sensormodel.cpp \
	favoritemodel.cpp \
	filtereddevicemodel.cpp \
	schedulermodel.cpp \
	abstractfiltereddevicemodel.cpp \
	groupdevicemodel.cpp \
	client.cpp \
	clientmodel.cpp

# Please do not modify the following two lines. Required for deployment.
include(../qmlapplicationviewer/qmlapplicationviewer.pri)
include(../qt-json/qt-json.pri)
include(../../kqoauth/kqoauth.pri)
qtcAddDeployment()

CONFIG += debug_and_release debug
CONFIG -= release
QT += network script

OTHER_FILES += \
	qtc_packaging/debian_fremantle/rules \
	qtc_packaging/debian_fremantle/README \
	qtc_packaging/debian_fremantle/copyright \
	qtc_packaging/debian_fremantle/control \
	qtc_packaging/debian_fremantle/compat \
	qtc_packaging/debian_fremantle/changelog \
	../android/src/eu/licentia/necessitas/mobile/QtFeedback.java \
	../android/src/eu/licentia/necessitas/mobile/QtAndroidContacts.java \
	../android/src/eu/licentia/necessitas/mobile/QtMediaPlayer.java \
	../android/src/eu/licentia/necessitas/mobile/QtLocation.java \
	../android/src/eu/licentia/necessitas/mobile/QtSystemInfo.java \
	../android/src/eu/licentia/necessitas/mobile/QtCamera.java \
	../android/src/eu/licentia/necessitas/mobile/QtSensors.java \
	../android/src/eu/licentia/necessitas/ministro/IMinistroCallback.aidl \
	../android/src/eu/licentia/necessitas/ministro/IMinistro.aidl \
	../android/src/eu/licentia/necessitas/industrius/QtActivity.java \
	../android/src/eu/licentia/necessitas/industrius/QtApplication.java \
	../android/src/eu/licentia/necessitas/industrius/QtSurface.java \
	../android/src/eu/licentia/necessitas/industrius/QtLayout.java \
	../android/src/eu/licentia/necessitas/industrius/ImageGallery.java \
	../android/res/drawable-hdpi/icon.png \
	../android/res/values/strings.xml \
	../android/res/values/libs.xml \
	../android/res/drawable-ldpi/icon.png \
	../android/res/drawable-mdpi/icon.png \
	../android/AndroidManifest.xml \
	qml/tellduscenterlight/ContentDevice.js

HEADERS += \
	tellduslive.h \
	tlistmodel.h \
	device.h \
	sensor.h \
	schedulerjob.h \
	tellduscenter.h \
	devicemodel.h \
	sensormodel.h \
	favoritemodel.h \
	filtereddevicemodel.h \
	schedulermodel.h \
	abstractfiltereddevicemodel.h \
	groupdevicemodel.h \
	client.h \
	clientmodel.h

RESOURCES += \
	resources.qrc

LIBS += \
	-ltelldusandroid -L../libtelldusandroid

INCLUDEPATH += \
	../libtelldusandroid
