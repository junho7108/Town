final class DeclarationCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let viewModel = DeclarationViewModel(dependencies: .init())
        let declarationVC = DeclarationViewController(viewModel: viewModel)
        declarationVC.coordinator = self
        declarationVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(declarationVC, animated: true)
    }
}
