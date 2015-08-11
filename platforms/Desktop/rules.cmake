#SET(HAVE_WEBKIT 1)

SET(QT_SOURCE_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")
SET(OPENSSL_DIR "/path/to/openssl/lib/and/include" CACHE STRING "Path to the openssl for iPhone dir")

SET(Qt5Core_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5Core)
SET(Qt5Network_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5Network)
SET(Qt5Gui_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5Gui)
SET(Qt5Qml_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5Qml)
SET(Qt5Quick_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5Quick)
SET(Qt5Svg_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5Svg)
SET(Qt5WebSockets_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5WebSockets)
SET(Qt5Widgets_DIR ${QT_SOURCE_DIR}/lib/cmake/Qt5Widgets)

LIST(APPEND LIBRARIES
	${OPENSSL_DIR}/lib/libcrypto.a
	${OPENSSL_DIR}/lib/libssl.a
)

SET_SOURCE_FILES_PROPERTIES(${RESOURCES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)