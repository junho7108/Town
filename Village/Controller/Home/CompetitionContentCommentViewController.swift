import UIKit
import RxSwift

final class CompetitionContentCommentViewControlelr: BaseViewController {
    
    var coordinator: CompetitionContentCommentCoordinator?
    
    let viewModel: CompetitionContentCommentViewModel
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - UI Properties
    
    let selfView = CompetitionContentCommentTableView(frame: .zero, style: .grouped)
    
    private lazy var commentInputView = CommentInputView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 56))
  
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    //MARK: - Lifecycles
    
    init(viewModel: CompetitionContentCommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
        
        //MARK: INPUT
        
        let fetching = rx.viewWillAppear.take(1).map { _ in }
        
        //MARK: BINDS
        
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(fetching: fetching.asObservable()))
        
        output.content
            .share()
            .bind { [weak self] vote in
                self?.selfView.headerView.competitionContentView.configureUI(vote: vote, colorType: .grey)
            }
            .disposed(by: disposeBag)
        
        output.content
            .share()
            .map { vote -> [VoteContent] in
                if let choice = vote.choice {
                    return choice
                } else {
                    return []
                }
            }
            .bind(to: selfView.headerView.competitionContentView.tableView.rx.items(cellIdentifier: VoteCell.identifier,
                                                                                    cellType: VoteCell.self)) { index, content, cell in
                cell.configureUI(text: content.voteContentTitle, colorType: .white, numberOfLines: 0)
            }.disposed(by: disposeBag)
    }
}
