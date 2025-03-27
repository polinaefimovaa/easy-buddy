import SwiftUI



struct ContentView: View {
    @StateObject var favoritesManager = FavoritesManager()
    @ObservedObject var viewModel: ViewModel
    @State private var email: String = "student_0@edu.hse.ru"
    @State private var password: String = "password"
    @State private var selectedTab: Tab = .students
    @State private var isSignUpPresented = false
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.gotToken {
                    mainAppView
                } else {
                    authView
                }
            }
            .navigationDestination(isPresented: $isSignUpPresented) {
                SignUpView(viewModel: viewModel)
                    .onChange(of: viewModel.gotToken) { newValue in
                        if newValue {
                            isSignUpPresented = false // Закрываем экран регистрации после успеха
                        }
                    }
            }
        }
    }
    
    private var mainAppView: some View {
        VStack {
            switch selectedTab {
            case .students:
                StudentView(viewModel: viewModel)
            case .articles:
                ArticleView()
            case .profile:
                ProfileView(viewModel: viewModel)
            }
            
            Spacer()
            
            CustomTabBar(selectedTab: $selectedTab, animation: animation)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var authView: some View {
        ZStack (alignment: .bottom){
            Image("sign_in")
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading, spacing: 8) {
                H2(text:"SIGN IN")
                CustomTextField (text: $email, title: "Email", placeholder: "Your HSE email")
                CustomTextField (text: $password, title: "Password", placeholder: "Your password", isSecure: true)
                
                
                
                VStack (spacing: 8) {
                    Button(action: {
                        viewModel.signIn(login: email, password: password)
                    }) {
                        PrimaryButton(text: "SIGN IN")
                    }
                    .padding(.top, 20)
                    
                    Button(action: {
                        isSignUpPresented = true
                    })
                    {
                        SecondaryButton(text: "CREATE ACCOUNT")
                    }
                }
                
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .padding(.bottom, 112)
            .background(RoundedRectangle(cornerRadius: 16) // Скругление фона
                .fill(Color.white))
            
            .onChange(of: viewModel.gotToken) { newValue in
                if !newValue {
                    email = ""
                    password = ""
                }
            }
            
            
        }
        .ignoresSafeArea()
        
    }
}

// Перечисление для табов
enum Tab: String {
    case students = "Your students"
    case articles = "Articles"
    case profile = "Profile"
}

// Настройка кастомного таб бара
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var animation: Namespace.ID
    
    let tabs: [Tab] = [.students, .articles, .profile]
    
    var body: some View {
        HStack{
            HStack(spacing: 20) {
                ForEach(tabs, id: \.self) { tab in
                    TabBarButton(tab: tab, selectedTab: $selectedTab, animation: animation)
                }
            }
            .frame(height: 64)
            .padding(.horizontal,10)
            .background(Color.black)
            .cornerRadius(12)
            
            Spacer()
            Image("Globe")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .padding(18)
                .background(Color.black)
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
}

// Кнопка таба
struct TabBarButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTab = tab
            }
        }) {
            ZStack {
//                if selectedTab == tab {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.white)
//                        .frame(height:44)
//                }
                
                HStack {
                    Image(selectedTab == tab ? tabIcon+"_active": tabIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                    
                    if selectedTab == tab {
                        Text(tab.rawValue)
                            .fixedSize()
                            .foregroundColor(.black)
                            .font(.custom("TTHoves-Medium", size: 14))
                    }
                }
                .padding(.horizontal, 10)
                .background {
                    if selectedTab == tab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .frame(height: 44) // Чуть больше, чем высота HStack (40)
                    }
                }
            }
        }
    }
    
    private var tabIcon: String {
        switch tab {
        case .students:
            return "students" // Укажите имя вашего изображения
        case .articles:
            return "articles" // Укажите имя вашего изображения
        case .profile:
            return "profile" // Укажите имя вашего изображения
        }
    }
}
