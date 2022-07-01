import UIKit

class ProfileSettingView: BaseView {
    
    //MARK: - UI Properties
    
    private let myPageLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .suitFont(size: 17, weight: .medium)
        return label
    }()
    
    let headerView = ProfileSettingHeaderView()

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    //MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .grey100
    
        addSubview(tableView)
        tableView.backgroundColor = .grey100
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.bounces = false
        tableView.separatorStyle = .none
        
        tableView.register(ProfileSettingCell.self, forCellReuseIdentifier: ProfileSettingCell.identifier)
        tableView.rowHeight = 51
        
        tableView.tableHeaderView = headerView
        headerView.frame = .init(x: 0, y: 0, width: frame.width, height: headerView.height)
         
        tableView.sectionHeaderHeight = 16
        tableView.sectionFooterHeight = .leastNonzeroMagnitude
    }
}
