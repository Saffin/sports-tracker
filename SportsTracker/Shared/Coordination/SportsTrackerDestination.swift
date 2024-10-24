import Foundation
import SwiftUI

enum SportsTrackerDestination: Hashable {
    case detail(SportModel)
}

final class SportsTrackerCoordinator: ObservableObject {
    @Published var navigation = NavigationPath()
    
    private lazy var sportsTrackerStore = SportsListComposer.compose(coordinator: self)
    
    func start() -> some View {
        SportsListView(store: self.sportsTrackerStore.store)
    }
    
    @ViewBuilder
    func getView(for destination: SportsTrackerDestination) -> some View {
        switch destination {
        case .detail(let sport):
            SportDetailView(sport: sport)
        }
    }
    
    func dismiss() {
        if self.navigation.isEmpty {
            return
        }
        DispatchQueue.main.async {
            self.navigation.removeLast()
        }
    }
}

extension SportsTrackerCoordinator: SportsListCoordinable {
    func didSelectDetail(_ sport: SportModel) {
        self.navigation.append(SportsTrackerDestination.detail(sport))
    }
}

extension SportsTrackerCoordinator {
    func logIn() async {
        do {
            if !RemoteDatabaseAuth.shared.isSignedIn() {
                try await RemoteDatabaseAuth.shared.signInAnonymously()
            } else {
                debugPrint("Already signed")
            }
        } catch {
            debugPrint("Error signing in anonymously: \(error)")
        }
    }
}
