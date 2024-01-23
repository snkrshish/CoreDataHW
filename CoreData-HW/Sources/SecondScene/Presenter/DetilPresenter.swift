import Foundation

// MARK: - Protocols

protocol DetailUserInteractor {
    var user: Person? { get set }
    var view: DetailViewController? { get set }
    func updateUser(user: Person,
                    avatar: Data?,
                    name: String?,
                    birthDate: Date?,
                    gender: String?)
}

// MARK: - DetailPresenter

class DetailPresenter: DetailUserInteractor {

    // MARK: - Properties

    var user: Person?
    weak var view: DetailViewController?
    let coreDataManager: CoreDataProtocol

    // MARK: - Initializers

    required init(view: DetailViewController, user: Person, coreDataManager: CoreDataProtocol) {
        self.view = view
        self.user = user
        self.coreDataManager = coreDataManager
    }

    // MARK: - Methods

    func updateUser(user: Person, avatar: Data?, name: String?, birthDate: Date?, gender: String?) {
        coreDataManager.updateDetails(for: user, avatarData: avatar, name: name, dateOfBirth: birthDate, gender: gender)
    }
}
