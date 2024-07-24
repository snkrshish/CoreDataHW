import UIKit

// MARK: - Protocols

protocol CoordinatorRoot: AnyObject {
    func start(with navigationController: UINavigationController)
}



// MARK: - ProjectCoordinator

class ProjectCoordinator: CoordinatorRoot {

    // MARK: - Properties


    weak var navigationController: UINavigationController?
    private var factory: FactoryPattern

    // MARK: - Initializers

    init(factory: FactoryPattern) {
        self.factory = factory
    }

    // MARK: - Methods

    func start(with navigationController: UINavigationController) {
        let viewController = factory.makeMainViewController(coordinator: self)
        self.navigationController = navigationController
        navigationController.pushViewController(viewController, animated: false)
    }


    func moveToDetail(withData data: Person){
        let viewController = factory.makeDetailViewController(coordinator: self, data: data)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
