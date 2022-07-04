final class SignUpCompleteCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let signupCompleteVC = SignUpCompleteViewController()
        signupCompleteVC.coordinator = self
        signupCompleteVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(signupCompleteVC, animated: true)
    }
    
    func pushMainScene() {
        let coordinator = MainTabBarCoordinator(presenter: presenter)
        coordinator.start()
    }
}
