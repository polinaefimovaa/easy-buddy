import SwiftUI

@main
struct easyBuddy: App { // Убедитесь, что имя структуры начинается с большой буквы
    @AppStorage("hasBeenOnboarding") var hasBeenOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !hasBeenOnboarding {
                OnboardingContentView()
                    .onDisappear {
                        hasBeenOnboarding = true
                    }
            }
            else
            {
                ContentView(viewModel: ViewModel()) // Создание экземпляра ViewModel
            }
        }
    }
}

//import SwiftUI
//
//
//struct EasyBuddy: App {
//    @StateObject var favoritesManager = FavoritesManager()
//    @StateObject var favoritesDiscussion = FavoritesDiscussion()
//    
//    // для онбординга
////    @AppStorage("isSentBuddy") var isSentBuddy: Bool = false
//    @AppStorage("hasBeenOnboarding") var hasBeenOnboarding: Bool = false
////    // для регистрации и входа
//    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
////    @State private var selectedIndex = 2 // Индекс выбранного пункта меню
//    
//    var body: some Scene {
//        WindowGroup {
//            VStack {
//                // Онбординг экран
//                if !hasBeenOnboarding {
//                    OnboardingContentView()
//                        .onDisappear {
//                            hasBeenOnboarding = true
//                        }
//                }
//                else {
//                    if !isAuthenticated {
//                        ContentView(viewModel: ViewModel())
//                            .onDisappear {
//                                isAuthenticated = true
//                            }
//                    }
//                    else {
//                        ContentView(viewModel: viewModel)
//                    }
//                    
//                    //                // Экран входа, если пользователь не аутентифицирован
//                    //                else if !isAuthenticated {
//                    //                    ContentView(viewModel: ViewModel())
//                    //                        .onDisappear {
//                    //                            isAuthenticated = true
//                    //                        }
//                    //                }
//                    //                // Основное содержимое после онбординга и авторизации
//                    //                else {
//                    //                    Group {
//                    //                        // Экран анкеты или другого содержимого в зависимости от состояния isSentBuddy
//                    //                        if selectedIndex == 0 {
//                    //                            if isSentBuddy { // Переход в StudentView1
//                    //                                StudentView1()
//                    //                            } else { // Переход в StudentView
//                    //                                StudentView()
//                    //                            }
//                    //                        }
//                    //                        // Статьи
//                    //                        else if selectedIndex == 3 {
//                    //                            ArticleView().environmentObject(favoritesManager)
//                    //                        }
//                    //                        // Профиль
//                    //                        else if selectedIndex == 4 {
//                    //                            ProfileView().environmentObject(favoritesManager)
//                    //                        }
//                    //                    }
//                    //
//                    //                    Spacer()
//                    //
//                    //                    // Меню навигации
//                    //
//                    //                }
//                }
//            }
//        }
//    }
//}
