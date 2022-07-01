import UIKit
import RxSwift
import RxCocoa

class MoreCompetitionViewControlelr: BaseViewController {
    
    var coordinator: MoreCompetitionCoordinator?
    
    let viewModel: MoreCompetitionViewModel
    
    //MARK: - UI Properties
    
    private(set) lazy var selfView = MoreCompetitionCollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
    
    private(set) lazy var collectionFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 247)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    //MARK: - Lifecycles
    
    init(viewModel: MoreCompetitionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
        
        //MARK: INPUT
        
        let fetching = rx.viewWillAppear.take(1).map { _ in }
        let tapCompetitionContent = PublishRelay<Vote>()
        
        //MARK: BIDNS
        
        selfView.rx.modelSelected(Vote.self)
            .bind(to: tapCompetitionContent)
            .disposed(by: disposeBag)
        
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(fetching: fetching.asObservable(),
                                                      tapCompetitionContent: tapCompetitionContent.asObservable()))
        
        output.competitionContents
            .asDriver(onErrorJustReturn: [])
            .drive(selfView.rx.items(cellIdentifier: CompetitionCollectionCell.identifier,
                                                    cellType: CompetitionCollectionCell.self)) { index, vote, cell in
                
                cell.configureUI(vote: vote, colorType: .white)
                
                // 대항전 투표 컨텐츠 바인딩
                if let choice = vote.choice {
                    Observable.just(choice)
                        .asDriver(onErrorJustReturn: [])
                        .drive(cell.tableView.rx.items(cellIdentifier: VoteCell.identifier, cellType: VoteCell.self)) { tableIndex, choice, tableCell in
                            tableCell.configureUI(text: choice.voteContentTitle, colorType: .grey, numberOfLines: 2)
                        }
                        .disposed(by: cell.disposeBag)
                }
                
            }.disposed(by: disposeBag)
     
        output.showDetailCompetitionContentPage
            .bind { [weak self] vote in
                self?.backBarButtonItem.title = "🥊 이번 주 대항전"
                self?.coordinator?.pushCompetitionContentCommentScene(content: vote)
            }
            .disposed(by: disposeBag)
    }
}
