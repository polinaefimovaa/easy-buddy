import SwiftUI

struct PrimaryButton: View {
    var text: String
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .font(.custom("TTHoves-Medium", size: 16))
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(8)
    }
}
struct SecondaryButton: View {
    var text: String
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .font(.custom("TTHoves-Medium", size: 16))
            .foregroundColor(.black)
            .cornerRadius(8)
            .padding(.vertical,0)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 0.7)
            )
    }
}

struct logoutprofileButton: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .font(.custom("TTHoves-Medium", size: 14))
            .foregroundColor(.black)
            .background(.red50)
            .cornerRadius(6)
            .padding(.vertical,0)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red500, lineWidth: 0.7)
            )
    }
}
struct editprofileButton: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .font(.custom("TTHoves-Medium", size: 14))
            .foregroundColor(.black)
            .cornerRadius(6)
            .padding(.vertical,0)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.greyscale300, lineWidth: 0.7)
            )
    }
}
