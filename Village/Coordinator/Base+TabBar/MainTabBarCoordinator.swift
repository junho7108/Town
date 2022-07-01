import Foundation
import UIKit

class MainTabBarCoordinator: NSObject, Coordinator {

    var parentCoordinator: Coordinator?
    
    var delegate: CoordinatorFinishDelegate?

    var presenter: VillageNavigationController

    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        self.presenter.navigationBar.isHidden = true
        self.childCoordinators = []
    }

    func start() {
        let mainTabBarVC = MainTabBarViewController()
        mainTabBarVC.coordinatorFinishDelegate = self
        mainTabBarVC.tabBarItems.forEach { tabBarItem in
            let coordinator = tabBarItem.coordinator(presenter: presenter)
            coordinator.delegate = self
            childCoordinators.append(coordinator)
        }
    
        presenter.viewControllers = [mainTabBarVC]
    }
}
