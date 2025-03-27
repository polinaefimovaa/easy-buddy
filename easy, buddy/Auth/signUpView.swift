import SwiftUI
import UIKit

struct SignUpView: View {
    @StateObject var favoritesManager = FavoritesManager()
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel
    @State private var email = ""
    @State private var password = "112345"
    @State private var passwordConfirmation = "112345"
    @State private var firstName = "Polina"
    @State private var lastName = "Efimova"
    @State private var dateOfBirth = Date()
    @State private var faculty = "Высшая школа бизнеса"
    @State private var country = "Russia"
    @State private var languages = "Russian"
    @State private var programType = "Студент по обмену"
    @State private var authenticityToken = "aaa0aa"
    @State private var profileImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentStage = 1
    @State private var showDatePicker = false // Новое состояние для управления видимостью календаря
    
    private var formattedDateOfBirth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dateOfBirth)
    }
    
    var body: some View {
        VStack {
            if viewModel.gotToken {
                H1(text: "Успешная регистрация!")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dismiss()
                        }
                    }
            } else {
                VStack(spacing: 16) {
                    // Индикатор этапов
                    HStack {
                        H3(text: "CREATE ACCOUNT")
                        Spacer()
                        StageIndicator(number: currentStage)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    
                    //                    if let errorMessage = errorMessage {
                    //                        Text(errorMessage)
                    //                            .foregroundColor(.red)
                    //                            .padding()
                    //                    }
                    //
                    // Контент этапов
                    TabView(selection: $currentStage) {
                        // Этап 1: Основные данные
                        VStack(spacing: 16) {
                            CustomTextField(text: $firstName, title: "First name", placeholder: "Your first name")
                            CustomTextField(text: $lastName, title: "Last name", placeholder: "Your last name")
                            // Поле для выбора даты рождения с выпадающим календарем
                            CustomCalendar(selectedDate: $dateOfBirth)
                            CustomTextField(text: $email, title: "Email", placeholder: "Your HSE Email")
                            CustomTextField(text: $password, title: "Password", placeholder: "Your password", isSecure: true)
                            CustomTextField(text: $passwordConfirmation, title: "Password confirmation", placeholder: "Your password confirmation", isSecure: true)
                            Button(action: {
                                withAnimation {
                                    currentStage = 2
                                }
                            }) {
                                PrimaryButton(text: "NEXT")
                            }
                            Spacer()
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 16)
                        
                        .background(RoundedRectangle(cornerRadius: 16) // Скругление фона
                            .fill(Color.white))
                        .tag(1)
                        
                        // Этап 2: Дополнительные данные
                        VStack(spacing: 16) {
                            CustomTextField (text: $country, title: "Country", placeholder: "Your country")
                            CustomTextField (text: $languages, title: "Languages", placeholder: "Your languages")
                            ProgramTypePicker(selectedOption: $programType)
                            FacultyPicker(selectedOption: $faculty)
                            HStack {
                                if let profileImage = profileImage {
                                    Image(uiImage: profileImage ?? UIImage()) // Используем дефолтное изображение, если profileImage nil
                                        .resizable()
                                        .scaledToFill() // Лучше чем .scaledToFit() для круглых изображений
                                        .frame(width: 48, height: 48) // Фиксированный размер
                                        .clipShape(Circle()) // Делаем изображение круглым
                                        .overlay(
                                            Circle() // Исправлено: было .Circle() → должно быть Circle()
                                                .stroke(Color.white, lineWidth: 2) // Белая обводка
                                                .frame(width: 48, height: 48) // Совпадает с размером изображения
                                        )
                                }
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    SecondaryButton(text: "CHOOSE PROFILE PHOTO")
                                }
                            }
                            
                            Spacer()
                            VStack {
                                Button(action: {
                                    isLoading = true
                                    errorMessage = nil
                                    
                                    viewModel.signUp(
                                        email: email,
                                        password: password,
                                        passwordConfirmation: passwordConfirmation,
                                        firstName: firstName,
                                        lastName: lastName,
                                        dateOfBirth: formattedDateOfBirth,
                                        faculty: faculty,
                                        country: country,
                                        languages: languages,
                                        programType: programType,
                                        profilePhoto: profileImage,
                                        authenticityToken: authenticityToken
                                    )
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        isLoading = false
                                    }
                                }) {
                                    PrimaryButton(text: "CREATE ACCOUNT")
                                }
                                .disabled(isLoading)
                                .padding(.bottom, 16)
                                Button(action: {
                                    withAnimation {
                                        currentStage = 1
                                    }
                                }) {
                                    tagsText(text:("BACK"), colorText: .black)
                                        .underline()
                                }
                            }
                            .padding(.bottom, 40)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 16)
                        .background(RoundedRectangle(cornerRadius: 16) // Скругление фона
                            .fill(Color.white))
                        .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(minHeight: 0, maxHeight: 700)
                    
                }
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $profileImage)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "E3FAFE"), Color.background]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss() // Закрывает текущий экран
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Иконка стрелки
                            .foregroundColor(.black)
                        Text("SIGN IN") // Кастомный текст
                            .font(.custom("TTHoves-Medium", size: 16))
                            .foregroundColor(.black)
                        
                    }
                    .foregroundColor(.blue) // Цвет текста и иконки
                }
            }
        }
        
    }
    
}

// Компонент для отображения индикатора этапа
struct StageIndicator: View {
    let number: Int
    
    var body: some View {
        VStack {
            H3(text: "\(number)/2")
        }
    }
}
