# Build architectures
SET( CMAKE_OSX_ARCHITECTURES "i386;x86_64" )

# Compilation additional flags
IF( CMAKE_COMPILER_IS_GNUCXX ) 
	SET( CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-Wall -Werror" )
ELSE()
	# This one is because Clang sucks!
	SET( CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-Wall -Werror -Wno-overloaded-virtual" )
ENDIF( CMAKE_COMPILER_IS_GNUCXX )

# Platform definitions
ADD_DEFINITIONS( -D_K_MACX )
