import Foundation
import FirebaseFirestore

final class RemoteFirebaseRepository {
    private let database = Firestore.firestore()
    
    func save(_ sport: SportModel) async throws {
        do {
            try await database.collection("SportsRemote")
                .document(sport.id.uuidString)
                .setData(sport.remote)
        } catch {
            throw error
        }
    }
    
    func fetchAll() async throws -> [RemoteSportModel] {
        let snapshot = try await database.collection("SportsRemote")
            .getDocuments()
        
        return try snapshot.documents.compactMap { document -> RemoteSportModel in
            try document.data(as: RemoteSportModel.self)
        }
    }
    
    func delete(_ id: SportModel.ID) async throws {
        do {
            try await database.collection("SportsRemote")
                .document(id.uuidString)
                .delete()
        } catch {
            throw error
        }
    }
}
