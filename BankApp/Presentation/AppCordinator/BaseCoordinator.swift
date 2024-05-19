import Foundation
import SwiftUI

final class BaseCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentSheetItem: DestinationFlowPage?
    @Published var fullCoverItem: DestinationFlowPage?
    
    func gotoRoot() {
        path.removeLast(path.count)
    }
        
    func initiateHome() {
        path.append(DestinationFlowPage.home)
    }
    
}

enum DestinationFlowPage: Hashable, Identifiable {
    static func == (lhs: DestinationFlowPage, rhs: DestinationFlowPage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case tabBar
    case home
    case homeWithdrawals(viewModel: HomeViewModel)
    case transactions
    case myCards
    case account
    
    var id: String {
        String(describing: self)
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .tabBar:
            hasher.combine("tabBar")
        case .home:
            hasher.combine("home")
        case .homeWithdrawals:
            hasher.combine("homeWithdrawals")
        case .transactions:
            hasher.combine("transactions")
        case .myCards:
            hasher.combine("myCards")
        case .account:
            hasher.combine("account")
        }
    }

}
