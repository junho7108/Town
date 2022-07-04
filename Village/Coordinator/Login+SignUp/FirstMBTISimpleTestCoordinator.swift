final class FirstMBTISimpleTestCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let viewModel = FirstMBTISimpleTestViewModel(dependencies: .init())
        let simpleTestVC = FirstMBTISimpleTestViewController(viewModel: viewModel)
        simpleTestVC.coordinator = self
        simpleTestVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(simpleTestVC, animated: true)
    }
    
    func pushSecondMBTISimpleTestScene(mbtiEnergy: MBTIEnergy) {
        let coordinator = SecondMBTISimpleTestCoordinator(mbtiFirst: mbtiEnergy, presenter: presenter)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
    

