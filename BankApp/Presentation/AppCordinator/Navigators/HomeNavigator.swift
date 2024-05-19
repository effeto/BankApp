import Foundation

protocol HomeNavigator {
    func actionHomeWithdrawals(viewModel: HomeViewModel)
}

extension BaseCoordinator: HomeNavigator {
    func actionHomeWithdrawals(viewModel: HomeViewModel) {
        presentSheetItem = .homeWithdrawals(viewModel: viewModel)
    }
}
