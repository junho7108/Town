class SignUpProfileCoordinator: Coordinator {
    
    var parent: Coordinator?
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    var request: SignUpRequest?
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        guard let request = request else { return }
        
        let repository = AuthRepositoryImpl()
        let usecase = AuthUsecase(repository: repository)
        let viewModel = SignUpProfileViewModel(dependencies: .init(usecase: usecase,
                                                                   request: request))
        
        let signUpProfileVC = SignUpProfileViewController(viewModel: viewModel)
        signUpProfileVC.coordinator = self
        signUpProfileVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(signUpProfileVC, animated: true)
    }
    
    func pushSignUpCompleteScene() {
        let coordinator = SignUpCompleteCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
