import SwiftUI

@main
struct AppContentView: App {
    @Environment(\.scenePhase)var scenePhase
    @ObservedObject var coordinator = BaseCoordinator()
    
    init() {
        AppTheme.navigationBarColors(background: .white, titleColor: .black, tintColor: .white)
        AppTheme.tabbarColors(background: .white, titleColorSelected: .systemBlue, titleColorUnSelected: .systemGray)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                ZStack {
                    appContent()
                        .sheet(item: $coordinator.presentSheetItem) { present in
                            ViewFactory.viewForDestination(present)
                        }
                        .fullScreenCover(item: $coordinator.fullCoverItem) { present in
                            ViewFactory.viewForDestination(present)
                        }
                    
                }
                .navigationDestination(for: DestinationFlowPage.self) { destination in
                    ViewFactory.viewForDestination(destination)
                }
            }
            .environmentObject(coordinator)
        }
        .onChange(of: scenePhase, {
            switch scenePhase {
            case .background:
                print("Background")
            case .inactive:
                print("Inactive")
            case .active:
                print("Active")
            @unknown default:
                print("Unknown")
            }
        })
    }
    
    @ViewBuilder func appContent() -> some View {
        ViewFactory.getTabBarView()
    }
}
