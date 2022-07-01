class ThirdMBTISimpleTestCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    var mbtiFirst: MBTIEnergy
    
    var mbtiSecond: MBTIInformation
    
    init(mbtiFirst: MBTIEnergy, mbtiSecond: MBTIInformation, presenter: VillageNavigationController) {
        self.mbtiFirst = mbtiFirst
        self.mbtiSecond = mbtiSecond
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let viewModel = ThirdMBTISimpleTestViewModel(dependencies: .init(mbtiFirstIndex: mbtiFirst, mbtiSecondIndex: mbtiSecond))
        let simpleTestVC = ThirdMBTISimpleTestViewController(viewModel: viewModel)
        simpleTestVC.coordinator = self
        simpleTestVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(simpleTestVC, animated: true)
    }
    
    func pushLastMBTISimpleTestScene(mbtiFirst: MBTIEnergy, mbtiSecond: MBTIInformation, mbtiThird: MBTIDecisions) {
        let coordinator = LastMBTISimpleTestCoordinator(mbtiFirst: mbtiFirst, mbtiSecond: mbtiSecond, mbtiThird: mbtiThird, presenter: presenter)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
    

