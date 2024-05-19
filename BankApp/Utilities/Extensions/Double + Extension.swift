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
        
        if let formattedAmount = formatter.string(from: NSNumber(value: self)) {
            if formattedAmount.first == "-" {
                return "-" + "€" + formattedAmount.dropFirst()
            } else {
                return "€" + formattedAmount
            }
        } else {
            return "\(self)"
        }
    }
}
