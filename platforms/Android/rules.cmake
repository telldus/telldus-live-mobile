SET(HAVE_WEBKIT 1)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

IF(RELEASE_BUILD)
	SET(SUFFIX "")
ELSE()
	SET(SUFFIX ".dev")
ENDIF()

IF(ENABLE_FEATURE_PUSH)
	LIST(APPEND SOURCES
		platforms/Android/Notification.cpp
		platforms/Android/Push.cpp
	)
	LIST(APPEND MOC_HEADERS
		platforms/Android/Notification.h
		platforms/Android/Push.h
	)
ENDIF()

IF (${UI_TYPE} MATCHES "Mobile")
	LIST(APPEND LIBRARIES
		${OPENSSL_DIR}/lib/libssl.so
		${OPENSSL_DIR}/lib/libcrypto.so
	)
	SET(ANDROID_TOOLCHAIN_PREFIX ${ANDROID_TOOLCHAIN_MACHINE_NAME})
ELSE()
	LIST(APPEND LIBRARIES
		${OPENSSL_DIR}/lib/libssl.a
		${OPENSSL_DIR}/lib/libcrypto.a
	)
	SET(ANDROID_TOOLCHAIN_PREFIX ${ANDROID_NDK_ABI_NAME})
ENDIF()

SET(QT_DIR "" CACHE DIR "Path to Qt5")
FIND_PACKAGE( Qt5AndroidExtras REQUIRED )
LIST(APPEND LIBRARIES Qt5::AndroidExtras)

SET(OPENSSL_DIR "/path/to/openssl/lib/and/include" CACHE STRING "Path to the openssl for android dir")

SET(Keystore "" CACHE PATH "Path to Android keystore file")
SET(GCM_SERVER_ID "" CACHE STRING "CGM Server ID for Push")

MATH(EXPR INTERNAL_VERSION "${PACKAGE_MAJOR_VERSION}*10000+${PACKAGE_MINOR_VERSION}*100+${PACKAGE_PATCH_VERSION}")
CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/Android/AndroidManifest.xml ${CMAKE_BINARY_DIR}/template/AndroidManifest.xml)
CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/Android/deployment-settings.json ${CMAKE_BINARY_DIR}/deployment-settings.json)

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/Android/src/com/telldus/live/mobile/MyGcmListenerService.java ${CMAKE_BINARY_DIR}/apk/src/com/telldus/live/mobile/MyGcmListenerService.java)
CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/platforms/Android/src/com/telldus/live/mobile/RegistrationIntentService.java ${CMAKE_BINARY_DIR}/apk/src/com/telldus/live/mobile/RegistrationIntentService.java)

INCLUDE_DIRECTORIES( ${OPENSSL_DIR}/include )

SET(ANDROID_FILES
	../../src/icons/icon-36${SUFFIX}.png
	../../src/icons/icon-48${SUFFIX}.png
	../../src/icons/icon-72${SUFFIX}.png
	../../src/icons/icon-96${SUFFIX}.png
	../../src/icons/icon-144${SUFFIX}.png
	../../src/icons/icon-192${SUFFIX}.png
	logo.png
	splash.xml
)
SET_SOURCE_FILES_PROPERTIES(
	logo.png
	PROPERTIES TARGET_PATH res/drawable
)
SET_SOURCE_FILES_PROPERTIES(
	../../src/icons/icon-36${SUFFIX}.png
	PROPERTIES TARGET_PATH res/drawable-ldpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../src/icons/icon-48${SUFFIX}.png
	PROPERTIES TARGET_PATH res/drawable-mdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../src/icons/icon-72${SUFFIX}.png
	PROPERTIES TARGET_PATH res/drawable-hdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../src/icons/icon-96${SUFFIX}.png
	PROPERTIES TARGET_PATH res/drawable-xhdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../src/icons/icon-144${SUFFIX}.png
	PROPERTIES TARGET_PATH res/drawable-xxhdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../src/icons/icon-192${SUFFIX}.png
	PROPERTIES TARGET_PATH res/drawable-xxxhdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../src/icons/icon-36${SUFFIX}.png
	../../src/icons/icon-48${SUFFIX}.png
	../../src/icons/icon-72${SUFFIX}.png
	../../src/icons/icon-96${SUFFIX}.png
	../../src/icons/icon-144${SUFFIX}.png
	../../src/icons/icon-192${SUFFIX}.png
	PROPERTIES TARGET_NAME icon.png
)
SET_SOURCE_FILES_PROPERTIES(
	splash.xml
	PROPERTIES TARGET_PATH res/layout
)

