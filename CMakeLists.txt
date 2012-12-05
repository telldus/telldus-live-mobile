PROJECT( TelldusCenter-light )

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(USE_QMAKE TRUE)

IF(COMMAND CMAKE_POLICY)
	CMAKE_POLICY(SET CMP0003 NEW)
ENDIF(COMMAND CMAKE_POLICY)

SET(PRODUCT_NAME TelldusCenter-light )

SET( SOURCES
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

	qmlapplicationviewer/qmlapplicationviewer.cpp

	qt-json/json.cpp
)

SET( HEADERS
)
SET( MOC_HEADERS
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

	qmlapplicationviewer/qmlapplicationviewer.h
)

SET(RESOURCES
)

SET(TARGET_PLATFORM "" CACHE STRING "Sets the target platform. Valid values are 'iOS', 'Android', 'Desktop', or 'BB10'")

FILE(GLOB_RECURSE QML RELATIVE ${CMAKE_SOURCE_DIR}/qml qml/*)

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR} )
INCLUDE_DIRECTORIES( qt-json )
INCLUDE_DIRECTORIES( qmlapplicationviewer )

INCLUDE( 3rdparty/kqoauth.cmake NO_POLICY_SCOPE )

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

IF (USE_QMAKE)
	FIND_PACKAGE( Qt4 REQUIRED )
	SET(QT_USE_QTNETWORK TRUE)
	SET(QT_USE_QTDECLARATIVE TRUE)
	SET(QT_USE_QTOPENGL TRUE)
	SET(QT_USE_QTSCRIPT TRUE)
	SET(QT_USE_QTSVG TRUE)
	INCLUDE( ${QT_USE_FILE} )
	LIST(APPEND LIBRARIES ${QT_LIBRARIES})
	QT4_WRAP_CPP( MOC_SOURCES  ${MOC_HEADERS} )
	QT4_AUTOMOC ( ${MOC_SOURCES} )
	QT4_ADD_RESOURCES (RSRCS src/resources.qrc )
ENDIF()

FOREACH(F ${QML})
	GET_FILENAME_COMPONENT(D ${F} PATH)
	GET_FILENAME_COMPONENT(N ${F} NAME)
	IF(APPLE AND ${TARGET_PLATFORM} STREQUAL "Desktop") # Don't do this on iOS
		SET_SOURCE_FILES_PROPERTIES(qml/${F} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources/${D}")
	ELSEIF(RESOURCES_PATH)
		ADD_CUSTOM_COMMAND(OUTPUT ${RESOURCES_PATH}/${D}/${N}
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/qml/${F} ${RESOURCES_PATH}/${D}/${N}
			MAIN_DEPENDENCY ${CMAKE_SOURCE_DIR}/qml/${F}
			COMMENT "Copying ${F}"
		)
	ENDIF()
	LIST(APPEND RESOURCES qml/${F})
ENDFOREACH()

IF (${TARGET_PLATFORM} MATCHES "Android")
	ADD_LIBRARY(TelldusCenter-light SHARED
		${SOURCES}
		${HEADERS}
		${MOC_SOURCES}
		${RESOURCES}
		${RSRCS}
	)
ELSE ()
	ADD_EXECUTABLE(TelldusCenter-light MACOSX_BUNDLE
		${SOURCES}
		${HEADERS}
		${MOC_SOURCES}
		${RESOURCES}
		${RSRCS}
	)
ENDIF ()

IF (COMMAND COMPILE)
	COMPILE(TelldusCenter-light)
ENDIF(COMMAND COMPILE)

TARGET_LINK_LIBRARIES( TelldusCenter-light ${LIBRARIES} )
