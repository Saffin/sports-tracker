import Foundation

struct SportModel: Identifiable, Equatable {
    enum Storage {
        case local
        case remote
    }
    
    let id: UUID
    let name: String
    let location: String
    let duration: String
    let storage: Storage
}

extension SportModel {
    var isLocal: Bool {
        self.storage == .local
    }
    
    var isRemote: Bool {
        self.storage == .remote
    }
    
    var remote: [String: Any] {
        [
            "id": self.id.uuidString,
            "name": self.name,
            "location": self.location,
            "duration": self.duration
        ]
    }
}
