final class SecondMBTISimpleTestCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    var mbtiFirst: MBTIEnergy
    
    init(mbtiFirst: MBTIEnergy, presenter: VillageNavigationController) {
        self.mbtiFirst = mbtiFirst
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let viewModel = SecondMBTISimpleTestViewModel(dependencies: .init(mbtiFirstIndex: mbtiFirst))
        let simpleTestVC = SecondMBTISimpleTestViewController(viewModel: viewModel)
        simpleTestVC.coordinator = self
        simpleTestVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(simpleTestVC, animated: true)
    }
    
    func pushThirdMBTISimpleTestScene(mbtiFirst: MBTIEnergy, mbtiSecond: MBTIInformation) {
        let coordinator = ThirdMBTISimpleTestCoordinator(mbtiFirst: mbtiFirst, mbtiSecond: mbtiSecond, presenter: presenter)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
    

