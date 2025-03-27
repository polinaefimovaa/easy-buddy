import SwiftUI
//
// 2. Объявление класса `StyleManager` как `final`, что означает,
// что этот класс не может быть унаследован другими классами.
//
final class StyleManager {
    // 3. Статический метод, который принимает имя стиля (строка)
    // и возвращает объект типа `Style` или `nil`, если стиль не найден.
    static func style(for name: String) -> Style? {
        // 4. Используется конструкция `guard` для безопасного
        // извлечения пути к файлу "Styles.txt" в основном бандле приложения.
        guard
            let path = Bundle.main.path(forResource: "Styles", ofType: "txt"),
            // 5. Читает содержимое файла как строку и преобразует его в данные UTF-8.
            let data = try? String(contentsOfFile: path, encoding: .utf8).data(using: .utf8),
            // 6. Декодирует данные в массив объектов типа `Style`.
            // Если декодирование не удается, метод также вернет `nil`.
                let styles = try? JSONDecoder().decode([Style].self, from: data)
        else {
            // Если путь не найден или возникают ошибки при чтении данных,
            // метод вернет `nil`.
            return nil
        }
        // 7. Перебирает все стили и ищет тот, чье имя совпадает
        // с переданным аргументом `name`.
        for style in styles where style.name == name {
            return style // Если такой стиль найден, он возвращается.
        }
        // 8. Возвращает `nil`, если ни один стиль не соответствует имени.
        return nil
    }
    // 9. Статический метод для получения радиуса скругления углов
    // заданного стиля по имени.
    static func cornerRadius(for name: String) -> CGFloat {
        // Если стиль не найден, возвращается значение по умолчанию 5
        return Self.style(for: name)?.cornerRadius ?? 5
    }
    // 10. Статический метод для получения цвета фона заданного стиля по имени.
    static func backgroundColor(for name: String) -> Color {
        if let hex = Self.style(for: name)?.backgroundColor {
            // Если цвет фона существует (в формате шестнадцатеричной строки),
            // он конвертируется в объект типа `Color`.
            return Color(hex: hex)
        }
        return .blue // В противном случае возвращается стандартный синий цвет.
    }
    // 11. Аналогично предыдущему методу.
    static func foregroundColor(for name: String) -> Color {
        // Получает цвет текста (foreground color) заданного стиля по имени.
        if let hex = Self.style(for: name)?.foregroundColor {
            return Color(hex: hex)
        }
        return .white // Возвращает белый цвет по умолчанию,
        // если стиль не найден или цвет отсутствует.
    }
}
