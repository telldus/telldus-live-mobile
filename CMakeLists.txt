PROJECT( TelldusLiveMobile )

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.11)

SET(PACKAGE_MAJOR_VERSION 1)
SET(PACKAGE_MINOR_VERSION 0)
SET(PACKAGE_PATCH_VERSION 7)
OPTION(RELEASE_BUILD "Is this a release build?" TRUE)

# Feature options
OPTION(ENABLE_FEATURE_WEBSOCKETS "Should websocket support be built in?" FALSE)

OPTION(ENABLE_FEATURE_LOGGING "Should console logging be enabled? (automatically disabled in release builds)" FALSE)
IF(ENABLE_FEATURE_LOGGING)
	OPTION(ENABLE_FEATURE_GOOGLEANALYTICS "Should logging send to google analytics?" FALSE)
	IF(ENABLE_FEATURE_GOOGLEANALYTICS)
		SET(GOOGLE_ANALYTICS_TRACKER	""	CACHE STRING "Google Analytics tracker")
	ENDIF()
ENDIF()

# Environment settings
SET(TARGET_PLATFORM "" CACHE STRING "Sets the target platform. Valid values are 'iOS', 'Android', 'Desktop', or 'BB10'")
SET(TELLDUS_LIVE_API_ENDPOINT	"https://api.telldus.com"	CACHE STRING "Telldus Live! api endpoint")
SET(TELLDUS_LIVE_PUBLIC_KEY	""	CACHE STRING "Telldus Live! public key")
SET(TELLDUS_LIVE_PRIVATE_KEY	""	CACHE STRING "Telldus Live! private key")

IF(RELEASE_BUILD)
	SET(IS_RELEASE_BUILD 1)
ELSE()
	SET(IS_RELEASE_BUILD 0)
ENDIF()

IF(ENABLE_FEATURE_WEBSOCKETS)
	SET(IS_FEATURE_WEBSOCKETS_ENABLED 1)
ELSE()
	SET(IS_FEATURE_WEBSOCKETS_ENABLED 0)
ENDIF()

IF(ENABLE_FEATURE_LOGGING)
	SET(IS_FEATURE_LOGGING_ENABLED 1)
ELSE()
	SET(IS_FEATURE_LOGGING_ENABLED 0)
ENDIF()

IF(ENABLE_FEATURE_GOOGLEANALYTICS)
	SET(IS_FEATURE_GOOGLEANALYTICS_ENABLED 1)
ELSE()
	SET(IS_FEATURE_GOOGLEANALYTICS_ENABLED 0)
ENDIF()

IF((NOT IS_FEATURE_LOGGING_ENABLED) OR IS_RELEASE_BUILD)
	ADD_DEFINITIONS(-DQT_NO_DEBUG_OUTPUT)
ENDIF()

SET(USE_QMAKE TRUE)

IF(COMMAND CMAKE_POLICY)
	CMAKE_POLICY(SET CMP0003 NEW)
ENDIF(COMMAND CMAKE_POLICY)

SET(PRODUCT_NAME TelldusCenter-light )

SET( SOURCES
	src/abstractview.cpp
	src/client.cpp
	src/commonview.cpp
	src/device.cpp
	src/main.cpp
	src/schedulerjob.cpp
	src/sensor.cpp
	src/swipearea.cpp
	src/tellduscenter.cpp
	src/tellduslive.cpp
	src/user.cpp
	src/models/abstractfiltereddevicemodel.cpp
	src/models/clientmodel.cpp
	src/models/devicemodel.cpp
	src/models/favoritemodel.cpp
	src/models/filtereddevicemodel.cpp
	src/models/groupdevicemodel.cpp
	src/models/schedulermodel.cpp
	src/models/sensormodel.cpp
	src/models/tlistmodel.cpp
	src/utils/dev.cpp
)

