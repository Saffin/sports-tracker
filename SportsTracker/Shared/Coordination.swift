import Foundation
import SwiftUI

final class SportsListComposer {
    static func compose(coordinator: SportsListCoordinable) -> AnyStore<SportsListStore> {
        let store = SportsListStore()
        let presenter = SportsListPresenter(
            onStateChange: { [weak store] state in
                store?.update(state: state)
            },
            coordinator: coordinator,
            localManager: SportsManagerLocal.shared,
            remoteManager: SportsManagerRemote()
        )
        
        store.actions = presenter
        
        return AnyStore(store: store)
    }
}

enum SportsTrackerDestination: Hashable {
    case addSport
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
        case .addSport:
            CreateSportView(
                store: CreateSportComposer
                    .compose(coordinator: self).store
            )
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
    func didSelectAddSport() {
        self.navigation.append(SportsTrackerDestination.addSport)
    }
    
    func didSelectSave() {
        self.dismiss()
    }
}
