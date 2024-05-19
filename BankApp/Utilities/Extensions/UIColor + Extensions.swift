import UIKit

extension UIColor {
    convenience init(hex: String) {
        var cleanedHexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanedHexString.hasPrefix("#") {
            cleanedHexString.remove(at: cleanedHexString.startIndex)
        }

        guard cleanedHexString.count == 6 else {
            self.init(white: 0.0, alpha: 1.0) 
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

