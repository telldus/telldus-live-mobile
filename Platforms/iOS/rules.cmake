SET(HAVE_WEBKIT 1)
SET(QT_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")
SET(OPENSSL_DIR "/path/to/openssl/lib/and/include" CACHE STRING "Path to the openssl for iPhone dir")

OPTION(BUILD_FOR_DEVICE "Whatever to build for device or simulator" TRUE)

IF(RELEASE_BUILD)
	SET(SUFFIX "")
ELSE()
	SET(SUFFIX "-dev")
ENDIF()

SET(USE_QMAKE FALSE)

SET(Qt5Core_DIR ${QT_DIR}/lib/cmake/Qt5Core)
FIND_PACKAGE( Qt5Core REQUIRED )
SET(CMAKE_AUTOMOC ON)
QT5_ADD_RESOURCES(QTRESOURCES src/resources.qrc)
QT5_ADD_RESOURCES(QTRESOURCES src/resources/modules/modules.qrc)

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/iOS/Info.plist ${CMAKE_BINARY_DIR}/Info.plist)

SET(CMAKE_CXX_FLAGS "-x objective-c++")
SET(CMAKE_EXE_LINKER_FLAGS "-all_load")
SET(APP_TYPE MACOSX_BUNDLE)
SET(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "6.0" CACHE STRING "The iPhoneOS Deployment Target")
SET(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2")
SET(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" CACHE STRING "The code signing identity")
SET(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
SET(CMAKE_XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN "YES")
SET(CMAKE_XCODE_ATTRIBUTE_GCC_INLINES_ARE_PRIVATE_EXTERN "YES")
SET(CMAKE_XCODE_ATTRIBUTE_ENABLE_TESTABILITY "YES")
SET(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")
SET(CMAKE_XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon")
SET(CMAKE_XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME "LaunchImage")

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR} )
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/models )
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/utils )
INCLUDE_DIRECTORIES( ${QT_DIR}/include )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtCore )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtGui )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtGui/5.5.1 )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtNetwork )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtQuick )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtQml )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtSql )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtSvg )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtWidgets )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtWebView )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtWebSockets )
INCLUDE_DIRECTORIES( ${OPENSSL_DIR}/include )
INCLUDE_DIRECTORIES( 3rdparty/googleanalytics )
INCLUDE_DIRECTORIES( platforms/iOS/src )

SET(QT_USE_QTOPENGL FALSE)

LIST(APPEND SOURCES
	platforms/iOS/src/QtAppDelegate.mm
	platforms/iOS/src/ObjectiveUtils.mm
	platforms/iOS/src/Dev.mm
	platforms/iOS/src/CommonView.mm
)
IF(ENABLE_FEATURE_PUSH)
	LIST(APPEND SOURCES
		platforms/iOS/src/Notification.cpp
		platforms/iOS/src/Push.cpp
		platforms/iOS/src/Push.mm
	)
ENDIF()

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
	"-framework AssetsLibrary"
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
	${QT_DIR}/qml/QtQuick/Window.2/libwindowplugin.a
	${OPENSSL_DIR}/lib/libcrypto.a
	${OPENSSL_DIR}/lib/libssl.a
	${QT_DIR}/plugins/imageformats/libqsvg.a
	${QT_DIR}/plugins/platforms/libqios.a
	${QT_DIR}/plugins/sqldrivers/libqsqlite.a
	${QT_DIR}/plugins/qmltooling/libqmldbg_tcp.a
	${QT_DIR}/lib/libqtharfbuzzng.a
	${QT_DIR}/lib/libqtpcre.a
	libz.dylib
	libiconv.dylib
	libstdc++.6.dylib
	${CMAKE_SOURCE_DIR}/platforms/iOS/libGoogleAnalyticsServices.a
)

LIST(APPEND RESOURCES
	src/icons/Assets${SUFFIX}.xcassets
	platforms/iOS/LaunchImage.png
	platforms/iOS/LaunchImage@2x.png
	platforms/iOS/LaunchImage-568h@2x.png
)

SET_SOURCE_FILES_PROPERTIES(${RESOURCES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

FUNCTION(COMPILE target)
	SET_PROPERTY(TARGET ${target} PROPERTY MACOSX_BUNDLE_INFO_PLIST ${CMAKE_BINARY_DIR}/Info.plist)
	SET_PROPERTY(TARGET ${target} PROPERTY XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)")
	SET_PROPERTY(TARGET ${target} PROPERTY XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon")
	SET_PROPERTY(TARGET ${target} PROPERTY XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME "LaunchImage")
	SET_PROPERTY(TARGET ${target} PROPERTY XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.telldus.live.mobile${SUFFIX}")
	SET_PROPERTY(TARGET ${target} PROPERTY XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN "YES")
	SET_PROPERTY(TARGET ${target} PROPERTY XCODE_ATTRIBUTE_GCC_INLINES_ARE_PRIVATE_EXTERN "YES")
ENDFUNCTION(COMPILE)
