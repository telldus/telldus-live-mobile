SET(QT_SOURCE_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")
OPTION(BUILD_FOR_DEVICE "Whatever to build for device or simulator" TRUE)
IF (BUILD_FOR_DEVICE)
	SET(QT_DIR "${QT_SOURCE_DIR}/../qt-lighthouse-ios-device")
ELSE()
	SET(QT_DIR "${QT_SOURCE_DIR}/../qt-lighthouse-ios-simulator")
ENDIF()
SET(USE_QMAKE TRUE)

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/Platforms/iOS/Info.plist ${CMAKE_BINARY_DIR}/Info.plist)
SET(TESTFLIGHT_TOKEN	""	CACHE STRING "TestFlight token")

SET(CMAKE_OSX_SYSROOT "iphoneos")
SET(CMAKE_OSX_ARCHITECTURES i386 armv7)
SET(CMAKE_CXX_FLAGS "-x objective-c++")
SET(APP_TYPE MACOSX_BUNDLE)
SET(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "4.3")
SET(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1")
SET(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" CACHE STRING "The code signing identity")
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtOpenGL )

SET(QT_USE_QTOPENGL FALSE)

LIST(APPEND SOURCES
	Platforms/iOS/tellduscenter.mm
	Platforms/iOS/view.mm
)

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
	${QT_DIR}/lib/libssl.a
	${QT_DIR}/lib/libcrypto.a
	${CMAKE_SOURCE_DIR}/Platforms/iOS/libTestFlight.a
)

LIST(APPEND RESOURCES
	icons/icon-flat-57.png
	icons/icon-flat-72.png
	icons/icon-flat-114.png
	icons/icon-flat-144.png
	Platforms/iOS/LaunchImage.png
	Platforms/iOS/LaunchImage@2x.png
	Platforms/iOS/LaunchImage-568h@2x.png
)

SET_SOURCE_FILES_PROPERTIES(${RESOURCES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

FUNCTION(COMPILE target)
	SET_TARGET_PROPERTIES(${target} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_BINARY_DIR}/Info.plist)
	SET_TARGET_PROPERTIES(${target} PROPERTIES XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)")
ENDFUNCTION(COMPILE)
