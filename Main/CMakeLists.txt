project(Main LANGUAGES CXX)

add_executable(Main
               src/Main.cpp
               src/Main.h
               )

target_include_directories(Main PRIVATE ${raylib_INCLUDE_DIRS})

target_link_libraries(Main PRIVATE ${raylib_LIBRARIES})