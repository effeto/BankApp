
import Foundation

class APIService {
    static let shared = APIService()
    #if DEBUG
    let baseURL = "debugBase.com"
    #elseif RELEASE
    let baseURL = "releaseBase.com"
    #endif
}

enum APIServiceError: Error{
    case badUrl, requestError, decodingError, statusNotOK, tokenExpired
}

enum APIEndpoints {
    case getTotalBalance(teamID: Int)
    case getCards(teamID: Int)
    case getCardTransactions(teamID: Int)
    
    var url: String {
        switch self {
        case let .getTotalBalance(teamID: teamID):
            return "\(APIService.shared.baseURL)/cards/account/total-balance/\(teamID)"
        case let .getCards(teamID: teamID):
            return "\(APIService.shared.baseURL)/cards/\(teamID)"
        case let .getCardTransactions(teamID: teamID):
            return "\(APIService.shared.baseURL)/cards/transactions\(teamID)"
        }
    }
}

