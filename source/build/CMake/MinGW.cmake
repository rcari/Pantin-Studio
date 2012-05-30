# Compilation additional flags
SET ( CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-mstackrealign -Wall -Werror" )
# Executable linking additional flags
SET ( CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_CXX_LINK_EXECUTABLE} "-enable-stdcall-fixup -Wl,-enable-auto-import -Wl,-enable-runtime-pseudo-reloc" )
# Shared library linking additional flags
SET ( CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS	${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS} "-enable-stdcall-fixup -Wl,-enable-auto-import -Wl,-enable-runtime-pseudo-reloc" )
