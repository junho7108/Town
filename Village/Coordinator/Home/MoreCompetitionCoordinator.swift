final class MoreCompetitionCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: VillageNavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let repository = StubCompetitionContentsRepository()
        let usecase = CompetitionContentsUsecase(repository: repository)
        let viewModel = MoreCompetitionViewModel(dependencies: .init(usecase: usecase))
        let moreCompetitionVC = MoreCompetitionViewControlelr(viewModel: viewModel)
        moreCompetitionVC.coordinator = self
        moreCompetitionVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(moreCompetitionVC, animated: true)
        
    }
    
    func pushCompetitionContentCommentScene(content: Vote) {
        let coordinator = CompetitionContentCommentCoordinator(content: content, presenter: presenter)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
