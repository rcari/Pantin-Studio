cmake_minimum_required( VERSION 2.8.3 )

message( "Configuring Pantin-Studio repository in dev mode" )

find_package( Git REQUIRED )

function( pfrog_clone_module name )
	message( "Cloning ${name}" )
	execute_process( COMMAND ${GIT_EXECUTABLE} clone git@github.com:rcari/${name}.git "${MODULES_FOLDER}/${name}" OUTPUT_VARIABLE result OUTPUT_QUIET )
	if(result)
		message( "Failed!" FATAL_ERROR )
	endif(result)
endfunction( pfrog_clone_module name )

message( "Creating modules folder" )
set( MODULES_FOLDER ${CMAKE_CURRENT_LIST_DIR}/modules )
execute_process( COMMAND cmake -E make_directory "${MODULES_FOLDER}" )

pfrog_clone_module(libKore)
pfrog_clone_module(libGooey)
pfrog_clone_module(libNigel)
pfrog_clone_module(libGLare)
pfrog_clone_module(libPantin)

message( "Successful!" ) 
