project(Doom LANGUAGES CXX)

add_executable(Doom
               src/Main.cpp
               src/Main.h
               )

target_link_libraries(Doom PRIVATE raylib)

#target_include_directories(Doom
#                           PRIVATE
#                           raylib
#                           )