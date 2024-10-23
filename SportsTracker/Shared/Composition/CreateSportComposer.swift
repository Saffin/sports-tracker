final class CreateSportComposer {
    static func compose() -> AnyStore<CreateSportStore> {
        let store = CreateSportStore()
        let presenter = CreateSportPresenter(
            onStateChange: { [weak store] state in
                store?.update(state: state)
            },
            localManager: SportsManagerLocal.shared,
            remoteManager: SportsManagerRemote()
        )
        
        store.actions = presenter
        
        return AnyStore(store: store)
    }
}
