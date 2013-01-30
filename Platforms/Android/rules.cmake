SET(HAVE_WEBKIT 1)

MATH(EXPR INTERNAL_VERSION "${PACKAGE_MAJOR_VERSION}*10000+${PACKAGE_MINOR_VERSION}*100+${PACKAGE_PATCH_VERSION}")
CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/Platforms/Android/AndroidManifest.xml ${CMAKE_BINARY_DIR}/apk/AndroidManifest.xml)

SET(ANDROID_FILES
	../../icons/icon-36.png
	../../icons/icon-48.png
	../../icons/icon-72.png
	../../icons/icon-96.png
	libs.xml
	logo.png
	IMinistro.aidl
	IMinistroCallback.aidl
	QtActivity.java
	QtApplication.java
	splash.xml
	strings.xml
)

SET_SOURCE_FILES_PROPERTIES(
	logo.png
	PROPERTIES TARGET_PATH res/drawable
)
SET_SOURCE_FILES_PROPERTIES(
	../../icons/icon-36.png
	PROPERTIES TARGET_PATH res/drawable-ldpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../icons/icon-48.png
	PROPERTIES TARGET_PATH res/drawable-mdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../icons/icon-72.png
	PROPERTIES TARGET_PATH res/drawable-hdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../icons/icon-96.png
	PROPERTIES TARGET_PATH res/drawable-xhdpi
)
SET_SOURCE_FILES_PROPERTIES(
	../../icons/icon-36.png
	../../icons/icon-48.png
	../../icons/icon-72.png
	../../icons/icon-96.png
	PROPERTIES TARGET_NAME icon.png
)
SET_SOURCE_FILES_PROPERTIES(
	splash.xml
	PROPERTIES TARGET_PATH res/layout
)
SET_SOURCE_FILES_PROPERTIES(
	libs.xml strings.xml
	PROPERTIES TARGET_PATH res/values
)
SET_SOURCE_FILES_PROPERTIES(
	IMinistro.aidl IMinistroCallback.aidl
	PROPERTIES TARGET_PATH src/org/kde/necessitas/ministro
)
SET_SOURCE_FILES_PROPERTIES(
	QtActivity.java QtApplication.java
	PROPERTIES TARGET_PATH src/org/kde/necessitas/origo
)

SET( LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/apk/libs/${ANDROID_NDK_ABI_NAME}" CACHE PATH "path for android libs" FORCE )
SET( RESOURCES_PATH "${CMAKE_BINARY_DIR}/apk/assets" )

FOREACH(file ${ANDROID_FILES})
	GET_FILENAME_COMPONENT(filename ${file} NAME)
	GET_SOURCE_FILE_PROPERTY(path ${file} TARGET_PATH)
	GET_SOURCE_FILE_PROPERTY(name ${file} TARGET_NAME)
	IF (${name} STREQUAL "NOTFOUND")
		SET(name ${filename})
	ENDIF()
	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_BINARY_DIR}/apk/${path}/${name}
		COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/Platforms/Android/${file} ${CMAKE_BINARY_DIR}/apk/${path}/${name}
		MAIN_DEPENDENCY ${CMAKE_SOURCE_DIR}/Platforms/Android/${file}
		COMMENT "Copying ${file}"
	)
	LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/apk/${path}/${name})
ENDFOREACH()


FUNCTION(COMPILE target)
	ADD_CUSTOM_COMMAND(
		TARGET ${target}
		POST_BUILD
		COMMAND android update project -p ${CMAKE_BINARY_DIR}/apk -n ${target} -t 10
		COMMAND cd ${CMAKE_BINARY_DIR}/apk/ && ant debug
	)
	ADD_CUSTOM_TARGET(run
		adb install -r ${CMAKE_BINARY_DIR}/apk/bin/${target}-debug.apk &&
		adb shell am start -n com.telldus.live.mobile/org.kde.necessitas.origo.QtActivity
		DEPENDS ${target}
		COMMENT "Package and deploy apk"
	)
ENDFUNCTION()
