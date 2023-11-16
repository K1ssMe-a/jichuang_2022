cmake_minimum_required(VERSION 3.0)

project(algorithm LANGUAGES C)


set(CMAKE_C_COMPILER "gcc")
set(CMAKE_C_STANDARD 99)
set(SRC_LIST main.c)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

LINK_LIBRARIES(m)

include_directories(./code)
add_executable(out 
            ./code/main.c 
            ./code/bmp.c
            ./code/matrix.c
            ./code/scale.c
            ./code/LCDI.c
            ./code/bicubic.c
            ./code/weight.c
            )
