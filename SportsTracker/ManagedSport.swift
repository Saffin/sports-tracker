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
            duration: self.duration
        )
    }
}

extension SportModel {
    var coreData: ManagedSport {
        let managedSport = ManagedSport()
        managedSport.id = self.id
        managedSport.name = self.name
        managedSport.location = self.location
        managedSport.duration = self.duration
        return managedSport
    }
}
