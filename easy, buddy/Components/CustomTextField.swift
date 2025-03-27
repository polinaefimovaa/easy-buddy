import SwiftUI



//VStack(alignment: .leading) {
//    Text("Email")
//        .font(.subheadline)
//    TextField("Your HSE email", text: $email)
//        .textFieldStyle(RoundedBorderTextFieldStyle())
//}

struct CustomTextField: View {
    @Binding var text: String
    var title: String
    var placeholder: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("TTHoves-Medium", size: 14))
                .foregroundColor(.black)
            if isSecure {
                SecureField(placeholder, text: $text)
                
                    .font(.custom("TTHoves-Regular", size: 14))
                    .foregroundColor(.greyscale500)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8) // Скругление фона
                            .fill(Color.white))  // Фон текстового поля
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.greyscale100, lineWidth: 0.7)
                    )
            }
            else {
                TextField(placeholder, text: $text)
                
                    .font(.custom("TTHoves-Regular", size: 14))
                    .foregroundColor(.greyscale500)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8) // Скругление фона
                            .fill(Color.white))  // Фон текстового поля
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.greyscale100, lineWidth: 0.7)
                    )
            }
            
            
        }
    }
}

struct CustomTagProfile: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("TTHoves-Medium", size: 13))
            .fixedSize()
            .foregroundColor(.greyscale700)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8) // Скругление фона
                    .fill(Color.white))  // Фон текстового поля
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.greyscale100, lineWidth: 0.7)
            )
    }
}


struct CustomCalendar: View {
    @Binding var selectedDate: Date
    @State private var currentMonth: Date = Date()
    @State private var showDatePicker: Bool = false
    
    // Цвета из вашего дизайна
    private let primaryColor = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    private let secondaryColor = Color(red: 0.68, green: 0.68, blue: 0.7) // #AEAEB2
    private let accentColor = Color.black
    private let backgroundColor = Color.white
    private let disabledColor = Color(red: 0.82, green: 0.82, blue: 0.84) // #D1D1D6
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date of Birth")
                .font(.custom("TTHoves-Medium", size: 14))
                .foregroundColor(primaryColor)
            
            // Триггер для отображения календаря
            HStack {
                Text(formattedDate)
                    .font(.custom("TTHoves-Regular", size: 14))
                    .foregroundColor(secondaryColor)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(secondaryColor)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.greyscale100, lineWidth: 0.7)
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    showDatePicker.toggle()
                }
            }
            
            // Кастомный календарь
            if showDatePicker {
                VStack(spacing: 0) {
                    // Заголовок с навигацией
                    HStack {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .padding(8)
                        }
                        
                        Spacer()
                        
                        Text(monthYearString(from: currentMonth))
                            .font(.custom("TTHoves-Medium", size: 16))
                            .foregroundColor(primaryColor)
                        
                        Spacer()
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                                .padding(8)
                        }
                        .disabled(isNextMonthDisabled())
                    }
                    .padding(.horizontal, 8)
                    
                    // Дни недели
                    HStack(spacing: 0) {
                        ForEach(weekdaySymbols(), id: \.self) { day in
                            Text(day)
                                .font(.custom("TTHoves-Medium", size: 12))
                                .foregroundColor(secondaryColor)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Дни месяца
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(daysInMonth(), id: \.self) { date in
                            if date.month != currentMonth.month {
                                Text("\(date.day)")
                                    .font(.custom("TTHoves-Regular", size: 14))
                                    .foregroundColor(disabledColor)
                                    .frame(width: 32, height: 32)
                            } else {
                                Button(action: {
                                    withAnimation {
                                        selectedDate = date
                                        showDatePicker = false
                                    }
                                }) {
                                    Text("\(date.day)")
                                        .font(.custom("TTHoves-Medium", size: 14))
                                        .foregroundColor(date == selectedDate ? .white : primaryColor)
                                        .frame(width: 32, height: 32)
                                        .background(
                                            Circle()
                                                .fill(date == selectedDate ? accentColor : Color.clear)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func weekdaySymbols() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.shortWeekdaySymbols
    }
    
    private func daysInMonth() -> [Date] {
        let calendar = Calendar.current
        let monthRange = calendar.range(of: .day, in: .month, for: currentMonth)!
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        
        var days: [Date] = []
        
        // Добавляем дни предыдущего месяца
        let firstWeekday = calendar.component(.weekday, from: startDate)
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
        let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth)!
        
        for i in (previousMonthRange.upperBound - firstWeekday + 1)..<previousMonthRange.upperBound {
            if let date = calendar.date(byAdding: .day, value: i, to: previousMonth) {
                days.append(date)
            }
        }
        
        // Добавляем дни текущего месяца
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) {
                days.append(date)
            }
        }
        
        // Добавляем дни следующего месяца (чтобы заполнить сетку)
        let totalDays = days.count
        let remaining = 42 - totalDays // 6 недель * 7 дней
        
        if remaining > 0 {
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
            
            for day in 1...remaining {
                if let date = calendar.date(byAdding: .day, value: day, to: nextMonth) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
    }
    
    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
    }
    
    private func isNextMonthDisabled() -> Bool {
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
        return nextMonth > Date()
    }
}

// MARK: - Date Extensions

extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}

struct CustomTextFieldProfile: View {
    @Binding var text: String
    var title: String
    
    var body: some View {
        ZStack (alignment: .leading) {
            Text(text)
                .font(.custom("TTHoves-Regular", size: 16))
                .foregroundColor(.black)
                .padding(.horizontal, 21)
                .padding(.vertical, 12)
            
                .padding(.top, 8)
            Text(title)
                .font(.custom("TTHoves-Medium", size: 14))
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                .background(
                    Rectangle()
                        .fill(Color.white) // Розовый цвет подложки
                )
                .padding(.leading, 12)
                .padding(.bottom, 35)
            
        }
        .padding(.bottom,8)
    }
}


struct CustomTextFieldSecure: View {
    @Binding var text: String
    var title: String
    var placeholder: String
    
    var body: some View {
        ZStack (alignment: .leading) {
            SecureField(placeholder, text: $text)
                .font(.custom("TTHoves-Regular", size: 16))
                .foregroundColor(.black)
                .padding(.horizontal, 21)
                .padding(.vertical, 12)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1) // Рамка вокруг текстового поля
                )
                .padding(.top, 8)
            Text(title)
                .font(.custom("TTHoves-Medium", size: 14))
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                .background(
                    Rectangle()
                        .fill(Color.white) // Розовый цвет подложки
                )
                .padding(.leading, 12)
                .padding(.bottom, 35)
            
        }
        .padding(.bottom,8)
    }
}
struct CustomTextFieldLong: View {
    @Binding var text: String
    var title: String
    var placeholder: String
    
