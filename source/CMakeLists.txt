CMAKE_MINIMUM_REQUIRED ( VERSION 2.6 )

PROJECT ( Pantin-Studio C CXX )

SET ( PantinStudio_Version "0.0.1" )

IF ( MINGW )
	INCLUDE( "build/CMake/MinGW.cmake" )
ELSEIF( APPLE )
	INCLUDE( "build/CMake/MacOS.cmake" )
ELSEIF( UNIX )
	INCLUDE( "build/CMake/Linux.cmake" )
ELSE ( MINGW )
	INCLUDE( "build/CMake/Windows.cmake" )
ENDIF ( MINGW )

IF ( CMAKE_BUILD_TYPE )
	IF ( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
		MESSAGE ( "Building DEBUG binaries" )
		SET ( DEBUG_BUILD ON )
		#SET ( CMAKE_VERBOSE_MAKEFILE ON )
		SET ( DEBUG_DEFINES "K_DEBUG" )
	ELSE ( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
		MESSAGE ( "Building RELEASE binaries" )					
		SET ( DEBUG_BUILD OFF )
	ENDIF ( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )
ELSE ( CMAKE_BUILD_TYPE )
	MESSAGE ( "Building RELEASE binaries" )
	SET ( DEBUG_BUILD OFF )
ENDIF ( CMAKE_BUILD_TYPE )

# -- Qt 4.8.0 minimum --
FIND_PACKAGE ( Qt4 4.8.0 COMPONENTS QtCore QtGui QtOpenGL QtXml REQUIRED )
# -- Configure Qt for PantinStudio --
SET ( QT_USE_QTOPENGL ON )
SET ( QT_USE_QTXML ON )
INCLUDE ( ${QT_USE_FILE} )

# -- Doxygen --
FIND_PACKAGE ( Doxygen )

# -- OpenGL --
FIND_PACKAGE ( OpenGL REQUIRED )

# -- Resources Qt --
QT4_ADD_RESOURCES (
	PantinStudio_RCC
	../resources/pantin-studio.qrc
	../externals/Kore/resources/kore.qrc
	../externals/Gooey/resources/gooey.qrc
	../externals/Nigel/resources/nigel.qrc
	../externals/Pantin/resources/pantin.qrc
)

# -- Kore --
ADD_SUBDIRECTORY ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Kore/build ${CMAKE_CURRENT_BINARY_DIR}/Kore )
SET ( KORE_INCLUDE_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Kore/inc ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Kore )
INCLUDE_DIRECTORIES ( ${KORE_INCLUDE_PATHS} )

# -- Nigel --
ADD_SUBDIRECTORY ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Nigel/build ${CMAKE_CURRENT_BINARY_DIR}/Nigel )
SET ( NIGEL_INCLUDE_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Nigel/inc ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Nigel )
INCLUDE_DIRECTORIES ( ${NIGEL_INCLUDE_PATHS} )

# -- glew --
ADD_SUBDIRECTORY ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/glew/build ${CMAKE_CURRENT_BINARY_DIR}/glew )
SET ( GLEW_INCLUDE_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../externals/glew/include )
INCLUDE_DIRECTORIES ( ${GLEW_INCLUDE_PATHS} )

# -- GLr --
ADD_SUBDIRECTORY ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/GLr/build ${CMAKE_CURRENT_BINARY_DIR}/GLr )
SET ( GLR_INCLUDE_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../externals/GLr/inc ${CMAKE_CURRENT_SOURCE_DIR}/../externals/GLr )
INCLUDE_DIRECTORIES ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/GLr/inc )

# -- Gooey --
ADD_SUBDIRECTORY ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Gooey/build ${CMAKE_CURRENT_BINARY_DIR}/Gooey )
SET ( GOOEY_INCLUDE_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Gooey/inc ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Gooey )
INCLUDE_DIRECTORIES ( ${GOOEY_INCLUDE_PATHS} )

# -- Pantin --
ADD_SUBDIRECTORY ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Pantin/build ${CMAKE_CURRENT_BINARY_DIR}/Pantin )
INCLUDE_DIRECTORIES ( ${CMAKE_CURRENT_SOURCE_DIR}/../externals/Pantin/inc )

# Headers
INCLUDE_DIRECTORIES ( ${CMAKE_CURRENT_SOURCE_DIR}/../inc )

### ------------- PantinStudio -------------
FILE ( GLOB PantinStudio_SRCS	${CMAKE_CURRENT_SOURCE_DIR} ../src/*.cpp )

# Target executable: PantinStudio
# Mac OS specifics
IF ( APPLE )
	ADD_EXECUTABLE ( PantinStudio MACOSX_BUNDLE ${PantinStudio_SRCS} ${PantinStudio_RCC} ${CMAKE_CURRENT_SOURCE_DIR}/../resources/images/icons/nigel.icns )
	SET ( MACOSX_BUNDLE_ICON_FILE nigel.icns )
	SET_SOURCE_FILES_PROPERTIES ( ${CMAKE_CURRENT_SOURCE_DIR}/../resources/images/icons/nigel.icns PROPERTIES MACOSX_PACKAGE_LOCATION Resources )
	SET_TARGET_PROPERTIES ( 
		PantinStudio PROPERTIES
		COMPILE_DEFINITIONS "_PANTIN_STUDIO_VERSION=\"${PantinStudio_Version}\";_K_MACX;${DEBUG_DEFINES}"
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

