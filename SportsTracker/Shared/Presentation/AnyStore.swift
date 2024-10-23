struct AnyStore<Store: AnyObject> {
    let store: Store
}

extension AnyStore: Hashable {
    static func == (lhs: AnyStore<Store>, rhs: AnyStore<Store>) -> Bool {
        lhs.store === rhs.store
    }

    func hash(into hasher: inout Hasher) {
        Unmanaged.passUnretained(store).toOpaque().hash(into: &hasher)
    }
}

protocol ViewStore {
    associatedtype Actions
    associatedtype State: Equatable

    var state: State { get }
    var actions: Actions? { get set }

    func update(state: State)
}
