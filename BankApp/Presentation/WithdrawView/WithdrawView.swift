import SwiftUI

struct WithdrawView: View {
    // MARK: - Variables
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: BaseCoordinator
    @StateObject var viewModel: HomeViewModel
    @FocusState private var keyboardFocused: Bool
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center) {
            self.titleView
            Spacer()
            self.textField
            Spacer()
            self.continueButton
                .padding(.bottom, 16)
        }
        .onDisappear(perform: {
            self.viewModel.withdrawViewAmount.removeAll()
        })
    }
    
    // MARK: - Title View
    private var titleView: some View {
        HStack(content: {
            Spacer()
            Text("Transfer")
                .font(.system(size: 17, weight: .semibold))
            Spacer()
            Button(action: {
                self.dismiss()
                self.viewModel.withdrawViewAmount.removeAll()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
                    .font(.system(size: 17))
            })
            .padding(.trailing, 16)
            .frame(width: 40, height: 40)
        })
        .padding(.top, 10)
    }
    
    // MARK: - Text Field
    private var textField: some View {
        VStack(alignment: .center) {
            HStack(spacing: 7.5) {
                Spacer()
                Text("€")
                    .font(.system(size: 34, weight: .bold))
                AdaptiveTextField(text: $viewModel.withdrawViewAmount)
                    .keyboardType(.decimalPad)
                    .focused($keyboardFocused)
                     .onAppear {
                         DispatchQueue.main.async {
                             keyboardFocused = true
                         }
                     }
                    .onChange(of: viewModel.withdrawViewAmount, { oldValue, newValue in
                        viewModel.withdrawViewAmount = viewModel.validateAmountInput(newValue)
                        
                        let filteredValue = viewModel.filterInput(newValue)
                                   if filteredValue != newValue {
                                       viewModel.withdrawViewAmount = filteredValue
                                   }
                    })
                Spacer()
            }
            .padding(.bottom, 12)
            Text(self.viewModel.attributedBalanceText())
                .font(.system(size: 13, weight: .medium))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Balance Message
    private var balanceMessage: some View {
        HStack {
            Text("You have ")
            Text("€\(self.viewModel.totalBalance)")
                .foregroundColor(.blue) 
            Text("\n available in your balance")
                .multilineTextAlignment(.center)
                .font(.system(size: 13, weight: .medium))
        }
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        HStack {
            Spacer()
            Button(action: {
                if self.viewModel.validateWithdrawTransaction() {
                    self.dismiss()
                    self.viewModel.withdrawViewAmount.removeAll()
                }
            }, label: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundStyle(self.viewModel.validateWithdrawTransaction() ? Color(hex: "338FFF") : Color(hex: "#A0CAFD"))
                    Text("Continue")
                        .foregroundStyle(.white)
                })
                .frame(height: 48)
            })
            .disabled(!self.viewModel.validateWithdrawTransaction())
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
