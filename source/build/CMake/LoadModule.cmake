##
## Sandboxed version test
##
function( pfrog_check_version name path version )
	include( ${path}/source/build/ModuleInfos.cmake )
	if( ${name} STREQUAL ${MODULE_NAME} )
		# TODO !!
	else()
		message( FATAL_ERROR "Expected module ${name} but found ${MODULE_NAME} in ${path}" )
	endif( ${name} STREQUAL ${MODULE_NAME} )
	  
endfunction( pfrog_check_version name path version ) 

##
## Add a Pixelfr0g module, checking for name and version
##
function( pfrog_find_module name version )
	string( TOUPPER ${name} _module_name )
	if( PFROG_DEV_MODE )
		# Check if a specific path is given on configure
		if( NOT ${_module_name}_SRC_PATH )
			set( ${_module_name}_SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../modules/lib${name} ) 
		endif( NOT ${_module_name}_SRC_PATH )
		
		# Check version
		pfrog_check_version( ${name} ${${_module_name}_SRC_PATH} ${version} )
		
		# Add that subdirectory
		add_subdirectory( ${${_module_name}_SRC_PATH}/source ${${_module_name}_BUILD_DIR} )
		
		# The module was found
		set( ${_module_name}_FOUND ON PARENT_SCOPE )
		
		# Setup all the modules variables in the calling scope
		foreach( var ${${_module_name}_EXPORT_VARIABLES} )
			set( ${var} ${${var}} PARENT_SCOPE )
		endforeach( var ${_module_name}_EXPORT_VARIABLES )
	else()
		# Use the CMake find_package, it's a standalone build... 
		find_package( ${name} ${version} )
	endif( PFROG_DEV_MODE )
endfunction ( pfrog_find_module name version )
