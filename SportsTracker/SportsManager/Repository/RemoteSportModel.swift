import Foundation

struct RemoteSportModel: Codable {
    let id: String
    let name: String
    let location: String
    let duration: String
}

extension RemoteSportModel {
    var local: SportModel {
        SportModel(
            id: UUID(uuidString: self.id) ?? UUID(),
            name: self.name,
            location: self.location,
            duration: self.duration,
            storage: .remote
        )
    }
}
