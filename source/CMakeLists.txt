CMAKE_MINIMUM_REQUIRED( VERSION 2.6 )

PROJECT( Pantin-Studio C CXX )

SET( PantinStudio_Version "0.0.1" )

IF( CMAKE_BUILD_TYPE )
	IF( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
		MESSAGE( "Building DEBUG binaries" )
		SET( DEBUG_BUILD ON )
		#SET( CMAKE_VERBOSE_MAKEFILE ON )
		SET( DEBUG_DEFINES "K_DEBUG" )
	ELSE( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
		MESSAGE( "Building RELEASE binaries" )					
		SET( DEBUG_BUILD OFF )
	ENDIF( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
ELSE( CMAKE_BUILD_TYPE )
	MESSAGE( "Building RELEASE binaries" )
	SET( DEBUG_BUILD OFF )
ENDIF( CMAKE_BUILD_TYPE )

IF( APPLE )
	INCLUDE( "build/CMake/platforms/MacOS.cmake" )
ELSE( UNIX )
	INCLUDE( "build/CMake/platforms/Linux-GCC.cmake" )
ELSEIF( MINGW )
	INCLUDE( "build/CMake/platforms/MinGW.cmake" )
ELSE( APPLE )
	INCLUDE( "build/CMake/platforms/VisualStudio.cmake" )
ENDIF( APPLE )

# -- Qt 4.8.0 minimum --
FIND_PACKAGE( Qt4 4.8.0 COMPONENTS QtCore QtGui QtOpenGL QtXml REQUIRED )
# -- Activate proper modules --
SET( QT_USE_QTOPENGL ON )
SET( QT_USE_QTXML ON )
INCLUDE( ${QT_USE_FILE} )

# -- Doxygen --
FIND_PACKAGE( Doxygen )

# -- OpenGL --
FIND_PACKAGE( OpenGL REQUIRED )

# -- Resources Qt --
QT4_ADD_RESOURCES(
	PantinStudio_RCC
	../resources/pantin-studio.qrc
	#../externals/Kore/resources/kore.qrc
	#../externals/Gooey/resources/gooey.qrc
	#../externals/Nigel/resources/nigel.qrc
	#../externals/Pantin/resources/pantin.qrc
)

# -- Module loading tools --
INCLUDE( "build/CMake/LoadModule.cmake" )

# -- Kore --
PFROG_FIND_MODULE( Kore 0.0.1 )
message( "Kore Version: ${KORE_VERSION_STRING}" )

# -- Nigel --
PFROG_FIND_MODULE( Nigel 0.0.1 )

# -- GLare --
#PFROG_FIND_MODULE( GLare 0.0.1 )

# -- Gooey --
#PFROG_FIND_MODULE( Gooey 0.0.1 )

# -- Pantin --
#PFROG_FIND_MODULE( Pantin 0.0.1 )



### ------------- PantinStudio ------------- 

# Inclusion paths
INCLUDE_DIRECTORIES( inc )

# Source files
SET( PantinStudio_SRCS	src/Pantin.cpp )

# Target executable: PantinStudio
# Mac OS specifics
IF( APPLE )
	SET( MACOSX_BUNDLE_ICON_FILE nigel.icns )
	SET_SOURCE_FILES_PROPERTIES( ../resources/images/icons/nigel.icns
		PROPERTIES MACOSX_PACKAGE_LOCATION Resources )
	
	ADD_EXECUTABLE( PantinStudio MACOSX_BUNDLE ${PantinStudio_SRCS} ${PantinStudio_RCC} ${CMAKE_CURRENT_SOURCE_DIR}/../resources/images/icons/nigel.icns )
		
	SET_TARGET_PROPERTIES ( 
		PantinStudio PROPERTIES
		COMPILE_DEFINITIONS "_PANTIN_STUDIO_VERSION=\"${PantinStudio_Version}\""
	)
	TARGET_LINK_LIBRARIES ( PantinStudio Kore Nigel GLr Gooey Pantin ${QT_LIBRARIES} )
# Windows specifics
ELSEIF ( WIN32 )
	ADD_EXECUTABLE ( PantinStudio WIN32 ${PantinStudio_SRCS} ${PantinStudio_RCC} )
	SET_TARGET_PROPERTIES ( 
		PantinStudio PROPERTIES
		COMPILE_DEFINITIONS "_PANTIN_STUDIO_VERSION=\"${PantinStudio_Version}\";_K_WIN32;${DEBUG_DEFINES}"
	)
	TARGET_LINK_LIBRARIES ( PantinStudio Kore GLr Pantin ${QT_CORE_LIBRARY} ${QT_GUI_LIBRARY} ${QT_QTMAIN_LIBRARY} )
# Linux specifics
ELSEIF ( UNIX )
	ADD_EXECUTABLE ( PantinStudio ${PantinStudio_SRCS} ${PantinStudio_RCC} )
	SET_TARGET_PROPERTIES ( 
		PantinStudio PROPERTIES
		COMPILE_DEFINITIONS "_PANTIN_STUDIO_VERSION=\"${PantinStudio_Version}\";_K_UNIX;${DEBUG_DEFINES}"
	)
	TARGET_LINK_LIBRARIES ( PantinStudio Kore GLr Pantin ${QT_CORE_LIBRARY} ${QT_GUI_LIBRARY} )
ENDIF ( APPLE )

# Configuring the debug environment
IF ( MSVC )
	SET ( CMAKE_INSTALL_DEBUG_LIBRARIES 1 )
	INCLUDE ( InstallRequiredSystemLibraries )
	IF ( ${CMAKE_GENERATOR} MATCHES "Visual Studio 9 2008" )
		SET ( VISUAL_STUDIO_VERSION "9,00" )
	ELSEIF ( ${CMAKE_GENERATOR} MATCHES "Visual Studio 8 2005" )
		SET ( VISUAL_STUDIO_VERSION "8,00" )
	ELSEIF ( ${CMAKE_GENERATOR} MATCHES "Visual Studio 10 2010" )
		SET ( VISUAL_STUDIO_VERSION "10,00" )
	ELSE ( ${CMAKE_GENERATOR} MATCHES "Visual Studio 9 2008" )
		SET ( VISUAL_STUDIO_VERSION "7,00" )
	ENDIF ( ${CMAKE_GENERATOR} MATCHES "Visual Studio 9 2008" )
	SET ( ENVIRONMENT_PATH_RELEASE "${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS};${CMAKE_CURRENT_BINARY_DIR}/Kore/Release;${CMAKE_CURRENT_BINARY_DIR}/Gooey/Release;${CMAKE_CURRENT_BINARY_DIR}/Pantin/Release;${CMAKE_CURRENT_BINARY_DIR}/Nigel/Release;${CMAKE_CURRENT_BINARY_DIR}/GLr/Release;${CMAKE_CURRENT_BINARY_DIR}/glew/Release;${QT_BINARY_DIR}" )
	SET ( ENVIRONMENT_PATH_DEBUG "${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS};${CMAKE_CURRENT_BINARY_DIR}/Kore/Debug;${CMAKE_CURRENT_BINARY_DIR}/Gooey/Debug;${CMAKE_CURRENT_BINARY_DIR}/Pantin/Debug;${CMAKE_CURRENT_BINARY_DIR}/Nigel/Debug;${CMAKE_CURRENT_BINARY_DIR}/GLr/Debug;${CMAKE_CURRENT_BINARY_DIR}/glew/Debug;${QT_BINARY_DIR}" )
	SET ( USER_FILE ${CMAKE_CURRENT_BINARY_DIR}/PantinStudio.vcproj.$ENV{USERDOMAIN}.$ENV{USERNAME}.user )
	CONFIGURE_FILE ( "${CMAKE_CURRENT_BINARY_DIR}/../resources/MSVC/PantinStudio.user" ${USER_FILE} )
ENDIF ( MSVC )