    var body: some View {
        ZStack (alignment: .leading) {
            TextField(placeholder, text: $text)
                .font(.custom("TTHoves-Regular", size: 16))
                .foregroundColor(.black)
                .padding(.horizontal, 21)
                .padding(.vertical, 12)
                .padding(.bottom, 24)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1) // Рамка вокруг текстового поля
                )
                .padding(.top, 8)
            Text(title)
                .font(.custom("TTHoves-Medium", size: 14))
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                .background(
                    Rectangle()
                        .fill(Color.white) // Розовый цвет подложки
                )
                .padding(.leading, 12)
                .padding(.bottom, 58)
            
        }
        .padding(.bottom,8)
    }
}

struct TagSelectionMenu: View {
    let text: String
    @Binding var selectedTag: String // Привязка к выбранному тегу
    let tagsFilter: [String] // Список доступных тегов
    
    var body: some View {
        Menu {
            ForEach(tagsFilter, id: \.self) { tag in
                Button(action: {
                    selectedTag = tag // Обновляем выбранный тег
                }) {
                    Text(tag)
                        .font(.custom("TTHoves-Regular", size: 16))
                        .foregroundColor(selectedTag == tag ? .black : .black) // Здесь контролируем цвет
                        .padding()
                }
            }
        } label: {
            ZStack(alignment: .topLeading) {
                Text(text)
                    .font(.custom("TTHoves-Medium", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                    )
                    .padding(.top, -20)
                    .padding(.leading, 0)
                
                HStack {
                    Text(selectedTag)
                        .font(.custom("TTHoves-Regular", size: 16))
                        .foregroundColor(selectedTag == "Выберите тег" ? .black : .black) // Цвет по умолчанию
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
                .padding(.leading, 8)
            }
            .padding()
            .frame(width: 362, height: 43, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1)) // Оформление
        }
    }
}

struct ProgramTypePicker: View {
    let options = [
        "Full Degree Student",
        "Exchange student",
        "Prep Year Student"
    ]
    
    @Binding var selectedOption: String
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Заголовок
            Text("Type of exchange")
                .font(.custom("TTHoves-Medium", size: 14))
                .foregroundColor(.black)
            // Поле выбора
            HStack {
                Text(selectedOption)
                    .font(.custom("TTHoves-Regular", size: 14))
                    .foregroundColor(.greyscale500)
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(showPicker ? 180 : 0))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8) // Скругление фона
                    .fill(Color.white))  // Фон текстового поля
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.greyscale100, lineWidth: 0.7)
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showPicker.toggle()
                }
            }
            
            // Выпадающий список
            if showPicker {
                Picker("", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
                .transition(.opacity)
                .labelsHidden()
                .onChange(of: selectedOption) { _ in
                    showPicker = false
                }
            }
        }
    }
}
struct FacultyPicker: View {
    let options = [
        "Faculty of Mathematics",
        "Faculty of Economic Sciences",
        "A.N. Tikhonov Moscow Institute of Electronics and Mathematics",
        "Faculty of Computer Science",
        "Graduate School of Business",
        "Graduate School of Jurisprudence and Administration",
        "Faculty of Humanities",
        "Faculty of Social Sciences",
        "Faculty of Creative Industries",
        "Faculty of World Economy and International Affairs",
        "Faculty of Physics",
        "International College of Economics and Finance",
        "Faculty of Urban and Regional Development",
        "Faculty of Chemistry",
        "Faculty of Biology and Biotechnology",
        "Faculty of Geography and Geoinformation Technology",
        "School of Foreign Languages",
        "Institute for Statistical Studies and Economics of Knowledge",
        "Banking Institute",
        "School of Innovation and Entrepreneurship"
    ]
    @Binding var selectedOption: String
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Заголовок
            Text("Faculty")
                .font(.custom("TTHoves-Medium", size: 14))
                .foregroundColor(.black)
            
            // Поле выбора
            HStack {
                Text(selectedOption)
                    .font(.custom("TTHoves-Regular", size: 14))
                    .foregroundColor(.greyscale500)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(showPicker ? 180 : 0))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8) // Скругление фона
                    .fill(Color.white))  // Фон текстового поля
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.greyscale100, lineWidth: 0.7)
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showPicker.toggle()
                }
            }
            
            // Выпадающий список
            if showPicker {
                Picker("", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
                .transition(.opacity)
                .labelsHidden()
                .onChange(of: selectedOption) { _ in
                    showPicker = false
                }
            }
        }
    }
}
