LIST(APPEND SOURCES
	3rdparty/kqoauth/src/kqoauthmanager.cpp
	3rdparty/kqoauth/src/kqoauthrequest.cpp
	3rdparty/kqoauth/src/kqoauthutils.cpp
	3rdparty/kqoauth/src/kqoauthauthreplyserver.cpp
	3rdparty/kqoauth/src/kqoauthrequest_1.cpp
	3rdparty/kqoauth/src/kqoauthrequest_xauth.cpp
)

LIST(APPEND MOC_HEADERS
	3rdparty/kqoauth/src/kqoauthrequest_xauth.h
	3rdparty/kqoauth/src/kqoauthauthreplyserver.h
	3rdparty/kqoauth/src/kqoauthauthreplyserver_p.h
	3rdparty/kqoauth/src/kqoauthmanager.h
	3rdparty/kqoauth/src/kqoauthrequest.h
)

INCLUDE_DIRECTORIES(
	3rdparty/kqoauth/include
	3rdparty/kqoauth/src
)
