cmake_minimum_required(VERSION 3.15)
project(proyectoASM CXX ASM)

find_package(SDL2 REQUIRED)
include_directories(proyectoASM ${SDL2_INCLUDE_DIRS})


find_package (Threads)

set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_VERBOSE_MAKEFILE 1)

#set_source_files_properties(parcial.s PROPERTIES COMPILE_FLAGS "-x assembler-with-cpp")

add_executable(proyectoASM main.cpp proyectoASM.s arbol.s)

target_link_libraries(proyectoASM ${SDL2_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT} SDL2::SDL2 stdc++ m)
