SET(HAVE_WEBKIT 1)
SET(QT_SOURCE_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")
SET(OPENSSL_DIR "/path/to/openssl/lib/and/include" CACHE STRING "Path to the openssl for iPhone dir")

OPTION(BUILD_FOR_DEVICE "Whatever to build for device or simulator" TRUE)

IF(RELEASE_BUILD)
	SET(SUFFIX "")
ELSE()
	SET(SUFFIX "-dev")
ENDIF()

IF (BUILD_FOR_DEVICE)
	SET(QT_DIR "${QT_SOURCE_DIR}/ios")
ELSE()
	SET(QT_DIR "${QT_SOURCE_DIR}/ios_x86")
ENDIF()
SET(USE_QMAKE FALSE)

FOREACH(h ${MOC_HEADERS})
	GET_FILENAME_COMPONENT(name ${h} NAME_WE)
	ADD_CUSTOM_COMMAND(
		OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/parsed/moc_${name}.cpp"
		DEPENDS ${h}
		COMMAND ${QT_DIR}/bin/moc ${h} > ${CMAKE_CURRENT_BINARY_DIR}/parsed/moc_${name}.cpp
		COMMENT "MOC ${h}"
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	)
	LIST(APPEND MOC_SOURCES ${CMAKE_CURRENT_BINARY_DIR}/parsed/moc_${name}.cpp)
ENDFOREACH()

ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/parsed/qrc_resources.cxx
	COMMAND ${QT_DIR}/bin/rcc
	ARGS -name resources -o ${CMAKE_CURRENT_BINARY_DIR}/parsed/qrc_resources.cxx ${CMAKE_SOURCE_DIR}/src/resources.qrc
	DEPENDS ${CMAKE_SOURCE_DIR}/src/resources.qrc
)

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/iOS/Info.plist ${CMAKE_BINARY_DIR}/Info.plist)

SET(CMAKE_OSX_SYSROOT "iphoneos" CACHE STRING "Path to SDK")
SET(CMAKE_OSX_ARCHITECTURES i386 armv7 arm64)
SET(CMAKE_CXX_FLAGS "-x objective-c++")
SET(CMAKE_EXE_LINKER_FLAGS "-all_load")
SET(APP_TYPE MACOSX_BUNDLE)
SET(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "6.0")
SET(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2")
SET(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" CACHE STRING "The code signing identity")
SET(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
SET(CMAKE_XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN "Yes")
SET(CMAKE_XCODE_ATTRIBUTE_ARCHS "$(ARCHS_STANDARD)")

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR} )
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/models )
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/utils )
INCLUDE_DIRECTORIES( ${QT_DIR}/include )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtCore )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtGui )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtGui/5.4.2 )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtNetwork )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtQuick )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtQml )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtWidgets )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtWebView )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtWebSockets )
INCLUDE_DIRECTORIES( ${OPENSSL_DIR}/include )
INCLUDE_DIRECTORIES( 3rdparty/googleanalytics )


SET(QT_USE_QTOPENGL FALSE)

LIST(APPEND SOURCES
	platforms/iOS/analytics.mm
	platforms/iOS/tellduscenter.mm
	platforms/iOS/commonview.mm
	${CMAKE_CURRENT_BINARY_DIR}/parsed/qrc_resources.cxx
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
	"-framework CoreData"
	"-framework SystemConfiguration"
	"-framework Security"
	${QT_DIR}/lib/libQt5Core.a
	${QT_DIR}/lib/libQt5Gui.a
	${QT_DIR}/lib/libQt5Quick.a
	${QT_DIR}/lib/libQt5Qml.a
	${QT_DIR}/lib/libQt5OpenGL.a
	${QT_DIR}/lib/libQt5PlatformSupport.a
	${QT_DIR}/lib/libQt5Xml.a
	${QT_DIR}/lib/libQt5XmlPatterns.a
	${QT_DIR}/lib/libQt5Network.a
	${QT_DIR}/lib/libQt5Sql.a
	${QT_DIR}/lib/libQt5Svg.a
	${QT_DIR}/lib/libQt5WebView.a
	${QT_DIR}/lib/libQt5Widgets.a
	${QT_DIR}/lib/libQt5WebSockets.a
	${QT_DIR}/qml/QtWebView/libdeclarative_webview.a
	${QT_DIR}/qml/QtQuick.2/libqtquick2plugin.a
	${QT_DIR}/qml/QtQuick/LocalStorage/libqmllocalstorageplugin.a
	${OPENSSL_DIR}/lib/libcrypto.a
	${OPENSSL_DIR}/lib/libssl.a
	${QT_DIR}/plugins/imageformats/libqsvg.a
	${QT_DIR}/plugins/platforms/libqios.a
	${QT_DIR}/plugins/sqldrivers/libqsqlite.a
	${QT_DIR}/plugins/qmltooling/libqmldbg_tcp.a
	${QT_DIR}/lib/libqtharfbuzzng.a
	libz.dylib
	libiconv.dylib
	libstdc++.6.dylib
	${CMAKE_SOURCE_DIR}/platforms/iOS/libGoogleAnalyticsServices.a
)

LIST(APPEND RESOURCES
	src/icons/icon-flat-57${SUFFIX}.png
	src/icons/icon-flat-72${SUFFIX}.png
	src/icons/icon-flat-76${SUFFIX}.png
	src/icons/icon-flat-114${SUFFIX}.png
	src/icons/icon-flat-120${SUFFIX}.png
	src/icons/icon-flat-144${SUFFIX}.png
	src/icons/icon-flat-152${SUFFIX}.png
	platforms/iOS/LaunchImage.png
	platforms/iOS/LaunchImage@2x.png
	platforms/iOS/LaunchImage-568h@2x.png
)

SET_SOURCE_FILES_PROPERTIES(${RESOURCES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

FUNCTION(COMPILE target)
	SET_TARGET_PROPERTIES(${target} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_BINARY_DIR}/Info.plist)
	SET_TARGET_PROPERTIES(${target} PROPERTIES XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)")
	SET_TARGET_PROPERTIES(${target} PROPERTIES XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN "YES")
	SET_TARGET_PROPERTIES(${target} PROPERTIES XCODE_ATTRIBUTE_ARCHS "$(ARCHS_STANDARD)")
ENDFUNCTION(COMPILE)
