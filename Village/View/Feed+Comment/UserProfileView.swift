import UIKit
import KakaoSDKUser

class UserProfileView: BaseView {
    
    //MARK: - UI Properties
    
    let headerView: UserProfileHeaderView

    let tableView = UITableView(frame: .zero, style: .grouped)
    
    //MARK: - Lifecycles
    
    init(user: User) {
        headerView = UserProfileHeaderView(user: user)
        super.init(frame: .zero)
        configureTableView()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configures
    override func configureUI() {
        backgroundColor = .white
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .grey100
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
       
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 800
        
        tableView.tableHeaderView = headerView
        headerView.frame = .init(x: 0, y: 0, width: frame.width, height: 157)
    }
}
