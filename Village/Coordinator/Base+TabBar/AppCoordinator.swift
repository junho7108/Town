import Foundation
import UIKit

final class AppCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.presenter = VillageNavigationController()
        self.childCoordinators = []
    }
    
    func start() {
        window.rootViewController = presenter
        let coordinator = LaunchCoordinator(presenter: presenter)
        coordinator.start()
        window.makeKeyAndVisible()
    }
}
