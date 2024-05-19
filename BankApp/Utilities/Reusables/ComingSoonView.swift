import SwiftUI

struct ComingSoonView: View {
    var title: String
    
    var body: some View {
        VStack(content: {
            HStack {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.leading, 16)
                Spacer()
            }
            .padding(.top, 44)
            
            Spacer()
            VStack(alignment: .center, content: {
                Image(.icLogo)
                    .resizable()
                    .frame(width: 80, height: 80)
                Text("Coming soon")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15, weight: .medium))
            })
            Spacer()
        })
    }
}


