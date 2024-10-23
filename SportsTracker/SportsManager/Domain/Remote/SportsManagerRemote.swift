import Foundation

final class SportsManagerRemote: SportsManagerProtocol {
    let repository = RemoteFirebaseRepository()
    
    func save(_ sport: SportModel) async throws {
       try await self.repository.save(sport)
    }
    
    func delete(_ id: SportModel.ID) async throws {
        try await self.repository.delete(id)
    }
    
    func getAll() async throws -> [SportModel] {
        let result = try await self.repository.fetchAll()
        return map(result)
    }
    
    func map(_ remoteSport: [RemoteSportModel]) -> [SportModel] {
        remoteSport.map { $0.local }
    }
}
