import SwiftUI

struct H1: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.custom("BebasNeueBold", size: 68))
            .foregroundColor(.black)
            .kerning(2)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 16)
    }
}

struct H2: View {
    var text: String
    var colorText: Color?
    var body: some View {
        Text(text)
            .font(.custom("BebasNeueBold", size: 54))
            .foregroundColor(.black)
            .kerning(2)
            .padding(.bottom, 16)
    }
}
struct H3: View {
    var text: String
    var colorText: Color?
    var body: some View {
        Text(text)
            .font(.custom("BebasNeueBold", size: 40))
            .foregroundColor(.black)
            .kerning(0)
    }
}

struct H4: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.custom("SALongBeachRegular", size: 20))
            .foregroundColor(.black)
    }
}
struct tags: View {
    let text: String
    
    
    private var tagBackgroundColor: Color {
        switch text {
        case "STUDYING":
            return Color(.green50) // Light blue
        case "LIFE":
            return Color(.pink50) // Light green
        case "DOCUMENTS":
            return Color(.red50) // Light orange
        default:
            return Color.gray.opacity(0.2) // Default fallback
        }
        }
    private var tagTextColor: Color {
        switch text {
        case "STUDYING":
            return Color(.green500) // Light blue
        case "LIFE":
            return Color(.pink500) // Light green
        case "DOCUMENTS":
            return Color(.red500) // Light orange
        default:
            return Color.gray.opacity(0.2) // Default fallback
        }
        }
    
    
var body: some View {
    Text(text)
        .font(.custom("TTHoves-Medium", size: 12))
        .foregroundColor(tagTextColor) // Цвет текста
        .padding(.horizontal,12)
        .padding(.vertical, 6)
        .background(
                       RoundedRectangle(cornerRadius: 76)
                           .fill(tagBackgroundColor) // Use dynamic color
                   )
}
}

struct pTabs: View {
    var text: String
    var colorText: Color?
    var body: some View {
        Text(text)
            .font(.custom("TTHoves-Medium", size: 12))
            .foregroundColor(.black)
            .textCase(.uppercase)
    }
}
//
//struct TagView: View {
//    let tag: String
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Text(tag)
//            .font(.custom("TTHoves-Medium", size: 14))
//            .padding(.horizontal, 12)
//            .padding(.vertical, 8)
//            .background(isSelected ? Color.black : Color.white) // Заливка при нажатии
//            .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color.black, lineWidth: 1) // Обводка
//            )
//            .foregroundColor(isSelected ? Color.white : Color.black) // Цвет текста
//            .cornerRadius(20) // Закруглённые края
//            .onTapGesture {
//                action() // Выполнение действия
//            }
//
//
//    }
//}

struct TagView: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        if isSelected {
            HStack{
                Circle()
                    .frame(width: 6, height: 6)
                Text(tag)
                    .font(.custom("TTHoves-Medium", size: 12))
                    .foregroundColor(.black)
            }
            .padding(8)
            .onTapGesture {
                action() // Выполнение действия
            }
            
        }
        else {
            Text(tag)
                .font(.custom("TTHoves-Medium", size: 12))
                .foregroundColor(.black)
                .padding(8)
                .onTapGesture {
                    action() // Выполнение действия
                }
        }
    }
}

struct p: View {
    var text: String
    var colorText: Color?
    var body: some View {
        Text(text)
            .font(.custom("TTHoves-Regular", size: 14))
            .foregroundColor(colorText ?? .greyscale500)
    }
}
struct pOnboarding: View {
    var text: String
    var colorText: Color?
    var body: some View {
        Text(text)
            .font(.custom("TTHoves-Regular", size: 20))
            .foregroundColor(colorText ?? .gray)
    }
}
struct tagsText: View {
    var text: String
    var colorText: Color?
    var body: some View {
        Text(text)
            .font(.custom("TTHoves-Medium", size: 16))
            .foregroundColor(colorText ?? .gray)
        
    }
}
