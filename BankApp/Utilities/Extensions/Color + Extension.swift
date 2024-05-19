import SwiftUI

extension Color {
    
    init(hex: String) {
        var cleanedHexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanedHexString.hasPrefix("#") {
            cleanedHexString.remove(at: cleanedHexString.startIndex)
        }

        guard cleanedHexString.count == 6 else {
            self = Color.black // Return black color if the string is invalid
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self = Color(red: red, green: green, blue: blue)
    }
}
