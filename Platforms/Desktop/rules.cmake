#SET(HAVE_WEBKIT 1)

SET(QT_SOURCE_DIR "/path/to/qt" CACHE STRING "Path to qt source dir")
SET(OPENSSL_DIR "/path/to/openssl/lib/and/include" CACHE STRING "Path to the openssl for iPhone dir")

LIST(APPEND LIBRARIES
	${OPENSSL_DIR}/lib/libcrypto.a
	${OPENSSL_DIR}/lib/libssl.a
)

SET_SOURCE_FILES_PROPERTIES(${RESOURCES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)