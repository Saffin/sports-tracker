import CoreData

@objc(ManagedSport)
final class ManagedSport: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var location: String
    @NSManaged var duration: String
}

extension ManagedSport {
    var local: SportModel {
        SportModel(
            id: self.id,
            name: self.name,
            location: self.location,
            duration: self.duration,
            storage: .local
        )
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
