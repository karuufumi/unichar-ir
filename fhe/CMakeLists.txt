cmake_minimum_required(VERSION 4.0)

project(fhe)
set(CMAKE_CXX_STANDARD 23)

# Correct path to SEALConfig.cmake
set(SEAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lib/cmake/SEAL-4.1")

find_package(SEAL REQUIRED)

add_executable(fhe
        src/main.cpp
)

target_include_directories(fhe PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(fhe PRIVATE
        SEAL::seal
)