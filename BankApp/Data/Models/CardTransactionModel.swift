import Foundation

struct CardTransactionModel: Codable {
    let id: String?
    let tribeTransactionId: String?
    let tribeCardId: Int?
    let amount: String?
    let status: String?
    let tribeTransactionType: String?
    let schemeId: String?
    let merchantName: String?
    let pan: String?
}

struct CardTransactionResponse: Codable {
    let response: [CardTransactionModel]?
}
