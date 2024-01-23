import Foundation
import CoreData

final class CoreDataManager: CoreDataProtocol {

    // MARK: - Properties

    private let userFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "List_of_Person")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext

    // MARK: - Methods

    func saveName(_ name: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Person",
                                                                 in: managedObjectContext) else { return }
        let newUser = Person(entity: entityDescription, insertInto: managedObjectContext)
        newUser.name = name

        saveChanges()
    }

    func saveBirthDate(_ dateOfBirth: Date) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Person",
                                                                 in: managedObjectContext) else { return }
        let newUser = Person(entity: entityDescription, insertInto: managedObjectContext)
        newUser.dateOfBirth = dateOfBirth

        saveChanges()
    }

    func updateDetails(for user: Person,
                           avatarData avatar: Data?,
                           name: String?,
                           dateOfBirth: Date?,
                           gender: String?) {
        if let avatar = avatar {
            user.avatar = avatar
        }

        if let name = name {
            user.name = name
        }

        if let dateOfBirth = dateOfBirth {
            user.dateOfBirth = dateOfBirth
        }

        if let gender = gender {
            user.gender = gender
        }

        saveChanges()
    }

    func fetchAllUsers() -> [Person]? {
        do {
            let persons = try managedObjectContext.fetch(userFetchRequest) as? [Person]
            return persons
        } catch {
            print(error)
            return nil
        }
    }

    func deleteUser(user: Person) {
        managedObjectContext.delete(user)

        saveChanges()
    }

    // MARK: - Save changes method

    private func saveChanges() {
        do {
            try self.managedObjectContext.save()
        } catch {
            let error = error as NSError
            fatalError("Error \(error), \(error.userInfo)")
        }
    }
}
