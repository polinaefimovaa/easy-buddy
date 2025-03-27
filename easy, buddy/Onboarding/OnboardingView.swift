import SwiftUI
import UIKit



struct OnboardingView: View {
    var data: OnboardingData
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                H1(text: data.title)
                Circle() // Создаем круг
                    .fill(Color(hex: "#B3EDE3")) // Задаем цвет круга
                    .frame(width: 30, height: 30) // Размер круга
                    .overlay( // Накладываем текст на круг
                        Text(data.number) // Текст "1"
                            .font(.custom("TTHoves-Medium", size: 14))
                            .foregroundColor(.black) // Цвет текста
                    )
                    .padding(.leading, 50)
            }
            pOnboarding(text: data.description)
                
                .multilineTextAlignment(.center)
                .padding(.top, -20)
            Spacer()
            Image(data.image)
                .resizable()
                .scaledToFit()
            
            
        }
        .padding(.bottom,0)
        
    }
    
}

#Preview {
    OnboardingContentView()
}
