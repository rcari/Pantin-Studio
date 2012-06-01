##
## Add a Pixelfr0g module, checking for name and version
##
function( pfrog_add_module name version path )
	string( TOUPPER ${name} _module_name )
	if( EXISTS ${path}/build/ModuleInfos.cmake )
		include( ${path}/build/ModuleInfos.cmake )
		if( ${MODULE_NAME} STREQUAL ${name} )
			# TODO: Check for version match ! (Major MUST MATCH!!)
			add_subdirectory( ${path} ${CMAKE_CURRENT_BINARY_DIR}/modules/${name} )
		else()
			message( FATAL_ERROR 
				"Not the right module: \"${MODULE_NAME}\" instead of \"${name}\" in \"${path}\"" )
		endif( ${MODULE_NAME} STREQUAL ${name} )
	else()
		message( FATAL_ERROR 
			"Invalid pixelfr0g module layout for \"${name}\" in \"${path}\"" )
	endif( EXISTS ${path}/build/ModuleInfos.cmake )
endfunction( pfrog_add_module )

##
## Find a Pixelfr0g module, using different techniques
##
function( pfrog_find_module name version )
	string( TOUPPER ${name} _module_name )
	if( ${_module_name}_SRC_PATH )
		# If provided on configure, building the module from source
		pfrog_add_module( ${name} ${version} ${${_module_name}_SRC_PATH} )
	elseif( EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/../../lib${name}/source/CMakeLists.txt )
		# Trying to find a default "dev" layout, building the module from source
		pfrog_add_module( ${name} ${version} ${CMAKE_CURRENT_SOURCE_DIR}/../../lib${name}/source )
	else()
		# Trying to find an installed version on the system
		find_package( ${name} ${version} REQUIRED )
	endif( ${_module_name}_SRC_PATH )
endfunction( pfrog_find_module )
