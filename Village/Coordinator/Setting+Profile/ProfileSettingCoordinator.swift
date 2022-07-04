import Foundation
import UIKit
import Alamofire

final class ProfileSettingCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let repository = UserRepositoryImpl(service: NetworkService(with: Session(interceptor: Interceptor(interceptors: [AuthorizationInterceptor()]))))
        let usecase = UserUsecase(repository: repository)
        let viewModel = ProfileViewModel(dependencies: .init(usecase: usecase))
        let profileVC = ProfileSettingViewController(viewModel: viewModel)
        profileVC.coordinator = self
        profileVC.coordinatorFinishDelegate = self
        presenter.pushViewController(profileVC, animated: true)
    }
    
    func pushEditProfileScene(user: User) {
        let coordinator = EditProfileCoordinator(user: user, presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushFeedScene(showType: FeedShowType) {
        let coordinator = FeedCoordinator(showType: showType, presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushWithdrawalScene() {
        let coordinator = WithdrawalCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushAppSettingScene() {
        let coordinator = AppVersionCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func logout() {
        let coordinator = LoginCoordinator(presenter: presenter)
        coordinator.start()
    }
}
