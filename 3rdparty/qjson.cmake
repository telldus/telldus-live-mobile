LIST(APPEND SOURCES
	3rdparty/qjson/src/json_scanner.cpp
	3rdparty/qjson/src/json_parser.cc
	3rdparty/qjson/src/parser.cpp
	3rdparty/qjson/src/parserrunnable.cpp
	3rdparty/qjson/src/qobjecthelper.cpp
	3rdparty/qjson/src/serializer.cpp
	3rdparty/qjson/src/serializerrunnable.cpp
)

LIST(APPEND MOC_HEADERS
	3rdparty/qjson/src/parserrunnable.h
	3rdparty/qjson/src/serializerrunnable.h
)

INCLUDE_DIRECTORIES( 3rdparty/qjson/src )
