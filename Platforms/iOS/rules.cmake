SET(QT_SOURCE_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")
OPTION(BUILD_FOR_DEVICE "Whatever to build for device or simulator" TRUE)
IF (BUILD_FOR_DEVICE)
	SET(QT_DIR "${QT_SOURCE_DIR}/../qt-lighthouse-ios-device")
ELSE()
	SET(QT_DIR "${QT_SOURCE_DIR}/../qt-lighthouse-ios-simulator")
ENDIF()
SET(USE_QMAKE TRUE)

SET(CMAKE_OSX_SYSROOT "iphoneos")
SET(CMAKE_OSX_ARCHITECTURES i386 armv7)
SET(CMAKE_CXX_FLAGS "-x objective-c++")
SET(APP_TYPE MACOSX_BUNDLE)
SET(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "4.3")
SET(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1")
SET(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" CACHE STRING "The code signing identity")

SET(QT_USE_QTOPENGL FALSE)

LIST(APPEND LIBRARIES
	"-framework Foundation"
	"-framework UIKit"
	"-framework OpenGLES"
	"-framework QuartzCore"
	"-framework CoreGraphics"
	"-framework CoreText"
	"-framework AVFoundation"
	"-framework CoreVideo"
	"-framework CoreMedia"
	${QT_DIR}/lib/libQtOpenGL.a
	${QT_DIR}/plugins/sqldrivers/libqsqlite.a
	${QT_DIR}/plugins/imageformats/libqsvg.a
	${QT_DIR}/plugins/platforms/libquikit.a
	libz.dylib
	libiconv.dylib
)

FUNCTION(COMPILE target)
	SET_TARGET_PROPERTIES(${target} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_SOURCE_DIR}/Platforms/iOS/Info.plist)
	SET_TARGET_PROPERTIES(${target} PROPERTIES XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)")
ENDFUNCTION(COMPILE)
