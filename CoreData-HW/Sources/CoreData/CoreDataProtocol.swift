import Foundation

protocol CoreDataProtocol {
    func saveName(_ name: String)
    func saveBirthDate(_ birthDate: Date)
    func updateDetails(for user: Person,
                           avatarData avatar: Data?,
                           name: String?,
                           dateOfBirth: Date?,
                           gender: String?)
    func fetchAllUsers() -> [Person]?
    func deleteUser(user: Person)
}
