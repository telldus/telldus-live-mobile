PROJECT( TelldusLiveMobile )

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(PACKAGE_MAJOR_VERSION 1)
SET(PACKAGE_MINOR_VERSION 0)
SET(PACKAGE_PATCH_VERSION 2)

SET(USE_QMAKE TRUE)

IF(COMMAND CMAKE_POLICY)
	CMAKE_POLICY(SET CMP0003 NEW)
ENDIF(COMMAND CMAKE_POLICY)

SET(PRODUCT_NAME TelldusCenter-light )

SET( SOURCES
	src/abstractview.cpp
	src/commonview.cpp
	src/main.cpp
	src/tellduslive.cpp
	src/tlistmodel.cpp
	src/device.cpp
	src/sensor.cpp
	src/schedulerjob.cpp
	src/tellduscenter.cpp
	src/devicemodel.cpp
	src/sensormodel.cpp
	src/favoritemodel.cpp
	src/filtereddevicemodel.cpp
	src/schedulermodel.cpp
	src/abstractfiltereddevicemodel.cpp
	src/groupdevicemodel.cpp
	src/client.cpp
	src/clientmodel.cpp
	src/swipearea.cpp
	src/user.cpp
)

SET( HEADERS
	${CMAKE_CURRENT_BINARY_DIR}/parsed/config.h
	src/config.h.in
)
SET( MOC_HEADERS
	src/abstractview.h
	src/commonview.h
	src/tellduslive.h
	src/tlistmodel.h
	src/device.h
	src/sensor.h
	src/schedulerjob.h
	src/tellduscenter.h
	src/devicemodel.h
	src/sensormodel.h
	src/favoritemodel.h
	src/filtereddevicemodel.h
	src/schedulermodel.h
	src/abstractfiltereddevicemodel.h
	src/groupdevicemodel.h
	src/client.h
	src/clientmodel.h
	src/swipearea.h
	src/user.h
)

SET(RESOURCES
)

SET(QT_USE_QTNETWORK TRUE)
SET(QT_USE_QTDECLARATIVE TRUE)
SET(QT_USE_QTOPENGL TRUE)
SET(QT_USE_QTSCRIPT TRUE)
SET(QT_USE_QTSVG TRUE)

SET(TARGET_PLATFORM "" CACHE STRING "Sets the target platform. Valid values are 'iOS', 'Android', 'Desktop', or 'BB10'")
SET(TELLDUS_LIVE_PUBLIC_KEY	""	CACHE STRING "Telldus Live! public key")
SET(TELLDUS_LIVE_PRIVATE_KEY	""	CACHE STRING "Telldus Live! private key")
OPTION(RELEASE_BUILD "Is this a release build?" TRUE)
IF(RELEASE_BUILD)
	SET(IS_RELEASE_BUILD 1)
ELSE()
	SET(IS_RELEASE_BUILD 0)
ENDIF()
SET(HAVE_WEBKIT 0)

FILE(GLOB_RECURSE QML RELATIVE ${CMAKE_SOURCE_DIR} *.qml)

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/src )
INCLUDE_DIRECTORIES( qmlapplicationviewer )
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_BINARY_DIR}/parsed )

INCLUDE( 3rdparty/kqoauth.cmake NO_POLICY_SCOPE )
INCLUDE( 3rdparty/qjson.cmake NO_POLICY_SCOPE )

IF (NOT TARGET_PLATFORM)
	MESSAGE(FATAL_ERROR "Please set the target platform with -DTARGET_PLATFORM='platform'")
ELSE ()
	STRING(TOUPPER ${TARGET_PLATFORM} UPLATFORM)
	ADD_DEFINITIONS( -DPLATFORM_${UPLATFORM} )
	INCLUDE_DIRECTORIES( Platforms/${TARGET_PLATFORM} )
	INCLUDE( Platforms/${TARGET_PLATFORM}/rules.cmake NO_POLICY_SCOPE )
	IF (COMMAND CONFIGURE)
		CONFIGURE()
	ENDIF(COMMAND CONFIGURE)
ENDIF()

CONFIGURE_FILE(
	src/config.h.in
	${CMAKE_CURRENT_BINARY_DIR}/parsed/config.h
)

IF (USE_QMAKE)
	FIND_PACKAGE( Qt4 REQUIRED )
	INCLUDE( ${QT_USE_FILE} )
	LIST(APPEND LIBRARIES ${QT_LIBRARIES})
	QT4_WRAP_CPP( MOC_SOURCES  ${MOC_HEADERS} )
	QT4_AUTOMOC ( ${MOC_SOURCES} )
	QT4_ADD_RESOURCES (RSRCS src/resources.qrc )
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
		${RSRCS}
	)
ELSE ()
	ADD_EXECUTABLE(TelldusLiveMobile MACOSX_BUNDLE
		${SOURCES}
		${HEADERS}
		${MOC_SOURCES}
		${RESOURCES}
		${RSRCS}
	)
ENDIF ()

IF (COMMAND COMPILE)
	COMPILE(TelldusLiveMobile)
ENDIF(COMMAND COMPILE)

TARGET_LINK_LIBRARIES( TelldusLiveMobile ${LIBRARIES} )
