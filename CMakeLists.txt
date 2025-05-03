# cmake_minimum_required(VERSION 3.16)

# project(CRM-system VERSION 0.1 LANGUAGES CXX)

# set(CMAKE_CXX_STANDARD_REQUIRED ON)
# set(CMAKE_AUTORCC ON)

# find_package(Qt6 REQUIRED COMPONENTS Quick)

# qt_standard_project_setup(REQUIRES 6.5)
# qt_add_executable(appCRM-system main.cpp resources.qrc)

# qt_add_qml_module(appCRM-system
#     URI CRM-system
#     VERSION 1.0
#     QML_FILES
#         Main.qml Components/ActionMenu.qml Components/FormExit.qml Components/AuthorizationForm.qml Components/Page.qml Components/Theme.qml Components/AuthorisationForm2.qml
#     RESOURCES resources.qrc
# )

# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# # If you are developing for iOS or macOS you should consider setting an
# # explicit, fixed bundle identifier manually though.
# set_target_properties(appCRM-system PROPERTIES
# #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCRM-system
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )

# target_link_libraries(appCRM-system
#     PRIVATE Qt6::Quick
# )

# include(GNUInstallDirs)
# install(TARGETS appCRM-system
#     BUNDLE DESTINATION .
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
cmake_minimum_required(VERSION 3.16)
project(CRM-system VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# 1. Подключаем компоненты Qt
find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

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

# 3. Настройка Qt проекта
qt_standard_project_setup(REQUIRES 6.5)

# 4. Добавляем исполняемый файл
qt_add_executable(appCRM-system
    main.cpp
    DatabaseManager.cpp
    DatabaseManager.h
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
    RESOURCES resources.qrc
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
