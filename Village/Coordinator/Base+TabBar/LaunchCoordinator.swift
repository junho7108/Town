final class LaunchCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let repository = AuthRepositoryImpl()
        let usecase = AuthUsecase(repository: repository)
        let viewModel = LaunchViewModel(dependencies: .init(usecase: usecase))
        let launchVC = LaunchViewController(viewModel: viewModel)
        
        launchVC.coordinator = self
        launchVC.coordinatorFinishDelegate = self
        presenter.pushViewController(launchVC, animated: false)
    }
    
    func pushLoginScene() {
        let loginCoordinator = LoginCoordinator(presenter: presenter)
        loginCoordinator.start()
    }
    
    func pushMainScene() {
        let mainScene = MainTabBarCoordinator(presenter: presenter)
        mainScene.start()
    }
}
