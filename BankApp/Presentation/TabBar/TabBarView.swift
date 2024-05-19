import SwiftUI

struct TabBarView: View {
    // MARK: - Variables
    @EnvironmentObject var coordinator: BaseCoordinator
//    @StateObject var viewModel: HomeViewModel
    @State var selectedView = 0
    
    
    // MARK: - Body
    var body: some View {
        content()
            .onAppear {
                UITabBar.appearance().backgroundColor = .lightText
            }
        
    }
    
    // MARK: - Tab Bar
    @ViewBuilder private func content() -> some View {
        ZStack {
            TabView(selection: $selectedView) {
                
                self.homeTabView()
                    .tabItem {
                        Label("Home", image: selectedView == 0 ? .icHomeFill : .icHome)
                    }
                    .tag(0)
                ComingSoonView(title: "Transactions")
                    .tabItem {
                        Label("Transactions", image: selectedView == 1 ? .icTransactionsFill : .icTransactions)
                    }
                    .tag(1)
                
                ComingSoonView(title: "My Cards")
                    .tabItem {
                        Label("My Cards", image: selectedView == 2 ? .icMyCardsFill : .icMyCard)
                    }
                    .tag(2)
                
                ComingSoonView(title: "Account")
                    .tabItem {
                        Label("Account", image: selectedView == 3 ? .icAccountFill : .icAccount)
                    }
                    .tag(3)
                
            }.tint(.blue)
                .navigationBarBackButtonHidden(true)
        }
    }
    
    
    // MARK: - Home Tab
    @ViewBuilder
    private func homeTabView() -> some View {
        HomeView(viewModel: HomeViewModel())
    }
}
