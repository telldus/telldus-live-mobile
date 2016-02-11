PROJECT( TelldusLiveMobile )

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.11)

SET(PACKAGE_MAJOR_VERSION 2)
SET(PACKAGE_MINOR_VERSION 0)
SET(PACKAGE_PATCH_VERSION 3)
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

OPTION(ENABLE_FEATURE_PUSH "Should support for push be built in?" FALSE)

# Environment settings
SET(TARGET_PLATFORM "" CACHE STRING "Sets the target platform. Valid values are 'iOS', 'Android', 'Desktop', or 'BB10'")

SET(UI_TYPES "Mobile;TV")
SET(UI_TYPE "Mobile" CACHE STRING "The type of UI, currently mobile or TV")
SET_PROPERTY(CACHE UI_TYPE PROPERTY STRINGS ${UI_TYPES})

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

IF(ENABLE_FEATURE_PUSH)
	SET(IS_FEATURE_PUSH_ENABLED 1)
	SET(PUSH_SERVICE_ID	""	CACHE STRING "Push Notification Service Id")
ELSE()
	SET(IS_FEATURE_PUSH_ENABLED 0)
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
	src/ColorImageProvider.cpp
	src/device.cpp
	src/main.cpp
	src/schedulerjob.cpp
	src/sensor.cpp
	src/tellduscenter.cpp
	src/tellduslive.cpp
	src/user.cpp
	src/models/abstractfiltereddevicemodel.cpp
	src/models/clientmodel.cpp
	src/models/dashboardmodel.cpp
	src/models/devicemodel.cpp
	src/models/DeviceListSortFilterModel.cpp
	src/models/favoritedevicemodel.cpp
	src/models/favoritesensormodel.cpp
	src/models/filtereddevicemodel.cpp
	src/models/groupdevicemodel.cpp
	src/models/SchedulerDayModel.cpp
	src/models/SchedulerDaySortFilterModel.cpp
	src/models/schedulermodel.cpp
	src/models/sensormodel.cpp
	src/models/SensorListSortFilterModel.cpp
	src/models/tlistmodel.cpp
	src/objects/DashboardItem.cpp
	src/objects/SchedulerJobInstance.cpp
	src/utils/dev.cpp
	src/utils/Logger.cpp
	src/properties/Properties.cpp
	src/properties/PropertiesTheme.cpp
	src/properties/PropertiesThemeColors.cpp
	src/properties/PropertiesThemeCore.cpp
	src/properties/PropertiesUi.cpp
)

IF(ENABLE_FEATURE_PUSH)
	SET( SOURCES
		src/AbstractNotification.cpp
		src/AbstractPush.cpp
	)
	SET( MOC_HEADERS
		src/AbstractNotification.h
		src/AbstractPush.h
	)
ENDIF()

SET( HEADERS
	${CMAKE_CURRENT_BINARY_DIR}/parsed/config.h
	src/config.h.in
)
SET( MOC_HEADERS
	src/abstractview.h
	src/client.h
	src/commonview.h
	src/ColorImageProvider.h
	src/device.h
	src/schedulerjob.h
	src/sensor.h
	src/TdQueue.h
	src/tellduscenter.h
	src/tellduslive.h
	src/user.h
	src/models/abstractfiltereddevicemodel.h
	src/models/clientmodel.h
	src/models/dashboardmodel.h
	src/models/devicemodel.h
	src/models/DeviceListSortFilterModel.h
	src/models/favoritedevicemodel.h
	src/models/favoritesensormodel.h
	src/models/filtereddevicemodel.h
	src/models/groupdevicemodel.h
	src/models/SchedulerDayModel.h
	src/models/SchedulerDaySortFilterModel.h
	src/models/schedulermodel.h
	src/models/sensormodel.h
	src/models/SensorListSortFilterModel.h
	src/models/tlistmodel.h
	src/objects/DashboardItem.h
	src/objects/SchedulerJobInstance.h
	src/utils/dev.h
	src/utils/Logger.h
	src/properties/Properties.h
	src/properties/PropertiesTheme.h
	src/properties/PropertiesThemeColors.h
	src/properties/PropertiesThemeCore.h
	src/properties/PropertiesUi.h
)

SET(RESOURCES
)
SET(COPY_RESOURCES
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
	FIND_PACKAGE( Qt5Sql REQUIRED )
	FIND_PACKAGE( Qt5Svg REQUIRED )
	FIND_PACKAGE( Qt5WebSockets REQUIRED )
	LIST(APPEND LIBRARIES Qt5::Network Qt5::Quick Qt5::Sql Qt5::Svg Qt5::WebSockets)
	IF(HAVE_WEBKIT)
		FIND_PACKAGE( Qt5WebView REQUIRED )
		LIST(APPEND LIBRARIES Qt5::WebView)
	ENDIF()
	SET(CMAKE_INCLUDE_CURRENT_DIR ON)
	SET(CMAKE_AUTOMOC ON)
	QT5_ADD_RESOURCES(QTRESOURCES src/resources.qrc)
	QT5_ADD_RESOURCES(QTRESOURCES src/resources/modules/modules.qrc)
ENDIF()

FOREACH(F ${QML})
	LIST(APPEND RESOURCES ${F})
ENDFOREACH()

IF (COMMAND PREPARE_TARGET)
	PREPARE_TARGET(TelldusLiveMobile)
ENDIF()

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
