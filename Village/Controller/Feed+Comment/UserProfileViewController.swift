import UIKit
import RxSwift
import RxRelay

class UserProfileViewController: BaseViewController {
    
    var coordinator: UserProfileCoordinator?
    
    let viewModel: UserProfileViewModel
    
    //MARK: - UI Properties
    
    let selfView: UserProfileView
    
    //MARK: - Lifecycles
    
    init(user: User, viewModel: UserProfileViewModel) {
        selfView = UserProfileView(user: user)
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
        
        let fetching = rx.viewWillAppear.map { _ in }
        
        //MARK: BINDS
        
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(fetching: fetching.asObservable()))
        
        output.feeds
            .asDriver(onErrorJustReturn: [])
            .drive(selfView.tableView.rx.items(cellIdentifier: FeedCell.identifier,
                                               cellType: FeedCell.self)) { index, feed, cell in
                cell.configureUI(feed: feed)
                
                if let vote = feed.vote {
                    cell.feedVoteView.configureUI(vote: vote, numberOfTitleLines: 2, numberOfContentLines: 2)
                }
            }.disposed(by: disposeBag)
    }
}
