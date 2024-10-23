//
//  SportsManagerLocal.swift
//  SportsTracker
//
//  Created by David Šafarik on 23.10.2024.
//


import Foundation
import CoreData

final class SportsManagerLocal: SportsManagerProtocol {
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController().container.viewContext) {
        self.viewContext = context
    }
    
    func save(_ sport: SportModel) async throws {
        let sportCD = sport.toManagedSport(context: self.viewContext)
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

extension SportModel {
    func toManagedSport(context: NSManagedObjectContext) -> ManagedSport {
        let sportCD = ManagedSport(context: context)
        sportCD.id = UUID()
        sportCD.name = self.name
        sportCD.location = self.location
        sportCD.duration = self.duration
        return sportCD
    }
}
