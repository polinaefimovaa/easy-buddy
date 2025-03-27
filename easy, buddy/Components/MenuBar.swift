//import SwiftUI
//
////struct ContentView: View {
////    @State private var selectedTab: Tab = .profile
////    @Namespace private var animation
////
////    var body: some View {
////        VStack {
////            Spacer()
////            
////            CustomTabBar(selectedTab: $selectedTab, animation: animation)
////        }
////        .edgesIgnoringSafeArea(.bottom)
////    }
////}
//
//struct CustomTabBar: View {
//    @Binding var selectedTab: Tab
//    var animation: Namespace.ID
//
//    let tabs: [Tab] = [.students, .articles, .profile]
//
//    var body: some View {
//        HStack(spacing: 20) {
//            ForEach(tabs, id: \.self) { tab in
//                TabBarButton(tab: tab, selectedTab: $selectedTab, animation: animation)
//            }
//        }
//        .frame(width: 250, height: 50) // Фиксированная ширина черной плашки
//        .background(Color.black)
//        .clipShape(Capsule())
//        .padding(.horizontal)
//    }
//}
//
//enum Tab: String {
//    case students = "Your Students"
//    case articles = "Articles"
//    case profile = "Profile"
//}
//
//struct TabBarButton: View {
//    let tab: Tab
//    @Binding var selectedTab: Tab
//    var animation: Namespace.ID
//
//    var body: some View {
//        Button(action: {
//            withAnimation(.spring()) {
//                selectedTab = tab
//            }
//        }) {
//            ZStack {
//                if selectedTab == tab {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.white)
//                        .matchedGeometryEffect(id: "tabHighlight", in: animation)
//                        .frame(height: 40)
//                        .padding(.horizontal, -5)
//                }
//
//                HStack {
//                    Image(tabIcon) // Замените на вашу кастомную иконку
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 20, height: 20)
//                        .foregroundColor(selectedTab == tab ? .black : .white)
//
//                    if selectedTab == tab {
//                        Text(tab.rawValue)
//                            .foregroundColor(.black)
//                            .font(.system(size: 16, weight: .medium))
//                            .padding(.horizontal, 10)
//                    }
//                }
//                .padding(.horizontal, 10)
//                .frame(height: 40)
//            }
//        }
//    }
//
//    private var tabIcon: String {
//        switch tab {
//        case .students:
//            return "students" // Укажите свой ресурс
//        case .articles:
//            return "articles"
//        case .profile:
//            return "profile"
//        }
//    }
//}
//
////struct ContentView_Previews: PreviewProvider {
////    static var previews: some View {
////        ContentView()
////    }
////}
