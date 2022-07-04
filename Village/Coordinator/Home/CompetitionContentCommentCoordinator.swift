import Foundation

final class CompetitionContentCommentCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    private let content: Vote
    
    init(content: Vote, presenter: VillageNavigationController) {
        self.content = content
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start() {
        let viewModel = CompetitionContentCommentViewModel(dependencies: .init(content: content))
        let competitionContentCommentVC = CompetitionContentCommentViewControlelr(viewModel: viewModel)
        competitionContentCommentVC.hidesBottomBarWhenPushed = true
        competitionContentCommentVC.coordinator = self
        competitionContentCommentVC.coordinatorFinishDelegate = self
        
        presenter.pushViewController(competitionContentCommentVC, animated: true)
    }
    
    
}
