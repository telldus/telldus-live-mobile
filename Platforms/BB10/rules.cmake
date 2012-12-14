SET(BB10_FILES
	bar-descriptor.xml
)

SET_SOURCE_FILES_PROPERTIES(
	bar-descriptor.xml
	PROPERTIES TARGET_PATH "."
)

LIST(APPEND LIBRARIES -lcpp -lbbsystem )

FOREACH(file ${BB10_FILES})
	GET_FILENAME_COMPONENT(filename ${file} NAME)
	GET_SOURCE_FILE_PROPERTY(path ${file} TARGET_PATH)
	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_BINARY_DIR}/${path}/${filename}
		COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/Platforms/BB10/${file} ${CMAKE_BINARY_DIR}/${path}/${filename}
		MAIN_DEPENDENCY ${CMAKE_SOURCE_DIR}/Platforms/BB10/${file}
		COMMENT "Copying ${file}"
	)
	LIST(APPEND SOURCES ${CMAKE_BINARY_DIR}/${path}/${filename})
ENDFOREACH()

FUNCTION(COMPILE target)
	ADD_CUSTOM_COMMAND(
		TARGET ${target}
		POST_BUILD
		COMMAND blackberry-nativepackager -package ${target}.bar -devMode bar-descriptor.xml ${target}
	)
ENDFUNCTION()
