import Foundation

struct SportsListState: Equatable {
    var isLoading: Bool = false
    var sports: [SportModel] = []
    var selectedType: SelectedStorage = .all
    var isCreateSheetPresented = false
    var errorViewModel: ErrorViewModel? = nil
}

extension SportsListState {
    var isErrorShown: Bool {
        self.errorViewModel != nil
    }
}
