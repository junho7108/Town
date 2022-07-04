import Foundation
import UIKit

final class LoginCoordinator: NSObject, Coordinator {
    var parentCoordinator: Coordinator?
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        guard let window = UIApplication.shared.windows.first else { return }
        presenter = VillageNavigationController()
      
        let repository = AuthRepositoryImpl()
        let usecase = AuthUsecase(repository: repository)
        let viewModel = LoginViewModel(dependencies: .init(usecase: usecase,
                                                           naverLoginManager: NaverLoginManager(),
                                                           appleLoginManager: AppleLoginManager(),
                                                           googleLoginManager: GoogleLoginManager(),
                                                           kakaoLoginManager: KakaoLoginManager()))
        
        let loginVC = LoginViewController(viewModel: viewModel)
        loginVC.hidesBottomBarWhenPushed = true
        loginVC.coordinator = self
        loginVC.coordinatorFinishDelegate = self
        
        window.rootViewController = presenter
        presenter.setViewControllers([loginVC], animated: false)
    }
    
    func pushSignUpScene(request: SignUpRequest) {
        let coordinator = SignUpMBTICoordinator(presenter: presenter)
        coordinator.request = request
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushMainScene() {
        let coordinator = MainTabBarCoordinator(presenter: presenter)
        coordinator.start()
    }
}

extension LoginCoordinator {
    func coordinatorDidFinish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
