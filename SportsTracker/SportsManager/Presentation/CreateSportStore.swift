import SwiftUI

final class CreateSportStore: ObservableObject, ViewStore {
    @Published var state: CreateSportState = .init()
    @Published var isErrorShown: Bool = false
    @Published var isConfirmationDialogPresented: Bool = false
    @Published var isPresented: Bool = false
    @Published var isSaveButtonDisabled = false

    var actions: CreateSportPresenter?
}

extension CreateSportStore {
    func update(state: CreateSportState) {
        DispatchQueue.main.async {
            self.state = state
            self.isErrorShown = state.isErrorShown
            self.isConfirmationDialogPresented = state.isConfirmationDialogPresented
            self.isSaveButtonDisabled = state.isSaveButtonDisabled
        }
    }
}
