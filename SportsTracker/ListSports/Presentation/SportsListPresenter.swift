import Foundation
import SwiftUI

protocol SportsListCoordinable {
    func didSelectDetail(_ sport: SportModel)
}

private enum SportsListPresenterEffect {
    case onLoadAll([SportModel])
    case onLoadLocal([SportModel])
    case onLoadRemote([SportModel])
    case onDelete
    case onError
    case onSelectionChange(SelectedStorage)
    case onCreateSportTap
    case onSheetDismiss
    case onSaveSuccess
}

final class SportsListPresenter {
    private let onStateChange: (SportsListState) -> Void
    private let coordinator: SportsListCoordinable?
    private var effect: ((SportsListPresenterEffect) -> Void)!
    private var state: SportsListState = .init()
    
    private let localManager: SportsManagerProtocol
    private let remoteManager: SportsManagerProtocol
    
    @Published private var sports = [SportModel]()
    
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
    func load(type: SelectedStorage = .all) async {
        var sports = [SportModel]()
        do {
            switch type {
            case .all:
                sports = try await self.loadSports()
            case .local:
                sports = try await self.loadLocalSports()
            case .remote:
                sports = try await self.loadRemoteSports()
            }
            effect(.onLoadAll(sports))
        } catch {
            effect(.onError)
        }
    }
    
    func didSelectAddSport() {
        effect(.onCreateSportTap)
    }
    
    func didSelectDetail(_ sport: SportModel) {
        self.coordinator?.didSelectDetail(sport)
    }
    
    func didSelectDelete(index: IndexSet) {
        index.map { sports[$0] }.forEach { sport in
            if sport.isLocal {
                Task {
                    do {
                        try await self.localManager.delete(sport.id)
                        effect(.onDelete)
                    } catch {
                        effect(.onError)
                    }
                }
            } else {
                Task {
                    do {
                        try await self.remoteManager.delete(sport.id)
                        effect(.onDelete)
                    } catch {
                        effect(.onError)
                    }
                }
            }
        }
        Task {
            await self.load()
        }
        
    }
    
    func didTapFilterSports(_ type: SelectedStorage) {
        switch type {
        case .all:
            effect(.onLoadAll(self.sports))
        case .local:
            effect(.onLoadLocal(self.sports.filter { $0.isLocal }))
        case .remote:
            effect(.onLoadRemote(self.sports.filter { $0.isRemote }))
        }
        effect(.onSelectionChange(type))
    }
    
    func didSelectLocal() async {
        effect(.onLoadLocal(self.sports.filter { $0.isLocal }))
    }
    
    func didSelectRemote() async {
        effect(.onLoadRemote(self.sports.filter { $0.isRemote }))
    }
    
    func onSheetDismiss() {
        effect(.onSheetDismiss)
    }
    
    func onSaveSuccessReload(storage: SelectedStorage = .all) async {
        await self.load(type: storage)
    }
}

private extension SportsListPresenter {
    func loadSports() async throws -> [SportModel] {
        let remote = try await self.loadRemoteSports()
        let local = try await self.loadLocalSports()
        return remote + local
    }
    
    func loadLocalSports() async throws -> [SportModel] {
        try await self.localManager.getAll()
    }
    
    func loadRemoteSports() async throws -> [SportModel] {
        try await self.remoteManager.getAll()
    }
}


// MARK: - Reducer
private extension SportsListPresenter {
    func reducer(effect: SportsListPresenterEffect) {
        switch effect {
        case .onLoadAll(let sports):
            self.sports = sports
            self.state.sports = sports
        case .onLoadLocal(let sports):
            self.state.sports = sports
        case .onLoadRemote(let sports):
            self.state.sports = sports
        case .onDelete:
            self.state.sports = sports
        case .onError:
            self.state.errorViewModel = makeGenericError()
        case .onSelectionChange(let type):
            self.state.selectedType = type
        case .onCreateSportTap:
            self.state.isCreateSheetPresented = true
        case .onSaveSuccess:
            self.state.isConfirmationDialogPresented = false
            self.state.isCreateSheetPresented = false
        case .onSheetDismiss:
            self.state.isConfirmationDialogPresented = false
            self.state.isCreateSheetPresented = false
        }
        self.onStateChange(state)
    }
    
    func makeGenericError() -> ErrorViewModel {
        ErrorViewModel(
            title: "Error",
            message: "Something went wrong",
            actions: [
                AlertActionViewModel(
                    title: "Repeat",
                    buttonRole: .cancel,
                    action: {
                        Task {
                            await self.load()
                        }
                    }
                )
            ]
        )
    }
}
