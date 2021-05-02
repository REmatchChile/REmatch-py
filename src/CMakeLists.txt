set(swig_project_LIB "${PROJECT_NAME}")

message("Sources: ${sources}")

set_property(SOURCE rematch.i PROPERTY CPLUSPLUS ON)
swig_add_library(${swig_project_LIB} TYPE MODULE LANGUAGE python SOURCES rematch.i)
target_link_libraries(${swig_project_LIB} rematchlib)
set_property(TARGET ${swig_project_LIB} PROPERTY LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SWIG_OUTDIR})
set_property(TARGET ${swig_project_LIB} PROPERTY SWIG_COMPILE_OPTIONS -O)

# Seems like linking is not necessary on Linux
if(APPLE OR WIN32)
  target_link_libraries(${swig_project_LIB} PRIVATE Python3::Module)
endif()