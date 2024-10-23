import Foundation

struct SportsListState: Equatable {
    var isLoading: Bool = false
    var sports: [SportModel] = []
    var name: String = ""
    var location: String = ""
    var duration: String = ""
    var date: String = ""
    var isErrorShown = false
    var selectedType: Selected = .all
}
