import Foundation
import SwiftUI

private enum SportsListPresenterEffect {
    case onLoadAll([SportModel])
    case onLoadLocal([SportModel])
    case onLoadRemote([SportModel])
    case onError
    case onErrorClose
    case onSelectionChange(SelectedStorage)
    case onCreateSportTap
    case onSheetDismiss
    case onSaveSuccess
    case onDelete
    case showLoading
    case hideLoading
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
    func load() async {
        effect(.showLoading)
        do {
            let sports = try await self.loadSports()
            self.sports = sports
            effect(.onLoadAll(showFilteredSports()))
        } catch {
            effect(.onError)
        }
        effect(.hideLoading)
    }
    
    func didSelectAddSport() {
        effect(.onCreateSportTap)
    }
    
    func didSelectDetail(_ sport: SportModel) {
        self.coordinator?.didSelectDetail(sport)
    }
    
    func didSelectDelete(index: IndexSet) {
        index.map { sports[$0] }.forEach { sport in
            Task {
                await self.delete(id: sport)
                await self.load()
            }
        }
    }
    
    func delete(id: SportModel) async {
        do {
            id.isLocal ? try await self.localManager.delete(id.id) : try await self.remoteManager.delete(id.id)
        } catch {
            effect(.onError)
        }
    }
    
    func didTapFilterSports(_ type: SelectedStorage) async {
        switch type {
        case .all:
            effect(.onLoadAll(self.sports))
        case .local:
            let filtered = self.sports.filter { $0.isLocal }
            effect(.onLoadLocal(filtered))
        case .remote:
            let filtered = self.sports.filter { $0.isRemote }
            effect(.onLoadRemote(filtered))
        }
        effect(.onSelectionChange(type))
    }
    
    func onSheetDismiss() {
        Task {
            await self.load()
            effect(.onSheetDismiss)
        }
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
    
    func showFilteredSports() -> [SportModel] {
        switch self.state.selectedType {
        case .all:
            return self.sports
        case .local:
            return self.sports.filter { $0.isLocal }
        case .remote:
            return self.sports.filter { $0.isRemote }
        }
    }
}

// MARK: - Reducer
private extension SportsListPresenter {
    func reducer(effect: SportsListPresenterEffect) {
        switch effect {
        case .onLoadAll(let sports):
            self.state.sports = sports
        case .onLoadLocal(let sports):
            self.state.sports = sports.filter { $0.isLocal }
        case .onLoadRemote(let sports):
            self.state.sports = sports.filter { $0.isRemote }
        case .onDelete:
            self.state.sports = []
        case .onError:
            self.state.errorViewModel = makeGenericError()
        case .onErrorClose:
            self.state.errorViewModel = nil
        case .onSelectionChange(let type):
            self.state.selectedType = type
        case .onCreateSportTap:
            self.state.isCreateSheetPresented = true
        case .onSaveSuccess:
            self.state.isCreateSheetPresented = false
        case .onSheetDismiss:
            self.state.isCreateSheetPresented = false
        case .showLoading:
            self.state.isLoading = true
        case .hideLoading:
            self.state.isLoading = false
        }
        self.onStateChange(state)
    }
    
    func makeGenericError() -> ErrorViewModel {
        ErrorViewModel(
            title: "Error",
            message: "Something went wrong"
        )
    }
}
