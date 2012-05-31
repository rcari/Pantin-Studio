FUNCTION( LOAD_MODULE name version )

	STRING( TOUPPER ${name} MODULE_NAME )

	MESSAGE( ${MODULE_NAME}_SRC_PATH )

	IF( ${MODULE_NAME}_SRC_PATH )

		ADD_SUBDIRECTORY( ${${MODULE_NAME}_SRC_PATH}
			${CMAKE_CURRENT_BINARY_DIR}/modules/${name} )

	ELSEIF( EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/../../lib${name}/source/CMakeLists.txt )
	
		ADD_SUBDIRECTORY( ${CMAKE_CURRENT_SOURCE_DIR}/../../lib${name}/source
			${CMAKE_CURRENT_BINARY_DIR}/modules/${name} )
	
	ELSE( ${MODULE_NAME}_SRC_PATH )

		FIND_PACKAGE( ${name} ${version} REQUIRED )

	ENDIF( ${MODULE_NAME}_SRC_PATH )
	
	# Do stuff for inclusion...

ENDFUNCTION( LOAD_MODULE )
