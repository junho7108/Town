import UIKit

final class MainTabBarViewController: UITabBarController {
    
    enum TabBarItem: CaseIterable {
//        case home
        case feed, profile
    
        var image: UIImage?  {
            switch self {
//            case .home: return #imageLiteral(resourceName: "ic_home_off").withRenderingMode(.alwaysOriginal)
            case .feed: return #imageLiteral(resourceName: "ic_peed_off").withRenderingMode(.alwaysOriginal)
            case .profile: return #imageLiteral(resourceName: "ic_profile_off").withRenderingMode(.alwaysOriginal)
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
//            case .home: return #imageLiteral(resourceName: "ic_home_on").withRenderingMode(.alwaysOriginal)
            case .feed: return #imageLiteral(resourceName: "ic_peed_on").withRenderingMode(.alwaysOriginal)
            case .profile: return #imageLiteral(resourceName: "ic_profile_on").withRenderingMode(.alwaysOriginal)
            }
        }
        
        func coordinator(presenter: VillageNavigationController) -> Coordinator {
            switch self {
//            case .home: return HomeCoordinator(presenter: presenter)
            case .feed: return FeedCoordinator(showType: .showAllFeeds, presenter: presenter)
            case .profile: return ProfileSettingCoordinator(presenter: presenter)
            }
        }
    }
    
    //MARK: - Properties
    
    var coordinator: LoginCoordinator?
    
    var tabBarItems: [TabBarItem] = TabBarItem.allCases
    
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        configureUI()
        delegate = self
    }
    
    deinit {
        coordinatorFinishDelegate?.coordinatorDidFinish()
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    }
    
    //MARK: - Helpers
    
    private func setupViewControllers() {
        let controllers = tabBarItems.map { generateTabBarController(item: $0) }
        setViewControllers(controllers, animated: true)
    }
    
    private func generateTabBarController(item: TabBarItem) -> VillageNavigationController {
        let navigationController = VillageNavigationController()
        let tabItem = UITabBarItem(title: nil,
                                   image: item.image,
                                   selectedImage: item.selectedImage)
        
        tabItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        navigationController.tabBarItem = tabItem
        let coordinator = item.coordinator(presenter: navigationController)
        coordinator.start()
        return navigationController
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 && tabBarController.selectedViewController == viewController {
            let navVC = viewController as? VillageNavigationController
            let feedVC = navVC?.viewControllers[0] as? FeedViewController
            feedVC?.selfView.feedTableView.scrollToRow(at: IndexPath(row: 0, section: 0) as IndexPath, at: .top, animated: true)
        }
        
        if tabBarIndex == 1 && tabBarController.selectedViewController == viewController {
            let navVC = viewController as? VillageNavigationController
            let settingVC = navVC?.viewControllers[0] as? ProfileSettingViewController
            
            
            UIView.animate(withDuration: 0.3) {
                settingVC?.selfView.tableView.contentOffset = .zero
            }
        }
        
        return true
    }
}
