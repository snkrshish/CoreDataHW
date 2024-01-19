import Foundation

protocol CoreDataProtocol {
    var friends: [Person]? { get set }
    func fetchPerson()
    func addNewPerson(name: String, gender: String,  dateOfBirth: String)
    func deletePerson(_ index: Int)
    func updatePerson()
}
