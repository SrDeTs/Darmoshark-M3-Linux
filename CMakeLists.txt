cmake_minimum_required(VERSION 3.16)

project(DarmosharkM3 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Widgets)
find_package(PkgConfig REQUIRED)
pkg_check_modules(HIDAPI REQUIRED hidapi-libusb)
pkg_check_modules(LIBUSB REQUIRED libusb-1.0)

include_directories(include)

add_executable(DarmosharkM3
    src/main.cpp
    src/appcontroller.cpp
    src/hidmanager.cpp
    src/configmanager.cpp
    resources.qrc
)

target_link_libraries(DarmosharkM3
    PRIVATE 
    Qt6::Core 
    Qt6::Quick 
    Qt6::QuickControls2
    Qt6::Widgets
    ${HIDAPI_LIBRARIES}
    ${LIBUSB_LIBRARIES}
)

target_include_directories(DarmosharkM3 PRIVATE ${HIDAPI_INCLUDE_DIRS} ${LIBUSB_INCLUDE_DIRS})
