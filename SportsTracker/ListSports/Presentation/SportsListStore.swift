import Foundation

final class SportsListStore: ObservableObject, ViewStore {
    @Published var state: SportsListState = .init()
    @Published var selectedType: SelectedStorage = .all
    @Published var isCreateSheetPresented = false
    @Published var isErrorShown = false
    @Published var alert: ErrorViewModel?
    var actions: SportsListPresenter?
}

extension SportsListStore {
    func update(state: SportsListState) {
        DispatchQueue.main.async {
            self.state = state
            self.selectedType = state.selectedType
            self.isCreateSheetPresented = state.isCreateSheetPresented
            self.isErrorShown = state.isErrorShown
            self.alert = state.errorViewModel
        }
    }
}
