import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    // MARK: - Variables
    @Published var totalBalance: String = "0"
    @Published var balanceDouble: Double = 0.0
    @Published var cards: [CardModel] = []
    @Published var cardsTransactions: [CardTransactionModel] = []
    
    @Published var withdrawViewAmount = ""
    
    private let networking: HomeScreenAPICallsProtocol = HomeScreenAPICalls()
    
    // MARK: - API Calls
    func fetchData() {
        Task {
            await self.getBalance()
            await self.getCards()
            await self.getCardsTransactions()
        }
    }
    
    func getBalance() async {
        do {
            let result = try await networking.executeGetBalance(teamID: 0)
            switch result {
            case .success(let success):
                if let balance = success.balance {
                    DispatchQueue.main.async {
                        self.totalBalance = balance.convertDoubleToCurrency()
                        self.balanceDouble = balance
                    }
                } else {
                    self.handleError(error:"No balance found")
                }
            case .failure(let failure):
                self.handleError(error: failure.localizedDescription)
            }
        } catch {
            self.handleError(error: error.localizedDescription)
        }
    }
    
    func getCards() async {
        do {
            let result = try await networking.executeGetCards(teamID: 0)
            switch result {
            case .success(let success):
                if let cards = success.cards {
                    DispatchQueue.main.async {
                        self.cards = cards
                    }
                }
            case .failure(let failure):
                self.handleError(error: failure.localizedDescription)
            }
        } catch {
            self.handleError(error: error.localizedDescription)
        }
    }
    
    func getCardsTransactions() async {
        do {
            let result = try await networking.executeGetCardTransactions(teamID: 0)
            switch result {
            case .success(let success):
                if let cards = success.response {
                    DispatchQueue.main.async {
                        self.cardsTransactions = cards
                    }
                }
            case .failure(let failure):
                self.handleError(error: failure.localizedDescription)
            }
        } catch {
            self.handleError(error: error.localizedDescription)
        }
    }
    
    private func handleError(error: String) {
        print(error)
    }
}

// MARK: - Withdraw Logic
extension HomeViewModel {
    
    func validateAmountInput(_ input: String) -> String {
        var result = input
        
        if result.first == "0" || result.first == "," {
            result = String(result.dropFirst())
        }
        
        if let commaIndex = result.firstIndex(of: ",") {
            var afterComma = result[result.index(after: commaIndex)...]
            
            if let secondCommaIndex = afterComma.firstIndex(of: ",") {
                afterComma = afterComma[..<secondCommaIndex] + afterComma[afterComma.index(after: secondCommaIndex)...]
                result = String(result[..<result.index(after: commaIndex)]) + String(afterComma)
            }
            
            if afterComma.count > 2 {
                afterComma = afterComma.prefix(2)
                result = String(result[..<result.index(after: commaIndex)]) + afterComma
            }
        }
        
        if result.count == 12 {
            result = String(result.dropLast())
        }
        
        return result
    }
    
    func  attributedBalanceText() -> AttributedString {
        var attributedString = AttributedString("You have ")
        attributedString.foregroundColor = self.checkWithdrawTransactionAmount() ? Color(hex: "#7E8493") : .red
        
        var balanceString = AttributedString("€\(self.totalBalance)")
        balanceString.foregroundColor = self.checkWithdrawTransactionAmount() ? .black : .red

        
        var availableString = AttributedString("\n available in your balance")
        availableString.foregroundColor = self.checkWithdrawTransactionAmount() ? Color(hex: "#7E8493") : .red
        
        attributedString.append(balanceString)
        attributedString.append(availableString)
        
        return attributedString
    }
    
    func checkWithdrawTransactionAmount() -> Bool {
        let transactionAmount = Double(withdrawViewAmount) ?? 0.0
        
        if transactionAmount > balanceDouble {
            return false
        } else {
            return true
        }
    }
    
    func validateWithdrawTransaction() -> Bool {
        let transactionAmount = Double(withdrawViewAmount) ?? 0.0
        
        if self.checkWithdrawTransactionAmount() && transactionAmount != 0 {
            return true
        } else {
            return false
        }
    }
}
