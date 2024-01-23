import Foundation

    //MARK: - Protocol
protocol UserPresenter {
    var users: [Person] { get }
    func fetchAllUsers()
    func saveName(name: String)
    func deleteUser(indexPath: IndexPath)
}


class MainPresenter: UserPresenter {


    // MARK: - Properties

    weak private var view: MainViewController?
    var coordinator: ProjectCoordinator?
    let coreDataManager: CoreDataProtocol
    var users = [Person]()

    // MARK: - Initalizer

    init(view: MainViewController, coordinator: ProjectCoordinator, coreDataManager: CoreDataProtocol) {
        self.view = view
        self.coordinator = coordinator
        self.coreDataManager = coreDataManager
    }

    // MARK: - Methods

    func fetchAllUsers() {
        users = coreDataManager.fetchAllUsers() ?? []
    }

    func saveName(name: String) {
        coreDataManager.saveName(name)
    }

    func deleteUser(indexPath: IndexPath) {
        coreDataManager.deleteUser(user: users[indexPath.row])
    }

    func showDetailController(data: Person) {
        coordinator?.moveToDetail(withData: data)
    }
}
