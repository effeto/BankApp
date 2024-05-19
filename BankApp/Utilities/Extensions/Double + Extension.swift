import Foundation

extension Double {
    
    func convertDoubleToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        
        if let formattedAmount = formatter.string(from: NSNumber(value: self)) {
            return formattedAmount
        } else {
            return "\(self)"
        }
    }
    
    func convertTransactionDoubleToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 16
        
        if let formattedAmount = formatter.string(from: NSNumber(value: self)) {
            var amount = formattedAmount
            
            if let decimalRange = amount.range(of: "\\.\\d*?0+$", options: .regularExpression) {
                amount.removeSubrange(decimalRange.lowerBound..<amount.endIndex)
            }
            
            if amount.first == "-" {
                return "-" + "€" + amount.dropFirst()
            } else {
                return "€" + amount
            }
        } else {
            return "\\(self)"
        }
    }
    

    var removingTrailingZeros: String {
           let formatter = NumberFormatter()
           formatter.minimumFractionDigits = 0
           formatter.maximumFractionDigits = 2
           formatter.numberStyle = .decimal
           return formatter.string(from: NSNumber(value: self)) ?? String(self)
       }
}
