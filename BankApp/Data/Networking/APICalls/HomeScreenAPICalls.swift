import Foundation

// MARK: - Protocol
protocol HomeScreenAPICallsProtocol {
    func executeGetBalance(teamID: Int) async throws -> Result<BalanceModel, APIServiceError>
    func executeGetCards(teamID: Int) async throws -> Result<CardsResponse, APIServiceError>
    func executeGetCardTransactions(teamID: Int) async throws -> Result<CardTransactionResponse, APIServiceError>
}

// MARK: - Execution
class HomeScreenAPICalls: HomeScreenAPICallsProtocol {
    
    private func makeAPICall<T: Decodable>(endpoint: String, teamID: Int, mockFunction: (() -> T)?) async throws -> Result<T, APIServiceError> {
        if let mockData = mockFunction?() {
            return .success(mockData)
        }
        guard let url = URL(string: endpoint) else {
            throw APIServiceError.badUrl
        }

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

        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            print("JSON decoding error")
            throw APIServiceError.decodingError
        }
        
        return .success(result)
    }

    func executeGetBalance(teamID: Int) async throws -> Result<BalanceModel, APIServiceError> {
        #if DEBUG
        let mockFunction: (() -> BalanceModel)? = getMockBalance
        #else
        let mockFunction: (() -> BalanceModel)? = nil
        #endif
        return try await makeAPICall(endpoint: APIEndpoints.getTotalBalance(teamID: teamID).url, teamID: teamID, mockFunction: mockFunction)
    }

    func executeGetCards(teamID: Int) async throws -> Result<CardsResponse, APIServiceError> {
        #if DEBUG
        let mockFunction: (() -> CardsResponse)? = getMockCards
        #else
        let mockFunction: (() -> CardsResponse)? = nil
        #endif
        return try await makeAPICall(endpoint: APIEndpoints.getCards(teamID: teamID).url, teamID: teamID, mockFunction: mockFunction)
    }

    func executeGetCardTransactions(teamID: Int) async throws -> Result<CardTransactionResponse, APIServiceError> {
        #if DEBUG
        let mockFunction: (() -> CardTransactionResponse)? = getMockCardTransactions
        #else
        let mockFunction: (() -> CardTransactionResponse)? = nil
        #endif
        return try await makeAPICall(endpoint: APIEndpoints.getCardTransactions(teamID: teamID).url, teamID: teamID, mockFunction: mockFunction)
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
                            CardTransactionModel(id: "1", tribeTransactionId: "1111", tribeCardId: 0, amount: "-500", status: "done", tribeTransactionType: "-", schemeId: "", merchantName: "Google", pan: "+"),
                            CardTransactionModel(id: "2", tribeTransactionId: "1111", tribeCardId: 0, amount: "-1299", status: "done", tribeTransactionType: "-", schemeId: "", merchantName: "Google", pan: "")]
        
        return CardTransactionResponse(response: transactions)
    }
}



