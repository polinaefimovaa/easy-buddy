import SwiftUI
import UIKit



struct OnboardingContentView: View {
    
    @State var buttonName = "secondaryButton"
    let styleManager = StyleManager()
    
    let pages = [
        OnboardingData(title: "find new international students", description: "Here you can easily connect with a diverse pool of international students", image: "onboarding1", number: "1"),
        OnboardingData(title: "All info in one place", description: "Our platform consolidates all the essential resources and information you need in one convenient location.", image: "onboarding2", number: "2"),
        OnboardingData(title: "24/7 with your students", description: "We understand that questions and concerns can arise at any time. That’s why our app gives you the opportunity to assist your students.", image: "onboarding3", number: "3")
    ]
    @State private var currentPage = 0
    @AppStorage("hasBeenOnboarding") private var hasBeenOnboarding = false
    var body: some View {
        VStack {
            HStack (alignment: .top)  {
                HStack (alignment: .top) {
                    if currentPage > 0 {
                        Button(action: {
                            currentPage -= 1
                        }) {
                            tagsText(text:"BACK ", colorText: Color(hex: "#656565"))
                                .underline()
                        }
                    }
                    else {
                        Button(action: {
                           
                        }) {
                            tagsText(text:"BACK ", colorText: .white)
                                
                        }
                    }
                }
                .frame(width: 86, alignment: .leading)
                Spacer()
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
//                        Rectangle()
//                            .fill(Color.black)
//                            .frame(
//                                width: index == currentPage ? 79 : 3,
//                                height: 3
//                            )
//                            .animation(.easeInOut, value: currentPage)
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(index == currentPage ? Color(hex: "#656565") : Color(hex: "#D8D8D8"))
                    }
                }
                Spacer()
                Button(action: {
                    hasBeenOnboarding = true
                }) {
                    tagsText(text:("SKIP IT"), colorText: Color(hex: "#656565"))
                        .underline()
                }
                
                
                
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingView(data: pages[index])
                        
                }
                
            }
            .animation(.easeInOut, value: currentPage)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            if currentPage < pages.count - 1 {
                Button(action: {
                    currentPage += 1
                }) {
                    PrimaryButton(text: "NEXT")
                }
            }
            else {
                Button(action: {
                    hasBeenOnboarding = true
                }) {
                    PrimaryButton(text: "LET'S START")
                }
            }

        }
        .padding(.horizontal,16)
    }
        
    
}



#Preview {
    OnboardingContentView()
}
