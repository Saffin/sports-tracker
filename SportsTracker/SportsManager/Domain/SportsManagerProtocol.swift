protocol SportsManagerProtocol {
    func save(_ sport: SportModel) async throws
    func delete(_ sport: SportModel) async throws
    func getAll() async throws -> [SportModel]
}
