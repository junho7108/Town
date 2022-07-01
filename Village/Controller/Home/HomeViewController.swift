import UIKit
import FloatingPanel
import RxSwift

class HomeViewController: BaseViewController {
    
    var coordinator: HomeCoordinator?
    
    let viewModel: HomeViewModel
    
    //MARK: - UI Properties
    
    private let floatingVC = FloatingPanelController()
    
    private let homeBottomSheetVC = HomeBottomSheetViewController()
    
    private let selfView = HomeView()
    
    //MARK: - Lifecycles
    
    init(vieWModel: HomeViewModel) {
        self.viewModel = vieWModel
        super.init(nibName: nil, bundle: nil)
        configureFloatingPanel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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
        let tapMoreCompetitionButton = homeBottomSheetVC.selfView.moreCompetitionButton.rx.tap
        
        //MARK: BINDS
        
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(fetching: fetching.asObservable(),
                                                      tapMoreCompetitionButton: tapMoreCompetitionButton.asObservable()))
        
        output.user
            .bind { [weak self] user in
                self?.selfView.configureUI(user: user)
            }
            .disposed(by: disposeBag)
        
        output.activating
            .map { !$0 }
            .bind(to: selfView.loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.competitionVotes
            .asDriver(onErrorJustReturn: [])
            .drive(homeBottomSheetVC.selfView.competitionCollcetionView.rx.items(cellIdentifier: CompetitionCollectionCell.identifier,
                                                                                 cellType: CompetitionCollectionCell.self)) { index, vote, cell in
                cell.configureUI(vote: vote, colorType: .grey)
                
                // 대항전 투표 컨텐츠 바인딩
                if let choice = vote.choice {
                    Observable.just(choice)
                        .asDriver(onErrorJustReturn: [])
                        .drive(cell.tableView.rx.items(cellIdentifier: VoteCell.identifier, cellType: VoteCell.self)) { tableIndex, choice, tableCell in
                            tableCell.configureUI(text: choice.voteContentTitle, colorType: .white, numberOfLines: 2)
                        }
                        .disposed(by: cell.disposeBag)
                }
                
                // 대항전 투표 컨텐츠 클릭
                cell.tableView.rx.modelSelected(VoteContent.self)
                    .bind { content in
                        Logger.printLog("\(content.voteContentTitle)")
                    }
                    .disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
        
        output.showMoreCompetitionPage
            .bind { [weak self] in
                self?.backBarButtonItem.title = "🥊 이번 주 대항전"
                self?.coordinator?.pushMoreCompetitionScene()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureFloatingPanel() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 30
        appearance.backgroundColor = .white
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        
        floatingVC.surfaceView.appearance = appearance
        
        floatingVC.set(contentViewController: homeBottomSheetVC)
        floatingVC.layout = MyFloatingPanelLayout()
        floatingVC.addPanel(toParent: self)
        floatingVC.invalidateLayout()
    }
}

//MARK: - HomeViewController

extension HomeViewController {
    class MyFloatingPanelLayout: FloatingPanelLayout {
        var position: FloatingPanelPosition {
            return .bottom
        }
        
        var initialState: FloatingPanelState {
            return .half
        }
      
        var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 24, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(absoluteInset: 118 + 230 + 21 + 16,
                                                 edge: .top,
                                                 referenceGuide: .superview)
            ]
        }
    }
}
