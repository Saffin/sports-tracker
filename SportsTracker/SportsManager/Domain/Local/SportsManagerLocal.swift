import Foundation
import CoreData

final class SportsManagerLocal: SportsManagerProtocol {
    static let shared = SportsManagerLocal()
    private let viewContext: NSManagedObjectContext
    
    private init(context: NSManagedObjectContext = PersistenceController().container.viewContext) {
        self.viewContext = context
    }
    
    func save(_ sport: SportModel) async throws {
        let _ = sport.toManagedSport(context: self.viewContext)
        try self.viewContext.save()
    }
    
    func getAll() async throws -> [SportModel] {
        let fetchRequest: NSFetchRequest<ManagedSport> = ManagedSport.fetchRequest() as! NSFetchRequest<ManagedSport>
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let sports = try self.viewContext.fetch(fetchRequest)
            return sports.map { $0.local }
        } catch {
            throw error
        }
    }
    
    func delete(_ sport: SportModel) async throws {
        //
    }
}