SET( LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/apk/libs/${ANDROID_NDK_ABI_NAME}" CACHE PATH "path for android libs" FORCE )

FOREACH(file ${ANDROID_FILES})
	GET_FILENAME_COMPONENT(filename ${file} NAME)
	GET_SOURCE_FILE_PROPERTY(path ${file} TARGET_PATH)
	GET_SOURCE_FILE_PROPERTY(name ${file} TARGET_NAME)
	IF (${name} STREQUAL "NOTFOUND")
		SET(name ${filename})
	ENDIF()
	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_BINARY_DIR}/apk/${path}/${name}
		COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/platforms/Android/${file} ${CMAKE_BINARY_DIR}/apk/${path}/${name}
		MAIN_DEPENDENCY ${CMAKE_SOURCE_DIR}/platforms/Android/${file}
		COMMENT "Copying ${file}"
	)
	LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/apk/${path}/${name})
ENDFOREACH()

SET(JAVA_SOURCES
	src/com/telldus/live/mobile/MainActivity.java
	src/com/telldus/live/mobile/MyInstanceIDListenerService.java
	src/com/telldus/live/mobile/QuickstartPreferences.java
	libs/android-support-v4.jar
	libs/google-play-services.jar
	libs/android-support-v7-appcompat.jar
	res/values/common_strings.xml
	res/values/version.xml
)

FOREACH(filename ${JAVA_SOURCES})
	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_BINARY_DIR}/apk/${filename}
		COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/platforms/Android/${filename} ${CMAKE_BINARY_DIR}/apk/${filename}
		MAIN_DEPENDENCY ${CMAKE_SOURCE_DIR}/platforms/Android/${filename}
		COMMENT "Copying ${filename}"
	)
	LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/apk/${filename})
ENDFOREACH()

LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/apk/src/com/telldus/live/mobile/MyGcmListenerService.java)
LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/apk/src/com/telldus/live/mobile/RegistrationIntentService.java)

ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/parsed/qrc_resources.cxx
	COMMAND ${QT_DIR}/bin/rcc
	ARGS -name resources -o ${CMAKE_CURRENT_BINARY_DIR}/parsed/qrc_resources.cxx ${CMAKE_SOURCE_DIR}/src/resources.qrc
	DEPENDS ${CMAKE_SOURCE_DIR}/src/resources.qrc
)

FUNCTION(COMPILE target)
	ADD_CUSTOM_COMMAND(
		TARGET ${target}
		POST_BUILD
		COMMAND ${QT_DIR}/bin/androiddeployqt --android-platform android-19 --input ${CMAKE_BINARY_DIR}/deployment-settings.json --output ${CMAKE_BINARY_DIR}/apk
	)
	ADD_CUSTOM_TARGET(run
		${QT_DIR}/bin/androiddeployqt --android-platform android-19 --no-build --verbose --reinstall --input ${CMAKE_BINARY_DIR}/deployment-settings.json --output ${CMAKE_BINARY_DIR}/apk &&
		adb shell am start -n com.telldus.live.mobile${SUFFIX}/com.telldus.live.mobile.MainActivity
		DEPENDS ${target}
		COMMENT "Package and deploy apk"
	)
	ADD_CUSTOM_TARGET(release
		cd ${CMAKE_BINARY_DIR}/apk/ && ant release &&
		jarsigner -verbose -tsa http://timestamp.digicert.com -sigalg SHA1withRSA -digestalg SHA1 -keystore ${Keystore} ${CMAKE_BINARY_DIR}/apk/bin/QtApp-release-unsigned.apk telldus &&
		zipalign -v 4 ${CMAKE_BINARY_DIR}/apk/bin/QtApp-release-unsigned.apk ${CMAKE_BINARY_DIR}/apk/bin/${target}-${PACKAGE_MAJOR_VERSION}.${PACKAGE_MINOR_VERSION}.${PACKAGE_PATCH_VERSION}-release-signed-aligned.apk
		DEPENDS ${target}
		COMMENT "Package and deploy apk"
	)
	ADD_CUSTOM_TARGET(release-unsigned
		cd ${CMAKE_BINARY_DIR}/apk/ && ant release
		DEPENDS ${target}
		COMMENT "Package and deploy apk"
	)
ENDFUNCTION()
