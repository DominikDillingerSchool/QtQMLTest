message(STATUS "Selecting QT Version")

# Find Qt
if(NOT QT_DEFAULT_MAJOR_VERSION)
    set(QT_DEFAULT_MAJOR_VERSION 5 CACHE STRING "Qt version to use (5 or 6), defaults to 5")
endif()
message(STATUS "Finding QT Version ${QT_DEFAULT_MAJOR_VERSION}")
list(APPEND QT_MODULES 
Core
Gui
Qml
Quick
QuickControls2
Svg
Xml
# QmlWorkerScript
)
set(QT_PREFIXED_MODULES ${QT_MODULES})
list(TRANSFORM QT_PREFIXED_MODULES PREPEND "Qt${QT_DEFAULT_MAJOR_VERSION}::")
find_package(Qt${QT_DEFAULT_MAJOR_VERSION} REQUIRED ${QT_MODULES} COMPONENTS)

# Sources
set(HDRS
)
set(UI
  "main.qml"
  )
set(SRCS
  "main.cpp"
)
qt_add_resources(qml_QRC qml.qrc)
set(PROJECT_SOURCES ${SRCS} ${HDRS} ${UI} ${qml_QRC})

# QML Settings
## enable QML debugging
string(TOLOWER "${CMAKE_BUILD_TYPE}" cmake_build_type_lower)
if(${cmake_build_type_lower} MATCHES "debug")
    add_definitions(-DQT_QML_DEBUG)
endif()
## Project setup
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Executable
message(STATUS "Building ${PROJECT_NAME}EmptyExecutable...")
if(${QT_DEFAULT_MAJOR_VERSION} GREATER_EQUAL 6)
  find_package(Qt6 REQUIRED COMPONENTS QmlIntegration)
  qt_add_executable(${PROJECT_NAME}EmptyExecutable MANUAL_FINALIZATION)
  target_link_libraries(${PROJECT_NAME}EmptyExecutable PRIVATE Qt6::QmlIntegration)
else()
  add_executable(${PROJECT_NAME}EmptyExecutable)
endif()
target_sources(${PROJECT_NAME}EmptyExecutable PRIVATE ${PROJECT_SOURCES})
target_link_libraries(${PROJECT_NAME}EmptyExecutable PRIVATE ${QT_PREFIXED_MODULES})
target_include_directories(${PROJECT_NAME}EmptyExecutable PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

## Static link to runtime library
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  target_link_options(${PROJECT_NAME}EmptyExecutable PRIVATE -stdlib=libc++ -lpthread -g)
elseif(MSVC)
  target_compile_options(${PROJECT_NAME}EmptyExecutable PRIVATE "/MT")
else()
  target_link_options(${PROJECT_NAME}EmptyExecutable PRIVATE -static-libstdc++ -static-libgcc -g)
endif()

## MANUAL_FINALIZATION of qt6 exectuable
if(${QT_DEFAULT_MAJOR_VERSION} GREATER_EQUAL 6)
  qt_import_qml_plugins(${PROJECT_NAME}EmptyExecutable)
  qt_finalize_executable(${PROJECT_NAME}EmptyExecutable)
endif()

# Install
install(TARGETS ${PROJECT_NAME}EmptyExecutable DESTINATION executable)
install(FILES $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}EmptyExecutable> DESTINATION executable)
