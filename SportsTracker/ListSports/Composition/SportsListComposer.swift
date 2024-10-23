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
