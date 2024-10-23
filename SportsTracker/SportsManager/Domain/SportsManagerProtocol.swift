protocol SportsManagerProtocol {
    func save(_ sport: SportModel) async throws
    func delete(_ id: SportModel.ID) async throws
    func getAll() async throws -> [SportModel]
}
