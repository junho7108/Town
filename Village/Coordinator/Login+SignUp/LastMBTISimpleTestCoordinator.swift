class LastMBTISimpleTestCoordinator: Coordinator {
    
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    var mbtiFirst: MBTIEnergy
    
    var mbtiSecond: MBTIInformation
    
    var mbtiThird: MBTIDecisions
   
    init(mbtiFirst: MBTIEnergy, mbtiSecond: MBTIInformation, mbtiThird: MBTIDecisions, presenter: VillageNavigationController) {
        self.mbtiFirst = mbtiFirst
        self.mbtiSecond = mbtiSecond
        self.mbtiThird = mbtiThird
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let viewModel = LastMBTISimpleTestViewModel(dependencies: .init(mbtiFirstIndex: mbtiFirst, mbtiSecondIndex: mbtiSecond, mbtiThirdIndex: mbtiThird))
        let simpleTestVC = LastMBTISimpleTestViewController(viewModel: viewModel)
        simpleTestVC.coordinator = self
        simpleTestVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(simpleTestVC, animated: true)
    }
    
    func pushTestFinishScene(mbti: MBTIType) {
        let coordinator = MBTISimpleTestFinishCoordinator(mbti: mbti, presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
    

