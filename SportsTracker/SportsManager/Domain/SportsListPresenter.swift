import Foundation

final class SportsListPresenter {
    let sportsManager: SportsManagerProtocol
    
    init(sportsManager: SportsManagerProtocol) {
        self.sportsManager = sportsManager
    }
    
    func getAllSports() async throws -> [SportModel] {
        try await sportsManager.getAll()
    }
    
    func deleteSport(_ sport: SportModel) async throws {
        try await sportsManager.delete(sport)
    }
    
    func saveSport(_ sport: SportModel) async throws {
        try await sportsManager.save(sport)
    }
}
