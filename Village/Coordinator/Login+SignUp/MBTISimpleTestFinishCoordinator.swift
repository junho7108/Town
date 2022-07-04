final class MBTISimpleTestFinishCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    var mbti: MBTIType
    
    init(mbti: MBTIType, presenter: VillageNavigationController) {
        self.mbti = mbti
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let viewModel = MBTISimpleTestFinishViewModel(dependencies: .init(mbti: mbti))
        let testFinishVC = MBTISimpleTestFinishViewController(viewModel: viewModel)
        testFinishVC.coordinator = self
        testFinishVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(testFinishVC, animated: true)
    }
    
    func popToSignUpScene() {
        for (_, vc) in presenter.viewControllers.enumerated() {
            if let signUpVC = vc as? SignUpMBTIViewConroller {
                signUpVC.configureMBTI(mbti: mbti)
                presenter.popToViewController(signUpVC, animated: true)
                return
            }
        }
    }
}
