import Foundation

final class SignUpNicknameCoordinator: Coordinator {
    
    var parent: Coordinator?
    
    var delegate: CoordinatorFinishDelegate?

    var presenter: VillageNavigationController

    var childCoordinators: [Coordinator]
    
    var request: SignUpRequest?

    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        guard let request = request,
            let mbti = request.mbtiType else { return }
        
        let repository = AuthRepositoryImpl()
        let usecase = AuthUsecase(repository: repository)
        let viewModel = SignUpNicknameViewModel(dependencies: .init(usecase: usecase,
                                                                    request: request))
        let signUpNicknameVC = SignUpNicknameViewController(mbti: mbti, viewModel: viewModel)
        signUpNicknameVC.coordinator = self
        signUpNicknameVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(signUpNicknameVC, animated: true)
    }
    
    func pushSignUpProfileScene(request: SignUpRequest) {
        let coordinator = SignUpProfileCoordinator(presenter: presenter)
        coordinator.parent = self
        coordinator.request = request
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
