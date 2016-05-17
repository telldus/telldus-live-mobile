SET(HAVE_WEBKIT 1)
SET(USE_QMAKE FALSE)

OPTION(BUILD_FOR_DEVICE "Whatever to build for device or simulator" TRUE)

IF(RELEASE_BUILD)
	SET(SUFFIX "")
ELSE()
	SET(SUFFIX "-dev")
ENDIF()

FIND_LIBRARY(OPENGLES_LIBRARY OpenGLES)

FIND_LIBRARY(Foundation_Lib Foundation)
FIND_LIBRARY(UIKit_Lib UIKit)
FIND_LIBRARY(OpenGLES_Lib OpenGLES)
FIND_LIBRARY(QuartzCore_Lib QuartzCore)
FIND_LIBRARY(CoreGraphics_Lib CoreGraphics)
FIND_LIBRARY(CoreText_Lib CoreText)
FIND_LIBRARY(AVFoundation_Lib AVFoundation)
FIND_LIBRARY(CoreVideo_Lib CoreVideo)
FIND_LIBRARY(CoreMedia_Lib CoreMedia)
FIND_LIBRARY(CoreData_Lib CoreData)
FIND_LIBRARY(SystemConfiguration_Lib SystemConfiguration)
FIND_LIBRARY(Security_Lib Security)
FIND_LIBRARY(AssetsLibrary_Lib AssetsLibrary)
FIND_LIBRARY(MobileCoreServices_Lib MobileCoreServices)
FIND_LIBRARY(ImageIO_Lib ImageIO)

FIND_PACKAGE( Qt5Core REQUIRED )
SET(CMAKE_AUTOMOC ON)
QT5_ADD_RESOURCES(QTRESOURCES src/resources.qrc)
QT5_ADD_RESOURCES(QTRESOURCES src/resources/modules/modules.qrc)

FIND_PACKAGE( Qt5Network REQUIRED )
FIND_PACKAGE( Qt5Quick REQUIRED )
FIND_PACKAGE( Qt5Sql REQUIRED )
FIND_PACKAGE( Qt5Svg REQUIRED )
FIND_PACKAGE( Qt5WebSockets REQUIRED )
FIND_PACKAGE( Qt5WebView REQUIRED )
LIST(APPEND LIBRARIES Qt5::Core Qt5::Network Qt5::Quick Qt5::Sql Qt5::Svg Qt5::WebSockets Qt5::WebView)
LIST(APPEND LIBRARIES ${Qt5Qml_PLUGINS})
LIST(APPEND LIBRARIES ${Qt5Sql_PLUGINS})
LIST(APPEND LIBRARIES ${Qt5Svg_PLUGINS})

SET(OPENSSL_DIR "/path/to/openssl/lib/and/include" CACHE STRING "Path to the openssl for iPhone dir")
SET(QT_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/iOS/Info.plist ${CMAKE_BINARY_DIR}/Info.plist)

SET(CMAKE_CXX_FLAGS "-x objective-c++")
SET(CMAKE_EXE_LINKER_FLAGS "-u _qt_registerPlatformPlugin -Wl,-e,_qt_main_wrapper -force_load ${QT_DIR}/plugins/platforms/libqios.a")
SET(APP_TYPE MACOSX_BUNDLE)
SET(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "7.0" CACHE STRING "The iPhoneOS Deployment Target")
SET(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2")
SET(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" CACHE STRING "The code signing identity")
SET(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
SET(CMAKE_XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN "YES")
SET(CMAKE_XCODE_ATTRIBUTE_GCC_INLINES_ARE_PRIVATE_EXTERN "YES")
SET(CMAKE_XCODE_ATTRIBUTE_ENABLE_TESTABILITY "YES")
SET(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")
SET(CMAKE_XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon")
SET(CMAKE_XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME "LaunchImage")

INCLUDE_DIRECTORIES( ${OPENSSL_DIR}/include )
INCLUDE_DIRECTORIES( 3rdparty/googleanalytics )
INCLUDE_DIRECTORIES( platforms/iOS/src )


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

LIST(APPEND RESOURCES
	src/icons/Assets${SUFFIX}.xcassets
	platforms/iOS/LaunchImage.png
	platforms/iOS/LaunchImage@2x.png
	platforms/iOS/LaunchImage-568h@2x.png
)
LIST(APPEND LIBRARIES
	${Foundation_Lib}
	${UIKit_Lib}
	${OpenGLES_Lib}
	${QuartzCore_Lib}
	${CoreGraphics_Lib}
	${CoreText_Lib}
	${AVFoundation_Lib}
	${CoreVideo_Lib}
	${CoreMedia_Lib}
	${CoreData_Lib}
	${SystemConfiguration_Lib}
	${Security_Lib}
	${AssetsLibrary_Lib}
	${MobileCoreServices_Lib}
	${ImageIO_Lib}
	${QT_DIR}/plugins/platforms/libqios.a
	${QT_DIR}/qml/QtWebView/libdeclarative_webview.a
	${QT_DIR}/qml/QtQuick.2/libqtquick2plugin.a
	${QT_DIR}/qml/QtQuick/Window.2/libwindowplugin.a
	${QT_DIR}/lib/libQt5PlatformSupport.a
	${QT_DIR}/lib/libqtharfbuzzng.a
	${QT_DIR}/lib/libqtfreetype.a
	${QT_DIR}/lib/libqtpcre.a
	libz.dylib
	libiconv.dylib
	libstdc++.6.dylib
	${CMAKE_SOURCE_DIR}/platforms/iOS/libGoogleAnalyticsServices.a
)
LIST(APPEND LIBRARIES
	${OPENSSL_DIR}/lib/libcrypto.a
	${OPENSSL_DIR}/lib/libssl.a
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
