cmake_minimum_required(VERSION 3.23
            LANGUAGES C
        )
project (rax)

set (CONAN_USER_HOME $ENV{CONAN_USER_HOME})


cmake_minimum_required(VERSION 3.23)
project(rax
         LANGUAGES CXX)

find_package(fmt REQUIRED)
find_package(fmtlog REQUIRED)
find_package(scn REQUIRED)

file(GLOB SRC *.cpp)

add_library (irax INTERFACE )
target_include_directories(irax
    INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

target_link_libraries(irax INTERFACE -stdlib=libc++ -lc++abi)

add_library (rax_static STATIC ${SRC}  )
target_link_libraries ( rax_static PUBLIC irax PRIVATE fmtlog::fmtlog  fmt::fmt scn::scn)

add_library (rax SHARED ${SRC} )
target_link_libraries ( rax PUBLIC irax PRIVATE fmtlog::fmtlog)

add_subdirectory(test)
