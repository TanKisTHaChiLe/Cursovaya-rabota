
cmake_minimum_required(VERSION 3.16)
project(CRM-system VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# 1. Подключаем компоненты Qt
find_package(Qt6 REQUIRED COMPONENTS Quick Sql Widgets)

# 2. Ручная настройка PostgreSQL (замените путь на свой!)
set(PG_ROOT "D:/Program Files/PostgreSQL/17")

# Проверка существования файлов
if(EXISTS "${PG_ROOT}/include/libpq-fe.h" AND EXISTS "${PG_ROOT}/lib/libpq.lib")
    message(STATUS "PostgreSQL found at: ${PG_ROOT}")

    # Создаем интерфейсную библиотеку
    add_library(PostgreSQL::PostgreSQL INTERFACE IMPORTED)

    # Указываем include-директории
    target_include_directories(PostgreSQL::PostgreSQL INTERFACE "${PG_ROOT}/include")

    # Указываем библиотеку
    target_link_libraries(PostgreSQL::PostgreSQL INTERFACE "${PG_ROOT}/lib/libpq.lib")

    # Для MinGW может потребоваться дополнительная библиотека
    if(MINGW)
        target_link_libraries(PostgreSQL::PostgreSQL INTERFACE ws2_32)
    endif()
else()
    message(FATAL_ERROR "PostgreSQL not found! Проверьте путь: ${PG_ROOT}")
endif()

# find_package(Qt6 COMPONENTS Core Sql Network Core5Compat REQUIRED)  # Добавьте Core5Compat

# 3. Настройка Qt проекта
qt_standard_project_setup(REQUIRES 6.5)

# 4. Добавляем исполняемый файл
qt_add_executable(appCRM-system
    main.cpp
    DatabaseManager.cpp
    DatabaseManager.h
    ExcelExporter.h
    ExcelExporter.cpp
    resources.qrc
)

# 5. Настройка QML модуля
qt_add_qml_module(appCRM-system
    URI CRM-system
    VERSION 1.0
    QML_FILES
        Main.qml
        Components/ActionMenu.qml
        Components/FormExit.qml
        Components/AuthorizationForm.qml
        Components/Page.qml
        Components/Theme.qml
        Components/AuthorisationForm2.qml
        Components/AddClient.qml
    RESOURCES resources.qrc
    SOURCES ExcelExporter.h ExcelExporter.cpp
)

# 6. Подключение библиотек
target_link_libraries(appCRM-system PRIVATE
    Qt6::Quick
    Qt6::Sql
    PostgreSQL::PostgreSQL
)

# 7. Установка
include(GNUInstallDirs)
install(TARGETS appCRM-system
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
