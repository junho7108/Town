import Alamofire
import KakaoSDKUser

final class CommentCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    private let comment: Comment
    
    init(comment: Comment, presenter: VillageNavigationController) {
        self.comment = comment
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let userRepository = UserRepositoryImpl(service: service)
        let userUsecase = UserUsecase(repository: userRepository)
        let feedRepository = FeedRepositoryImpl(service: service)
        let feedUsecase = FeedUsecase(repository: feedRepository)
        let viewModel = CommentViewModel(dependencies: .init(comment: comment, userUsecase: userUsecase, feedUsecase: feedUsecase))
        let commentVC = CommentViewController(viewModel: viewModel)
        commentVC.coordinator = self
        commentVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(commentVC, animated: true)
    }
    
    func pushUserProfileScene(user: User) {
//        let coordinator = UserProfileCoordinator(user: user, presenter: presenter)
//        childCoordinators.append(coordinator)
//        
//        coordinator.start()
    }
}
