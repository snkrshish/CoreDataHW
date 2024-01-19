import Foundation
import CoreData

@objc(Person)
final class Person: NSManagedObject {
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var avatar: Data?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest(entityName: "Person")
    }
}
