import Alamofire

final class HomeCoordinator: Coordinator {
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
        let userUsecase = UserUsecase(repository: repository)
        let viewModel = HomeViewModel(dependencies: .init(userUsecase: userUsecase))
        let homeVC = HomeViewController(vieWModel: viewModel)
        homeVC.coordinator = self
        homeVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(homeVC, animated: true)
    }
    
    func pushMoreCompetitionScene() {
        let coordinator = MoreCompetitionCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
