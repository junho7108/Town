import UIKit

protocol CoordinatorFinishDelegate {
    func coordinatorDidFinish()
    func removeChildCoordinator(_ child: Coordinator)
}

protocol Coordinator: AnyObject, CoordinatorFinishDelegate {
    var delegate: CoordinatorFinishDelegate? { get set }
    
    var presenter: VillageNavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func coordinatorDidFinish() {
        delegate?.coordinatorDidFinish()
    }
    
    func removeChildCoordinator(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
