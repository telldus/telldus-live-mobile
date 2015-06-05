SET(HAVE_WEBKIT 1)

SET(Qt5_Dir "" CACHE DIR "Path to Qt5")
SET(Qt5Network_DIR ${Qt5_Dir}/lib/cmake/Qt5Network)
SET(Qt5Qml_DIR ${Qt5_Dir}/lib/cmake/Qt5Qml)
SET(Qt5Quick_DIR ${Qt5_Dir}/lib/cmake/Qt5Quick)
SET(Qt5Svg_DIR ${Qt5_Dir}/lib/cmake/Qt5Svg)
SET(Qt5WebSockets_DIR ${Qt5_Dir}/lib/cmake/Qt5WebSockets)
SET(Qt5Widgets_DIR ${Qt5_Dir}/lib/cmake/Qt5Widgets)
SET(Qt5WebView_DIR ${Qt5_Dir}/lib/cmake/Qt5WebView)

SET(Keystore "" CACHE PATH "Path to Android keystore file")

MATH(EXPR INTERNAL_VERSION "${PACKAGE_MAJOR_VERSION}*10000+${PACKAGE_MINOR_VERSION}*100+${PACKAGE_PATCH_VERSION}")
CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/Platforms/Android/AndroidManifest.xml ${CMAKE_BINARY_DIR}/template/AndroidManifest.xml)
CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/Platforms/Android/deployment-settings.json ${CMAKE_BINARY_DIR}/deployment-settings.json)

SET(ANDROID_FILES
	../../icons/icon-36.png
	../../icons/icon-48.png
	../../icons/icon-72.png
	../../icons/icon-96.png
	logo.png
	splash.xml
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

SET( LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/apk/libs/${ANDROID_NDK_ABI_NAME}" CACHE PATH "path for android libs" FORCE )

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

ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/parsed/qrc_resources.cxx
	COMMAND ${QT_DIR}/bin/rcc
	ARGS -name resources -o ${CMAKE_CURRENT_BINARY_DIR}/parsed/qrc_resources.cxx ${CMAKE_SOURCE_DIR}/src/resources.qrc
	DEPENDS ${CMAKE_SOURCE_DIR}/src/resources.qrc
)

FUNCTION(COMPILE target)
	ADD_CUSTOM_COMMAND(
		TARGET ${target}
		POST_BUILD
		COMMAND ${Qt5_Dir}/bin/androiddeployqt --input ${CMAKE_BINARY_DIR}/deployment-settings.json --output ${CMAKE_BINARY_DIR}/apk
	)
	ADD_CUSTOM_TARGET(run
		${Qt5_Dir}/bin/androiddeployqt --no-build --verbose --reinstall --input ${CMAKE_BINARY_DIR}/deployment-settings.json --output ${CMAKE_BINARY_DIR}/apk &&
		adb shell am start -n com.telldus.live.mobile/org.qtproject.qt5.android.bindings.QtActivity
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
ENDFUNCTION()
