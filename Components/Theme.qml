pragma Singleton
import QtQuick
import "."

QtObject {
    property bool isDarkTheme: false
    signal themeChanged(bool isDark) // Добавьте этот сигнал

    function toggleTheme() {
        isDarkTheme = !isDarkTheme
        themeChanged(isDarkTheme)
    }
}
