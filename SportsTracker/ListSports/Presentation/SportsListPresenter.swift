import Foundation

protocol SportsListCoordinable {
    func didSelectAddSport()
}

private enum SportsListPresenterEffect {
    case onLoadAll([SportModel])
    case onLoadLocal([SportModel])
    case onLoadRemote([SportModel])
    case onDelete
    case onError
    case onNameChange(String)
    case onLocationChange(String)
    case onDurationChange(String)
    case onSelectionChange(Selected)
    }

final class SportsListPresenter {
    private let onStateChange: (SportsListState) -> Void
    private let coordinator: SportsListCoordinable?
    private var effect: ((SportsListPresenterEffect) -> Void)!
    private var state: SportsListState = .init()
    @Published private var sports = [SportModel]() {
        didSet {
            print(self.$sports)
        }
    }
    let localManager: SportsManagerProtocol
    let remoteManager: SportsManagerProtocol
    
    init(
        onStateChange: @escaping (SportsListState) -> Void,
        coordinator: SportsListCoordinable?,
        localManager: SportsManagerProtocol,
        remoteManager: SportsManagerProtocol
    ) {
        self.onStateChange = onStateChange
        self.coordinator = coordinator
        self.localManager = localManager
        self.remoteManager = remoteManager
        self.effect = { [weak self] effect in
            self?.reducer(effect: effect)
        }
    }
}

extension SportsListPresenter {
    func onAppear() async {
        do {
            let sports = try await self.loadSports()
            effect(.onLoadAll(sports))
        } catch {
            effect(.onError)
        }
    }
    
    func didSelectAddSport() {
        self.coordinator?.didSelectAddSport()
    }
    
    func didSelectDelete() {
        
    }
    
    func didTapFilterSports(_ type: Selected) {
        switch type {
        case .all:
            effect(.onLoadAll(self.sports))
        case .local:
            effect(.onLoadLocal(self.sports.filter { $0.isLocal }))
        case .remote:
            effect(.onLoadRemote(self.sports.filter { $0.isRemote }))
        }
    }
    
    func didSelectLocal() async {
        effect(.onLoadLocal(self.sports.filter { $0.isLocal }))
    }
    
    func didSelectRemote() async {
        effect(.onLoadRemote(self.sports.filter { $0.isRemote }))
    }
    
    func onNameChange(_ text: String) {
        effect(.onNameChange(text))
    }
    
    func onLocationChange(_ text: String) {
        effect(.onLocationChange(text))
    }
    
    func onDurationChange(_ text: String) {
        effect(.onDurationChange(text))
    }
    
    func onSave(storage: SportModel.Storage) async throws {
        switch storage {
        case .local:
            let sport = SportModel(
                id: UUID(),
                name: state.name,
                location: state.location,
                duration: state.duration,
                storage: .local
            )
            try await self.localManager.save(sport)
        case .remote:
            let sport = SportModel(
                id: UUID(),
                name: state.name,
                location: state.location,
                duration: state.duration,
                storage: .remote
            )
            try await self.remoteManager.save(sport)
        }
    }
}

private extension SportsListPresenter {
    func loadSports() async throws -> [SportModel] {
        let remote = try await self.remoteManager.getAll()
        let local = try await self.localManager.getAll()
        return remote + local
    }
}

private extension SportsListPresenter {
    func reducer(effect: SportsListPresenterEffect) {
        switch effect {
        case .onLoadAll(let sports):
            self.sports = sports
            self.state.sports = sports
        case .onLoadLocal(let sports):
            self.sports = sports
            self.state.sports = sports
        case .onLoadRemote(let sports):
            self.sports = sports
            self.state.sports = sports
        case .onDelete:
            self.state.sports = sports
        case .onError:
            self.state.sports = []
        case .onNameChange(let text):
            self.state.name = text
        case .onLocationChange(let text):
            self.state.location = text
        case .onDurationChange(let text):
            self.state.duration = text
        case .onSelectionChange(let type):
            self.state.selectedType = type
        }
        onStateChange(state)
    }
}
