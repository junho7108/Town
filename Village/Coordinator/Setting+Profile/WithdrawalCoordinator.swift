import Alamofire

class WithdrawalCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let repository = UserRepositoryImpl(service: service)
        let usecase = UserUsecase(repository: repository)
        let viewModel = WithdrawalViewModel(dependencies: .init(usecase: usecase))
        let withdrawalVC = WithdrawalViewController(viewModel: viewModel)
        withdrawalVC.coordinator = self
        withdrawalVC.coordinatorFinishDelegate = self
        withdrawalVC.hidesBottomBarWhenPushed = true
        
        presenter.pushViewController(withdrawalVC, animated: true)
    }
    
    func popToLoginScene() {
        let coordinator = LoginCoordinator(presenter: presenter)
        coordinator.start()
    }
}
