import Foundation
import SwiftUI



class ViewFactory {
    @ViewBuilder static func viewForDestination(_ destination: DestinationFlowPage) -> some View {
        switch destination {
        case .tabBar:
            self.getTabBarView()
        case .home:
            EmptyView()
        case let .homeWithdrawals(viewModel: viewModel):
            self.presentWithdrawView(viewModel: viewModel)
        case .transactions:
            EmptyView()
        case .myCards:
            EmptyView()
        case .account:
            EmptyView()
        }
    }
    
    static func getTabBarView() -> some View {
        let view = TabBarView()
        return view
    }
    
    static func presentWithdrawView(viewModel: HomeViewModel) -> some View {
        let view = WithdrawView(viewModel: viewModel)
        return view
    }
}

