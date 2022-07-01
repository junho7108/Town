class EditProfileCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    
    var presenter: VillageNavigationController
    
    var childCoordinators: [Coordinator]
    
    let user: User
    
    init(user: User, presenter: VillageNavigationController) {
        self.presenter = presenter
        self.user = user
        childCoordinators = []
    }
    
    func start() {
        let viewModel = EditProfileViewModel(dependencies: .init(user: user))
        let editProfileVC = EditProfileViewController(user: user, viewModel: viewModel)
        editProfileVC.hidesBottomBarWhenPushed = true
        
        editProfileVC.coordinator = self
        editProfileVC.coordinatorFinishDelegate = self
        presenter.pushViewController(editProfileVC, animated: true)
    }
    
    
}
