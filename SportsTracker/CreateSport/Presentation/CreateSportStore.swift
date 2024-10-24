import SwiftUI

final class CreateSportStore: ObservableObject, ViewStore {
    @Published var state: CreateSportState = .init()
    @Published var isErrorShown: Bool = false
    @Published var isConfirmationDialogPresented: Bool = false
    @Published var isSaveButtonDisabled = false
    @Published var selectedHours = 0
    @Published var selectedMinutes = 0
    

    var actions: CreateSportPresenter?
}

extension CreateSportStore {
    func update(state: CreateSportState) {
        DispatchQueue.main.async {
            self.state = state
            self.isErrorShown = state.isErrorShown
            self.isConfirmationDialogPresented = state.isConfirmationDialogPresented
            self.isSaveButtonDisabled = state.isSaveButtonDisabled
            self.selectedHours = state.selectedHours
            self.selectedMinutes = state.selectedMinutes
        }
    }
}
