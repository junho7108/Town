import Alamofire

class MoveVillageCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let userRepository = UserRepositoryImpl(service: service)
        let userUsecase = UserUsecase(repository: userRepository)
                                     
        let viewModel = MoveVillageViewModel(dependencies: .init(userUsecase: userUsecase))
        let moveVillageVC = MoveVillageViewController(viewModel: viewModel)
        moveVillageVC.coordinator = self
        moveVillageVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(moveVillageVC, animated: true)
    }
    
    
}
