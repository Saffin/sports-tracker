import Foundation

struct SportModel: Identifiable {
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
    var remote: [String: Any] {
        [
            "id": self.id.uuidString,
            "name": self.name,
            "location": self.location,
            "duration": self.duration
        ]
    }
}
