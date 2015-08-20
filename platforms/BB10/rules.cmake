IF(RELEASE_BUILD)
	SET(SUFFIX "")
ELSE()
	SET(SUFFIX ".dev")
ENDIF()

SET(BB10_FILES ${CMAKE_BINARY_DIR}/bar-descriptor.xml)

LIST(APPEND SOURCES
	platforms/BB10/Push.cpp
)
LIST(APPEND MOC_HEADERS
	platforms/BB10/Push.h
)

LIST(APPEND LIBRARIES -lcpp -lcrypto -lssl -lbps -lpush_service -lbtapi)

SET(QNX_TARGET $ENV{QNX_TARGET} CACHE PATH "Path to QNX_TARGET")
SET(QNX_HOST $ENV{QNX_HOST} CACHE PATH "Path to QNX_HOST")
SET(DEBUG_TOKEN "" CACHE FILEPATH "Path to the debug token to sign with")
SET(DEVICE_PASSWORD "" CACHE FILEPATH "Password to the device")
SET(DEVICE_IP "169.254.0.1" CACHE STRING "IP address to the device")
SET(SIGNING_PASSWORD "" CACHE FILEPATH "Password for the signing keys")
IF(ENABLE_FEATURE_PUSH)
	SET(PUSH_APPID "" CACHE STRING "The application id for push notifications")
	SET(PUSH_PPGURL "" CACHE STRING "The PPG url for push notifications")
ENDIF()
INCLUDE_DIRECTORIES( "${QNX_TARGET}/usr/include" )

FOREACH(file ${FILES})
	GET_FILENAME_COMPONENT(filename ${file} NAME)
	GET_SOURCE_FILE_PROPERTY(path ${file} TARGET_PATH)
	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_BINARY_DIR}/${path}/${filename}
		COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/platforms/BB10/${file} ${CMAKE_BINARY_DIR}/${path}/${filename}
		MAIN_DEPENDENCY ${CMAKE_SOURCE_DIR}/platforms/BB10/${file}
		COMMENT "Copying ${file}"
	)
	LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/${path}/${filename})
	LIST(APPEND BB10_FILES ${CMAKE_BINARY_DIR}/${path}/${filename})
ENDFOREACH()

FUNCTION(PREPARE_TARGET target)
	GET_TARGET_PROPERTY(Qt5Core_LIB Qt5::Core LOCATION)
	GET_FILENAME_COMPONENT(Qt5Core_DIR ${Qt5Core_LIB} DIRECTORY)
	GET_FILENAME_COMPONENT(Qt5Path ${Qt5Core_DIR} DIRECTORY)
	CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/BB10/bar-descriptor.xml ${CMAKE_BINARY_DIR}/bar-descriptor.xml)
ENDFUNCTION()

FUNCTION(COMPILE target)
	SET(BARFILE "${target}-${PACKAGE_MAJOR_VERSION}.${PACKAGE_MINOR_VERSION}.${PACKAGE_PATCH_VERSION}${SUFFIX}.bar")
	IF(RELEASE_BUILD)
		ADD_CUSTOM_TARGET(bar
			COMMAND ${QNX_HOST}/usr/bin/blackberry-nativepackager -package ${BARFILE} ${DEBUG_TOKEN} bar-descriptor.xml
			COMMAND ${QNX_HOST}/usr/bin/blackberry-signer -storepass ${SIGNING_PASSWORD} ${target}-release.bar
			DEPENDS ${target}
			COMMENT "Package and sign ${BARFILE} file"
		)
	ELSE()
		ADD_CUSTOM_TARGET(bar
			COMMAND ${QNX_HOST}/usr/bin/blackberry-nativepackager -package ${BARFILE} -devMode -debugToken ${DEBUG_TOKEN} bar-descriptor.xml
			DEPENDS ${target}
			COMMENT "Package ${BARFILE} file"
		)
	ENDIF()
	ADD_CUSTOM_TARGET(run
		COMMAND ${QNX_HOST}/usr/bin/blackberry-deploy -package ${BARFILE} -installApp -launchApp -device ${DEVICE_IP} -password ${DEVICE_PASSWORD}
		DEPENDS bar
		COMMENT "Deploy and run ${BARFILE} file"
	)
ENDFUNCTION()
