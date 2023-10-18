message(STATUS "Selecting QT Version")

if(NOT QT_DEFAULT_MAJOR_VERSION)
    set(QT_DEFAULT_MAJOR_VERSION 5 CACHE STRING "Qt version to use (5 or 6), defaults to 5")
endif()

message(STATUS "Finding QT Version ${QT_DEFAULT_MAJOR_VERSION}")

find_package(Qt${QT_DEFAULT_MAJOR_VERSION} REQUIRED COMPONENTS
Core
Gui
Qml
Quick
QuickControls2
Svg
Xml
QuickCompiler
)
find_package(Qt${QT_DEFAULT_MAJOR_VERSION} QUIET COMPONENTS QmlWorkerScript)

## Sources
set(HDRS
	)

set(UI
    "main.qml"
    )

set(SRCS
    "main.cpp"
	)

set(PROJECT_SOURCES ${SRCS} ${HDRS})

## QML Settings
# enable QML debugging
string(TOLOWER "${CMAKE_BUILD_TYPE}" cmake_build_type_lower)
if(cmake_build_type_lower MATCHES "debug")
    add_definitions(-DQT_QML_DEBUG)
endif()

include_directories(${Qt5Widgets_INCLUDE_DIRS} ${QtQml_INCLUDE_DIRS})
add_definitions(${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS} ${${Qt5Quick_DEFINITIONS}})
if (QT_DEFAULT_MAJOR_VERSION EQUAL 5)
  qt5_add_resources(qml_QRC qml.qrc)
else()
  qt6_add_resources(qml_QRC qml.qrc)
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS}")
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

## Executable
message(STATUS "Building ${PROJECT_NAME}Executable...")

add_executable(${PROJECT_NAME}Executable)
target_sources(${PROJECT_NAME}Executable PRIVATE ${PROJECT_SOURCES} ${qml_QRC})
set_target_properties(${PROJECT_NAME}Executable PROPERTIES AUTORCC TRUE)
set_target_properties(${PROJECT_NAME}Executable PROPERTIES AUTOMOC TRUE)
set(CMAKE_AUTOMOC ON)
target_link_libraries(${PROJECT_NAME}Executable PRIVATE
  Qt${QT_DEFAULT_MAJOR_VERSION}::Core
  Qt${QT_DEFAULT_MAJOR_VERSION}::Gui
  Qt${QT_DEFAULT_MAJOR_VERSION}::Svg
  Qt${QT_DEFAULT_MAJOR_VERSION}::Xml
  Qt${QT_DEFAULT_MAJOR_VERSION}::Qml
  Qt${QT_DEFAULT_MAJOR_VERSION}::Quick
  Qt${QT_DEFAULT_MAJOR_VERSION}::QuickControls2
  Qt${QT_DEFAULT_MAJOR_VERSION}::QmlWorkerScript
)
target_include_directories(${PROJECT_NAME}Executable PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Static link to runtime library
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  target_link_options(${PROJECT_NAME}Executable PRIVATE -stdlib=libc++ -lpthread -g)
elseif(MSVC)
  # target_link_options(${PROJECT_NAME}Executable PRIVATE "/MT")
else()
  target_link_options(${PROJECT_NAME}Executable PRIVATE -static-libstdc++ -static-libgcc -g)
endif()

## Install
install(TARGETS ${PROJECT_NAME}Executable DESTINATION executable)
install(FILES $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}Executable> DESTINATION executable)
install(FILES ${UI} DESTINATION executable)

# Find the C++ compiler path
find_program(CMAKE_CXX_COMPILER NAMES c++ g++ cl)

# Check if the C++ compiler was found
if(CMAKE_CXX_COMPILER)
  # Get the directory where the C++ compiler is located
  get_filename_component(COMPILER_PATH "${CMAKE_CXX_COMPILER}" DIRECTORY)
  message(STATUS "Found C++ compiler: ${CMAKE_CXX_COMPILER}")
else()
  message(FATAL_ERROR "Could not find C++ compiler")
endif()

get_target_property(QT_EXECUTABLE_LOCATION Qt${QT_DEFAULT_MAJOR_VERSION}::Core LOCATION)
if(QT_EXECUTABLE_LOCATION STREQUAL "QT_EXECUTABLE_LOCATION-NOTFOUND")
  message(FATAL_ERROR "Could not find QT exectuable location. Missing variable QT_EXECUTABLE_LOCATION.")
endif()
message(STATUS "Found QT_EXECUTABLE_LOCATION: ${QT_EXECUTABLE_LOCATION}")

install(TARGETS ${PROJECT_NAME}Executable RUNTIME_DEPENDENCIES
  PRE_EXCLUDE_REGEXES "api-ms-" "ext-ms-"
  POST_EXCLUDE_REGEXES ".*system32/.*\\.dll"
  DIRECTORIES [ ${COMPILER_PATH} "${QT_EXECUTABLE_LOCATION}/.." ]
  DESTINATION executable
)

# Get the path to the Qt shared platforms directory
set(QT_SHARE_PLATFORMS_DIR "${QT_EXECUTABLE_LOCATION}/../../share/qt${QT_DEFAULT_MAJOR_VERSION}/plugins/platforms")

install(DIRECTORY "${QT_SHARE_PLATFORMS_DIR}" DESTINATION executable)
