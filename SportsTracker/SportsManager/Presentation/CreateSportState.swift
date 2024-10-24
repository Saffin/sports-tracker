struct CreateSportState: Equatable {
    var name: String = ""
    var location: String = ""
    var date: String = ""
    var errorViewModel: ErrorViewModel? = nil
    var isConfirmationDialogPresented = false
    var isLoading = false
    var selectedHours = 0
    var selectedMinutes = 0
}

extension CreateSportState {
    var isSaveButtonDisabled: Bool {
        self.name.isEmpty || self.location.isEmpty || !self.durationIsEmpty
    }
    
    var durationIsEmpty: Bool {
        self.selectedHours > 0 || selectedMinutes > 0
    }
    
    var isErrorShown: Bool {
        self.errorViewModel != nil
    }
}
