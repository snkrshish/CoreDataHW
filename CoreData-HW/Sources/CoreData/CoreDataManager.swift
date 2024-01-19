import Foundation
import CoreData

final class CoreDataManager: CoreDataProtocol {
    var friends: [Person]?
    

    static let shared = CoreDataManager()
    var person: [Person]?

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "List_of_person")

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Ошибка: \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()

    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private func saveContext() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Ошибка: \(nserror), \(nserror.localizedDescription)")
            }
        }
    }

    func fetchPerson() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

        do {
            person = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }

    func addNewPerson(name: String, gender: String, dateOfBirth: String) {
        let person = Person(context: context)
        person.name = name
        person.gender = gender
        person.dateOfBirth = dateOfBirth
        updatePerson()
    }

    func deletePerson(_ index: Int) {
        guard let person = person?[index] else { return }

        context.delete(person)
        updatePerson()
    }

    func updatePerson() {
        saveContext()
        fetchPerson()
    }
}
