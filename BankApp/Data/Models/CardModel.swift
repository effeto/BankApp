import Foundation

struct CardModel: Codable {
    let id: String?
    let cardLast4: String?
    let cardName: String?
    let isLocked: Bool?
    let isTerminated: Bool?
    let spent: Int?
    let limit: Int?
    let limitType: String?
    let cardHolder: CardHolderModel?
    let fundingSource: String?
    let issuedAt: String?
}

// MARK: - CardsResponse
struct CardsResponse: Codable {
    let cards: [CardModel]?
}
