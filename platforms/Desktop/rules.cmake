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