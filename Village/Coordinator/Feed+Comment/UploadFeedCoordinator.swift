import Foundation
import Alamofire

final class UploadFeedCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let repository = FeedRepositoryImpl(service: service)
        let usecase = FeedUsecase(repository: repository)
        let viewModel = UploadFeedViewModel(dependencies: .init(usecase: usecase))
        let uploadFeedVC = UploadFeedViewController(viewModel: viewModel)
        uploadFeedVC.hidesBottomBarWhenPushed = true
      
        uploadFeedVC.coordinator = self
        uploadFeedVC.coordinatorFinishDelegate = self
        presenter.pushViewController(uploadFeedVC, animated: true)
    }
    
    func editStart(feed: Feed) {
        let service = NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()])))
        let repository = FeedRepositoryImpl(service: service)
        let usecase = FeedUsecase(repository: repository)
        let viewModel = UploadFeedViewModel(dependencies: .init(feed: feed, usecase: usecase))
        let uploadFeedVC = UploadFeedViewController(viewModel: viewModel)
        uploadFeedVC.hidesBottomBarWhenPushed = true
        
        uploadFeedVC.coordinator = self
        uploadFeedVC.coordinatorFinishDelegate = self
      
        presenter.pushViewController(uploadFeedVC, animated: true)
    }
    
    func pushDetailFeedScene(feed: Feed) {
        let coordinator = DetailFeedCoordinator(feed: feed, presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