SET( HEADERS
	${CMAKE_CURRENT_BINARY_DIR}/parsed/config.h
	src/config.h.in
)
SET( MOC_HEADERS
	src/abstractview.h
	src/client.h
	src/commonview.h
	src/device.h
	src/schedulerjob.h
	src/sensor.h
	src/swipearea.h
	src/tellduscenter.h
	src/tellduslive.h
	src/user.h
	src/models/abstractfiltereddevicemodel.h
	src/models/clientmodel.h
	src/models/devicemodel.h
	src/models/favoritemodel.h
	src/models/filtereddevicemodel.h
	src/models/groupdevicemodel.h
	src/models/schedulermodel.h
	src/models/sensormodel.h
	src/models/tlistmodel.h
	src/utils/dev.h
)

SET(RESOURCES
)

SET(QT_USE_QTNETWORK TRUE)
SET(QT_USE_QTDECLARATIVE TRUE)
SET(QT_USE_QTOPENGL TRUE)
SET(QT_USE_QTSCRIPT TRUE)
SET(QT_USE_QTSVG TRUE)
SET(QT_USE_QTWEBSOCKETS TRUE)

SET(HAVE_WEBKIT 0)

FILE(GLOB_RECURSE QML RELATIVE ${CMAKE_SOURCE_DIR} *.qml)

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/src )
INCLUDE_DIRECTORIES( qmlapplicationviewer )
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_BINARY_DIR}/parsed )

INCLUDE( 3rdparty/kqoauth.cmake NO_POLICY_SCOPE )

IF (NOT TARGET_PLATFORM)
	MESSAGE(FATAL_ERROR "Please set the target platform with -DTARGET_PLATFORM='platform'")
ELSE ()
	STRING(TOUPPER ${TARGET_PLATFORM} UPLATFORM)
	ADD_DEFINITIONS( -DPLATFORM_${UPLATFORM} )
	INCLUDE_DIRECTORIES( platforms/${TARGET_PLATFORM} )
	INCLUDE( platforms/${TARGET_PLATFORM}/rules.cmake NO_POLICY_SCOPE )
	IF (COMMAND CONFIGURE)
		CONFIGURE()
	ENDIF(COMMAND CONFIGURE)
ENDIF()

CONFIGURE_FILE(
	src/config.h.in
	${CMAKE_CURRENT_BINARY_DIR}/parsed/config.h
)

IF (USE_QMAKE)
	FIND_PACKAGE( Qt5Core REQUIRED )
	FIND_PACKAGE( Qt5Network REQUIRED )
	FIND_PACKAGE( Qt5Quick REQUIRED )
	FIND_PACKAGE( Qt5Svg REQUIRED )
	FIND_PACKAGE( Qt5WebSockets REQUIRED )
	LIST(APPEND LIBRARIES Qt5::Network Qt5::Quick Qt5::Svg Qt5::WebSockets)
	IF(HAVE_WEBKIT)
		FIND_PACKAGE( Qt5WebView REQUIRED )
		LIST(APPEND LIBRARIES Qt5::WebView)
	ENDIF()
	SET(CMAKE_INCLUDE_CURRENT_DIR ON)
	SET(CMAKE_AUTOMOC ON)
	QT5_ADD_RESOURCES(QTRESOURCES src/resources.qrc)
ENDIF()

FOREACH(F ${QML})
	LIST(APPEND RESOURCES ${F})
ENDFOREACH()

IF (${TARGET_PLATFORM} MATCHES "Android")
	ADD_LIBRARY(TelldusLiveMobile SHARED
		${SOURCES}
		${HEADERS}
		${MOC_SOURCES}
		${RESOURCES}
		${QTRESOURCES}
		${RSRCS}
	)
ELSE ()
	ADD_EXECUTABLE(TelldusLiveMobile MACOSX_BUNDLE
		${SOURCES}
		${HEADERS}
		${MOC_SOURCES}
		${RESOURCES}
		${QTRESOURCES}
		${RSRCS}
	)
ENDIF ()

IF (COMMAND COMPILE)
	COMPILE(TelldusLiveMobile)
ENDIF(COMMAND COMPILE)

TARGET_LINK_LIBRARIES( TelldusLiveMobile ${LIBRARIES} )
