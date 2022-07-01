import Foundation
import Alamofire

class DetailFeedCoordinator: NSObject, Coordinator {
    
    var parent: Coordinator?
    
    var feed: Feed
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(feed: Feed, presenter: VillageNavigationController) {
        self.feed = feed
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let feedRepository = FeedRepositoryImpl(service: service)
        let userRepository = UserRepositoryImpl(service: service)
        let feedUsecase = FeedUsecase(repository: feedRepository)
        let userUsecase = UserUsecase(repository: userRepository)
        
        let viewModel = DetailFeedViewModel(dependencies: .init(feed: feed, feedUsecase: feedUsecase, userUsercase: userUsecase))
        let commentVC = DetailFeedViewController(viewModel: viewModel, scrollToComment: false)
        commentVC.hidesBottomBarWhenPushed = true
        commentVC.coordinator = self
        commentVC.coordinatorFinishDelegate = self

        var viewControllers: [UIViewController] = []
        for elem in presenter.viewControllers {
            if let _ = elem as? UploadFeedViewController {
            } else if let _ = elem as? DetailFeedViewController {
            } else {
                viewControllers.append(elem)
            }
        }
        
        viewControllers.append(commentVC)
        presenter.setViewControllers(viewControllers, animated: true)
    }
    
    func startScrollToComment() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let feedRepository = FeedRepositoryImpl(service: service)
        let userRepository = UserRepositoryImpl(service: service)
        let feedUsecase = FeedUsecase(repository: feedRepository)
        let userUsecase = UserUsecase(repository: userRepository)
        
        let viewModel = DetailFeedViewModel(dependencies: .init(feed: feed, feedUsecase: feedUsecase, userUsercase: userUsecase))
        let commentVC = DetailFeedViewController(viewModel: viewModel, scrollToComment: true)
        commentVC.hidesBottomBarWhenPushed = true
        commentVC.coordinator = self
        commentVC.coordinatorFinishDelegate = self
        
        commentVC.navigationItem.backButtonTitle = ""
        presenter.pushViewController(commentVC, animated: true)
    }
    
    func pushDeclarationScene() {
        let coordinator = DeclarationCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushCommentScene(comment: Comment) {
        let coordinator = CommentCoordinator(comment: comment, presenter: presenter)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
    
    func pushUserProfileScene(user: User) {
//        let coordinator = UserProfileCoordinator(user: user, presenter: presenter)
//        childCoordinators.append(coordinator)
//
//        coordinator.start()
    }
    
    func pushEditFeedScene(feed: Feed) {
        let coordinator = UploadFeedCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        
        coordinator.editStart(feed: feed)
    }
}
