struct CreateSportState: Equatable {
    var name: String = ""
    var location: String = ""
    var duration: String = ""
    var date: String = ""
    var errorViewModel: ErrorViewModel? = nil
    var isConfirmationDialogPresented = false
    var isLoading = false
}

extension CreateSportState {
    var isSaveButtonDisabled: Bool {
        self.name.isEmpty || self.location.isEmpty || self.duration.isEmpty
    }
    
    var isErrorShown: Bool {
        self.errorViewModel != nil
    }
}
