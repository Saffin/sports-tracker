import Foundation
import SwiftUI

private enum CreateSportPresenterEffect {
    case onSaveSuccess
    case onSaveButtonTap
    case onSaveFailure
    case onNameChange(String)
    case onLocationChange(String)
    case onHoursChange(Int)
    case onMinutesChange(Int)
    case showLoading
    case hideLoading
}

final class CreateSportPresenter {
    private var onStateChange: (CreateSportState) -> Void
    private var effect: ((CreateSportPresenterEffect) -> Void)!
    private var state: CreateSportState = .init()
    private let localManager: SportsManagerProtocol
    private let remoteManager: SportsManagerProtocol
    
    
    init(
        onStateChange: @escaping (CreateSportState) -> Void,
        localManager: SportsManagerProtocol,
        remoteManager: SportsManagerProtocol
    ) {
        self.onStateChange = onStateChange
        self.localManager = localManager
        self.remoteManager = remoteManager
        self.effect = { [weak self] effect in
            self?.reducer(effect: effect)
        }
    }
}

extension CreateSportPresenter {
    func didTapSaveButton() {
        effect(.onSaveButtonTap)
    }
    
    func didTapSave(
        storage: SportModel.Storage,
        completion: @escaping () -> Void
    ) async throws {
        do {
            switch storage {
            case .local:
                try await self.saveLocal()
            case .remote:
                try await self.saveRemote()
            }
            effect(.onSaveSuccess)
        } catch {
            effect(.onSaveFailure)
        }
        completion()
    }
    
    func onNameChange(_ text: String) {
        effect(.onNameChange(text))
    }
    
    func onLocationChange(_ text: String) {
        effect(.onLocationChange(text))
    }
    
    func onHoursChange(_ value: Int) {
        effect(.onHoursChange(value))
    }
    
    func onMinutesChange(_ value: Int) {
        effect(.onMinutesChange(value))
    }
}

private extension CreateSportPresenter {
    func saveLocal() async throws {
        try await self.localManager.save(self.makeSport(storage: .local))
    }
    
    func saveRemote() async throws {
        try await self.remoteManager.save(self.makeSport(storage: .remote))
    }
    
    func makeSport(storage: SportModel.Storage) -> SportModel {
        SportModel(
            id: UUID(),
            name: state.name,
            location: state.location,
            duration: self.makeDuration(),
            storage: storage
        )
    }
    
    func clearSport() {
        self.state.name = ""
        self.state.location = ""
        self.state.selectedHours = 0
        self.state.selectedMinutes = 0
    }
    
    func makeDuration() -> String {
        let hours = self.state.selectedHours
        let minutes = self.state.selectedMinutes
        
        if hours == 0 {
            return "\(minutes) minutes"
        } else {
            return "\(hours) hours \(minutes) minutes"
        }
    }
    
    func makeGenericError() -> ErrorViewModel {
        ErrorViewModel(
            title: "Error",
            message: "Something went wrong"
        )
    }
}

private extension CreateSportPresenter {
    func reducer(effect: CreateSportPresenterEffect) {
        switch effect {
        case .onSaveButtonTap:
            self.state.isConfirmationDialogPresented = true
        case .onSaveSuccess:
            self.clearSport()
            self.state.isConfirmationDialogPresented = false
        case .onSaveFailure:
            self.state.errorViewModel = self.makeGenericError()
        case .onNameChange(let text):
            self.state.name = text
        case .onLocationChange(let text):
            self.state.location = text
        case .onHoursChange(let text):
            self.state.selectedHours = text
        case .onMinutesChange(let text):
            self.state.selectedMinutes = text
        case .showLoading:
            self.state.isLoading = true
        case .hideLoading:
            self.state.isLoading = false
        }
        self.onStateChange(state)
    }
}
