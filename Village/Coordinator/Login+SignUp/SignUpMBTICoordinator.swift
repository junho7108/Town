import Foundation

final class SignUpMBTICoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    var request: SignUpRequest?
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        guard let request = request else { return }
        
        let viewModel = SignUpMBTIViewModel(dependencies: .init(signUpRequest: request))
        let selectMBTIVC = SignUpMBTIViewConroller(viewModel: viewModel)
        selectMBTIVC.coordinator = self
        selectMBTIVC.coordinatorFinishDelegate = self
        presenter.pushViewController(selectMBTIVC, animated: true)
    }
    
    func pushInputNicknameScene(request: SignUpRequest) {
        let coordinator = SignUpNicknameCoordinator(presenter: presenter)
        coordinator.parent = self
        coordinator.request = request
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushMBTISimpleTestScene() {
        let coordinator = FirstMBTISimpleTestCoordinator(presenter: presenter)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
