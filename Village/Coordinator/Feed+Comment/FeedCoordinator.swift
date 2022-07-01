import Foundation
import UIKit
import Alamofire
import KakaoSDKUser

class FeedCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    private let showType: FeedShowType
    
    init(showType: FeedShowType, presenter: VillageNavigationController) {
        self.showType = showType
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let feedRepository = FeedRepositoryImpl(service: service)
        let feedUsecase = FeedUsecase(repository: feedRepository)
        let userRepository = UserRepositoryImpl(service: service)
        let userUsecase = UserUsecase(repository: userRepository)
        let viewModel = FeedViewModel(dependencies: .init(showType: showType, feedUsecase: feedUsecase, userUsecase: userUsecase))
        let villageVC = FeedViewController(viewModel: viewModel)
        villageVC.hidesBottomBarWhenPushed = showType != .showAllFeeds
        villageVC.coordinator = self
        villageVC.coordinatorFinishDelegate = self
        presenter.pushViewController(villageVC, animated: true)
    }
    
    func pushCommentScene(feed: Feed, scrollToComment: Bool) {
        let coordinator = DetailFeedCoordinator(feed: feed, presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.parent = self
        coordinator.feed = feed
        
        if scrollToComment {
            coordinator.startScrollToComment()
        } else {
            coordinator.start()
        }
    }
 
    func pushUploadFeedScene() {
        let coordinator = UploadFeedCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushMoveVillageScene() {
        let coordinator = MoveVillageCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushDeclarationScene() {
        let coordinator = DeclarationCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushEditFeedScene(feed: Feed) {
        let coordinator = UploadFeedCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.editStart(feed: feed)
    }
    
    func pushUserProfileScene(user: User) {
//        let coordinator = UserProfileCoordinator(user: user, presenter: presenter)
//        childCoordinators.append(coordinator)
//        coordinator.start()
    }
}
