#SET(HAVE_WEBKIT 1)

LIST(APPEND LIBRARIES
	-lcrypto
	-lssl
)

LIST(APPEND SOURCES
	platforms/Desktop/Notification.cpp
	platforms/Desktop/Push.cpp
)
LIST(APPEND MOC_HEADERS
	platforms/Desktop/Notification.h
	platforms/Desktop/Push.h
)

ADD_DEFINITIONS(-DQT_MESSAGELOGCONTEXT)
SET(CMAKE_CXX_FLAGS "-Wno-unknown-pragmas -Wno-deprecated-declarations")