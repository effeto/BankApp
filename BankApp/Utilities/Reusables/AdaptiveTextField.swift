import SwiftUI
import UIKit

struct AdaptiveTextField: View {
    @Binding var text: String
    @State private var textWidth: CGFloat = 0
    
    var body: some View {
        HStack {
            TextField("", text: $text)
                .frame(width: max(textWidth, 50))
                .font(.system(size: 34, weight: .bold))
                .background(Color.white)
                .cornerRadius(5)
                .onChange(of: text) {
                    self.textWidth = calculateTextWidth(text: text)
                }
        }
    }
    
    private func calculateTextWidth(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        if text.count >= 6 {
            return size.width + 150
        } else if text.count == 0 {
            return size.width - size.width
        } else {
            return size.width + 75
        }
    }
}
