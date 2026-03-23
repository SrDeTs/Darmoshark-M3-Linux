cmake_minimum_required(VERSION 3.16)

project(DarmosharkM3 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME Runtime)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Widgets)
find_package(PkgConfig REQUIRED)
pkg_check_modules(HIDAPI REQUIRED hidapi-libusb)
pkg_check_modules(LIBUSB REQUIRED libusb-1.0)

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

target_include_directories(DarmosharkM3 PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
    ${HIDAPI_INCLUDE_DIRS}
    ${LIBUSB_INCLUDE_DIRS}
)

install(TARGETS DarmosharkM3 RUNTIME DESTINATION bin)
install(FILES 99-darmoshark.rules DESTINATION lib/udev/rules.d)
install(FILES com.darmoshark.m3.desktop DESTINATION share/applications)
install(FILES images/LogoDarmoshark-512.png DESTINATION share/icons/hicolor/512x512/apps RENAME com.darmoshark.m3.png)

set(CPACK_PACKAGE_NAME "darmoshark-m3")
set(CPACK_PACKAGE_VENDOR "Darmoshark")
set(CPACK_PACKAGE_CONTACT "Michael <michael@example.com>")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Linux software for Darmoshark M3/N3/M3S mice")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "DarmosharkM3")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_HOMEPAGE_URL "http://www.darmoshark.cn/")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")

set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libhidapi-libusb0, libusb-1.0-0")
if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "arm64")
else()
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "${CMAKE_SYSTEM_PROCESSOR}")
endif()

set(CPACK_RPM_FILE_NAME RPM-DEFAULT)
set(CPACK_RPM_PACKAGE_LICENSE "GPL")
set(CPACK_RPM_PACKAGE_GROUP "Applications/System")
set(CPACK_RPM_PACKAGE_REQUIRES "hidapi, libusb1")
set(CPACK_RPM_PACKAGE_AUTOREQ ON)

include(CPack)
