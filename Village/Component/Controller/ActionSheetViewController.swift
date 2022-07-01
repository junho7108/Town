import UIKit
import RxSwift
import RxCocoa

enum ActionSheetType {
    case feed
    case comment
}

enum ActionSheetOption {
    case hide
    case cancelHide
    case edit
    case delete, declaration
    
    var title: String {
        switch self {
        case .hide: return "📦 숨기기"
        case .cancelHide: return "📦 숨기기 취소"
        case .edit: return "✏️ 수정하기"
        case .delete: return "🗑 삭제하기"
        case .declaration: return "🚨 신고하기"
        }
    }
}

class ActionSheetViewController: BaseViewController {
    
    var options: [ActionSheetOption] = []
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.grey300, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    //MARK: - Lifecycles
    
    init(options: [ActionSheetOption]) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
        configureTableView()
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Configures
    
    
    override func configureUI() {
        
        view.backgroundColor = .black.withAlphaComponent(0.18)
        
        view.addSubview(cancelButton)
        cancelButton.layer.cornerRadius = 52 / 2
        cancelButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(45)
        }
        
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 24
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButton.snp.top).offset(-8)
            make.height.equalTo(52 * options.count)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func setUpBindins() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: ActionSheetCell.identifier)
        tableView.rowHeight = 52
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNonzeroMagnitude))
        tableView.sectionHeaderHeight = .leastNonzeroMagnitude
        tableView.sectionFooterHeight = .leastNonzeroMagnitude
    }
    
    func show(parent: UIViewController?, completion: (() -> Void)? = nil) {
        guard let parent = parent else { return }
        
        var superVC: UIViewController
        
        if let tabBarVC = parent.tabBarController {
            superVC = tabBarVC
        } else {
            superVC = parent.navigationController == nil ? parent : parent.navigationController!
        }
        
        superVC.present(self, animated: false, completion: completion)
    }
}
