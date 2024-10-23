final class CreateSportComposer {
    static func compose(coordinator: SportsListCoordinable?) -> AnyStore<SportsListStore> {
        let store = SportsListStore()
        let localManager = SportsManagerLocal.shared
        let remoteManager = SportsManagerRemote()
        let presenter = SportsListPresenter(
            onStateChange: { [weak store] state in
                store?.update(state: state)
            },
            coordinator: coordinator,
            localManager: localManager,
            remoteManager: remoteManager
        )
        
        store.actions = presenter
        
        return AnyStore(store: store)
    }
}
