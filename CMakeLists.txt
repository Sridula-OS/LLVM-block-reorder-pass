cmake_minimum_required(VERSION 3.13)
project(BlockReorderPass)

find_package(LLVM REQUIRED CONFIG)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

add_library(BlockReorderPass SHARED BlockReorderPass.cpp)

set_target_properties(BlockReorderPass PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)
