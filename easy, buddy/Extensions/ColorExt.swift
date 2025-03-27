import SwiftUICore


extension Color {
    init(hex: String) {
        var hexNumber = hex
        if let hexFirst = hex.first, hexFirst == "#" {
            hexNumber = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        let scanner = Scanner(string: hexNumber)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            opacity: 1.0
        )
    }
}
