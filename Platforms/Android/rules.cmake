
# Add QtMobility
INCLUDE_DIRECTORIES("${QT_INCLUDE_DIR}/QtMobility")
LIST(APPEND LIBRARIES "-lQtSystemInfo")

SET(ANDROID_FILES
	AndroidManifest.xml
	icon.png
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
	AndroidManifest.xml
	PROPERTIES TARGET_PATH "."
)
SET_SOURCE_FILES_PROPERTIES(
	icon.png logo.png
	PROPERTIES TARGET_PATH res/drawable
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
	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_BINARY_DIR}/apk/${path}/${filename}
		COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/Platforms/Android/${file} ${CMAKE_BINARY_DIR}/apk/${path}/${filename}
		MAIN_DEPENDENCY ${CMAKE_SOURCE_DIR}/Platforms/Android/${file}
		COMMENT "Copying ${file}"
	)
	LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/apk/${path}/${filename})
ENDFOREACH()


FUNCTION(COMPILE target)
	ADD_CUSTOM_COMMAND(
		TARGET ${target}
		POST_BUILD
		COMMAND android update project -p ${CMAKE_BINARY_DIR}/apk -n ${target} -t 10
		COMMAND cd ${CMAKE_BINARY_DIR}/apk/ && ant debug
	)
	ADD_CUSTOM_TARGET(run
		adb install -r ${CMAKE_BINARY_DIR}/apk/bin/TelldusCenter-light-debug.apk &&
		adb shell am start -n com.telldus.livemobile/org.kde.necessitas.origo.QtActivity
		DEPENDS ${target}
		COMMENT "Package and deploy apk"
	)
ENDFUNCTION()
