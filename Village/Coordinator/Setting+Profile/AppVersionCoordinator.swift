class AppVersionCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let appVersionVC = AppVersionViewController()
        appVersionVC.coordinator = self
        appVersionVC.coordinatorFinishDelegate = self
        appVersionVC.hidesBottomBarWhenPushed = true
        
        presenter.pushViewController(appVersionVC, animated: true)
    }
}
