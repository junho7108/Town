import Alamofire

final class UserProfileCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    private let user: User
    
    init(user: User, presenter: VillageNavigationController) {
        self.user = user
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let useacse = FeedUsecase(repository: FeedRepositoryImpl(service: service))
        let viewModel = UserProfileViewModel(dependencies: .init(user: user, usecase: useacse))
        let userProfileVC = UserProfileViewController(user: user, viewModel: viewModel)
        userProfileVC.coordinator = self
        userProfileVC.coordinatorFinishDelegate = self
        userProfileVC.hidesBottomBarWhenPushed = true
        
        presenter.pushViewController(userProfileVC, animated: true)
    }
    
    
    
}
