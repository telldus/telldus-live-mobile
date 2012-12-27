SET(QT_SOURCE_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")
OPTION(BUILD_FOR_DEVICE "Whatever to build for device or simulator" TRUE)
IF (BUILD_FOR_DEVICE)
	SET(QT_DIR "${QT_SOURCE_DIR}/../qt-lighthouse-ios-device")
ELSE()
	SET(QT_DIR "${QT_SOURCE_DIR}/../qt-lighthouse-ios-simulator")
ENDIF()
SET(USE_QMAKE FALSE)

FOREACH(h ${MOC_HEADERS})
	GET_FILENAME_COMPONENT(name ${h} NAME_WE)
	ADD_CUSTOM_COMMAND(
		OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/moc_${name}.cpp"
		#DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${h}
		#COMMAND ${QT_DIR}/bin/moc ${CMAKE_CURRENT_SOURCE_DIR}/${h} > ${CMAKE_CURRENT_BINARY_DIR}/moc_${name}.cpp
		DEPENDS ${h}
		COMMAND ${QT_DIR}/bin/moc ${h} > ${CMAKE_CURRENT_BINARY_DIR}/moc_${name}.cpp
		COMMENT "MOC ${h}"
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	)
	LIST(APPEND MOC_SOURCES ${CMAKE_CURRENT_BINARY_DIR}/moc_${name}.cpp)
ENDFOREACH()

ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/qrc_resources.cxx
	COMMAND ${QT_DIR}/bin/rcc
	ARGS -name resources -o ${CMAKE_CURRENT_BINARY_DIR}/qrc_resources.cxx ${CMAKE_SOURCE_DIR}/src/resources.qrc
	DEPENDS ${RESOURCES}
	#DEPENDS ${_RC_DEPENDS} "${out_depends}" VERBATIM
)
LIST(APPEND SOURCES ${CMAKE_CURRENT_BINARY_DIR}/qrc_resources.cxx)

SET(CMAKE_OSX_SYSROOT "iphoneos")
SET(CMAKE_OSX_ARCHITECTURES i386 armv7)
SET(CMAKE_CXX_FLAGS "-x objective-c++")
SET(APP_TYPE MACOSX_BUNDLE)
SET(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "4.3")
SET(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1")
SET(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" CACHE STRING "The code signing identity")
INCLUDE_DIRECTORIES( ${QT_DIR}/include )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtCore )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtGui )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtNetwork )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtDeclarative )
INCLUDE_DIRECTORIES( ${QT_DIR}/include/QtScript )
INCLUDE_DIRECTORIES( ${QT_SOURCE_DIR}/src/plugins/platforms/uikit )

LIST(APPEND LIBRARIES
	"-framework Foundation"
	"-framework UIKit"
	"-framework OpenGLES"
	"-framework QuartzCore"
	"-framework CoreGraphics"
	"-framework CoreText"
	"-framework AVFoundation"
	"-framework CoreVideo"
	"-framework CoreMedia"
	${QT_DIR}/lib/libQtCore.a
	${QT_DIR}/lib/libQtGui.a
	${QT_DIR}/lib/libQtDeclarative.a
	${QT_DIR}/lib/libQtOpenGL.a
	${QT_DIR}/lib/libQtXml.a
	${QT_DIR}/lib/libQtXmlPatterns.a
	${QT_DIR}/lib/libQtNetwork.a
	${QT_DIR}/lib/libQtScript.a
	${QT_DIR}/lib/libQtSql.a
	${QT_DIR}/lib/libQtSvg.a
	${QT_DIR}/plugins/platforms/libquikit.a
	libz.dylib
	libiconv.dylib
)

FUNCTION(COMPILE target)
	SET_TARGET_PROPERTIES(${target} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_SOURCE_DIR}/Platforms/iOS/Info.plist)
	SET_TARGET_PROPERTIES(${target} PROPERTIES XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)")
ENDFUNCTION(COMPILE)
