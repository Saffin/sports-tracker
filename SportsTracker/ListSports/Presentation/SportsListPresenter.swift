import Foundation
import SwiftUI

private enum SportsListPresenterEffect {
    case onLoadAll([SportModel])
    case onLoadLocal([SportModel])
    case onLoadRemote([SportModel])
    case onError
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
            effect(.onLoadAll(sports))
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
        effect(.showLoading)
        index.map { sports[$0] }.forEach { sport in
            if sport.isLocal {
                Task {
                    do {
                        try await self.localManager.delete(sport.id)
                    } catch {
                        effect(.onError)
                    }
                }
            } else {
                Task {
                    do {
                        try await self.remoteManager.delete(sport.id)
                    } catch {
                        effect(.onError)
                    }
                }
            }
        }
        Task {
            await self.reloadData()
        }
        effect(.hideLoading)
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
        Task {
            await self.reloadData()
            effect(.onSheetDismiss)
        }
    }
    
    func reloadData() async {
        do {
            let sports = try await self.loadSports()
            switch self.state.selectedType {
            case .all:
                effect(.onLoadAll(sports))
            case .local:
                effect(.onLoadLocal(sports.filter { $0.isLocal }))
            case .remote:
                effect(.onLoadRemote(sports.filter { $0.isRemote }))
            }
        } catch {
            effect(.onError)
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
