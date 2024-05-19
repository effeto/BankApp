import Foundation

// MARK: - Protocol
protocol HomeScreenAPICallsProtocol {
    func executeGetBalance(teamID: Int) async throws -> Result<BalanceModel, APIServiceError>
    func executeGetCards(teamID: Int) async throws -> Result<CardsResponse, APIServiceError>
    func executeGetCardTransactions(teamID: Int) async throws -> Result<CardTransactionResponse, APIServiceError>
}

// MARK: - Execution
class HomeScreenAPICalls: HomeScreenAPICallsProtocol {
    func executeGetBalance(teamID: Int) async throws -> Result<BalanceModel, APIServiceError> {
        do {
            let result = try await self.getBalance(teamID: teamID)
            return .success(result)
        } catch {
            switch(error) {
            case APIServiceError.decodingError:
                return .failure(.decodingError)
            case APIServiceError.tokenExpired:
                return .failure(.tokenExpired)
            default:
                return .failure(.statusNotOK)
            }
        }
    }
    
    func executeGetCards(teamID: Int) async throws -> Result<CardsResponse, APIServiceError> {
        do {
            let result = try await self.getCards(teamID: teamID)
            return .success(result)
        } catch {
            switch(error) {
            case APIServiceError.decodingError:
                return .failure(.decodingError)
            case APIServiceError.tokenExpired:
                return .failure(.tokenExpired)
            default:
                return .failure(.statusNotOK)
            }
        }
    }
    
    func executeGetCardTransactions(teamID: Int) async throws -> Result<CardTransactionResponse, APIServiceError> {
        do {
            let result = try await self.getCardTransactions(teamID: teamID)
            return .success(result)
        } catch {
            switch(error) {
            case APIServiceError.decodingError:
                return .failure(.decodingError)
            case APIServiceError.tokenExpired:
                return .failure(.tokenExpired)
            default:
                return .failure(.statusNotOK)
            }
        }
    }
}

// MARK: - API Calls
extension HomeScreenAPICalls {
    private func getBalance(teamID: Int) async throws -> BalanceModel {
         #if DEBUG
         return self.getMockBalance()
         #else
         guard let url = URL(string:  "\(APIEndpoints.getTotalBalance(teamID: teamID).url)") else {
             throw APIServiceError.badUrl
         }
         
         print(url)
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         
         
         guard let (data, response) = try? await URLSession.shared.data(for: request), let httpResponse = response as? HTTPURLResponse else {
             throw APIServiceError.requestError
         }
         
         if httpResponse.statusCode != 200 {
             print("Status code error: \(httpResponse.statusCode)")
             throw APIServiceError.statusNotOK
         } else if httpResponse.statusCode == 401 {
             throw APIServiceError.tokenExpired
         }
         
         guard let result = try? JSONDecoder().decode(BalanceModel.self, from: data) else {
             print("JSON decoding error")
             throw APIServiceError.decodingError
         }
         
         return result
         #endif
     }
     
    private func getCards(teamID: Int) async throws -> CardsResponse {
         #if DEBUG
         return self.getMockCards()
         #else
         guard let url = URL(string:  "\(APIEndpoints.getCards(teamID: teamID).url)") else {
             throw APIServiceError.badUrl
         }
         
         print(url)
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         
         
         guard let (data, response) = try? await URLSession.shared.data(for: request), let httpResponse = response as? HTTPURLResponse else {
             throw APIServiceError.requestError
         }
         
         if httpResponse.statusCode != 200 {
             print("Status code error: \(httpResponse.statusCode)")
             throw APIServiceError.statusNotOK
         } else if httpResponse.statusCode == 401 {
             throw APIServiceError.tokenExpired
         }
         
         guard let result = try? JSONDecoder().decode(CardsResponse.self, from: data) else {
             print("JSON decoding error")
             throw APIServiceError.decodingError
         }
         
         return result
         #endif
     }
     
    private func getCardTransactions(teamID: Int) async throws -> CardTransactionResponse {
         #if DEBUG
         return self.getMockCardTransactions()
         #else
         guard let url = URL(string:  "\(APIEndpoints.getCardTransactions(teamID: teamID).url)") else {
             throw APIServiceError.badUrl
         }
         
         print(url)
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         
         
         guard let (data, response) = try? await URLSession.shared.data(for: request), let httpResponse = response as? HTTPURLResponse else {
             throw APIServiceError.requestError
         }
         
         if httpResponse.statusCode != 200 {
             print("Status code error: \(httpResponse.statusCode)")
             throw APIServiceError.statusNotOK
         } else if httpResponse.statusCode == 401 {
             throw APIServiceError.tokenExpired
         }
         
         guard let result = try? JSONDecoder().decode(CardTransactionResponse.self, from: data) else {
             print("JSON decoding error")
             throw APIServiceError.decodingError
         }
         
         return result
         #endif
     }
}

// MARK: - Mock Data
extension HomeScreenAPICalls {
    private func getMockBalance() -> BalanceModel {
        return BalanceModel(balance: 15300.85)
    }
    
    private func getMockCards() -> CardsResponse {
        let cardHolder = CardHolderModel(id: "0", fullName: "John Doe", email: "email@email.com", logoUrl: "")
        
        let cards = [CardModel(id: "0", cardLast4: "4141", cardName: "Virtual Card", isLocked: false, isTerminated: false, spent: 100, limit: 200, limitType: "", cardHolder: cardHolder, fundingSource: "", issuedAt: ""),
                     CardModel(id: "1", cardLast4: "4141", cardName: "Slack", isLocked: false, isTerminated: false, spent: 200, limit: 300, limitType: "", cardHolder: cardHolder, fundingSource: "", issuedAt: ""),
                     CardModel(id: "2", cardLast4: "4141", cardName: "Google", isLocked: false, isTerminated: false, spent: 200, limit: 300, limitType: "", cardHolder: cardHolder, fundingSource: "", issuedAt: ""),]
        return CardsResponse(cards: cards)
    }
    
    private func getMockCardTransactions() -> CardTransactionResponse {
        let transactions = [CardTransactionModel(id: "0", tribeTransactionId: "1111", tribeCardId: 0, amount: "1000", status: "done", tribeTransactionType: "+", schemeId: "", merchantName: "Load", pan: ""),
                            CardTransactionModel(id: "1", tribeTransactionId: "1111", tribeCardId: 0, amount: "-500", status: "done", tribeTransactionType: "-", schemeId: "", merchantName: "Google", pan: ""),
                            CardTransactionModel(id: "2", tribeTransactionId: "1111", tribeCardId: 0, amount: "-1299", status: "done", tribeTransactionType: "-", schemeId: "", merchantName: "Google", pan: "")]
        
        return CardTransactionResponse(response: transactions)
    }
}

