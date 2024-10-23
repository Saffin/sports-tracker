import Foundation

final class SportsManagerRemote: SportsManagerProtocol {
    let repository = RemoteFirebaseRepository()
    
    func save(_ sport: SportModel) async throws {
       try await self.repository.save(sport)
    }
    
    func delete(_ sport: SportModel) async throws {
//        try await self.repository.delete(sport)
    }
    
    func getAll() async throws -> [SportModel] {
        []
    }
    
    func map(_ remoteSport: [RemoteSportModel]) -> [SportModel] {
        remoteSport.map { $0.local }
    }
}
