import UIKit

class CreateVoteView: BaseView {
    
    //MARK: - UI Properties
    
    let titleTextView: InputTextView = {
        let textView = InputTextView(edgeInset: .init(top: 10, left: 16, bottom: 10, right: 16))
        textView.backgroundColor = .grey100
        textView.font = .suitFont(size: 15, weight: .regular)
        textView.isScrollEnabled = false
        textView.maxTextCount = 50
        textView.placeholder = "제목을 입력해주세요."
        textView.placeholderLabel.font = .suitFont(size: 13, weight: .regular)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let headerView = UIView()
    
    private let footerView = UIView()
    
    let addVoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ 항목 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .bold)
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = .villageSky
        button.layer.cornerRadius = 16
        return button
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .clear
        tableView.layer.cornerRadius = 24
        
        footerView.addSubview(addVoteButton)
        addVoteButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(32)
        }
        
        addSubview(titleTextView)
        titleTextView.layer.cornerRadius = 20
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureUI(vote: Vote) {
        titleTextView.text = vote.title
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .grey100
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.register(CreateVoteCell.self, forCellReuseIdentifier: CreateVoteCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        
        tableView.tableHeaderView = headerView
        headerView.frame = .init(x: 0, y: 0, width: frame.width, height: 24)
        
        tableView.tableFooterView = footerView
        footerView.frame = .init(x: 0, y: 0, width: frame.width, height: 32)
    }
}

