import UIKit
import RxSwift
import RxCocoa
import RxGesture

class FeedViewController: BaseViewController {
    
    var coordinator: FeedCoordinator?
    
    let viewModel: VillageViewModel
    
    private let selfView = VillageView()
    
    //MARK: - Lifecycle
    
    init(viewModel: VillageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: selfView.villageBarButton)
    }
    
    func configureBackButtonItem(title: String = "") {
        super.configureNavigationController()
        backBarButtonItem.title = title
    }
    
    //MARK: - Binds
    
    override func setUpBindins() {
        
        // INPUT
        
        let fetching = rx.viewWillAppear.take(1).map { _ in }
        
        let tapFeed = PublishSubject<Feed>()
        
        let tapCategory = PublishSubject<FeedCategory>()
        
        let tapFeedOption = PublishSubject<Feed>()
        
        let tapDeleteFeed = PublishRelay<Void>()
        
        let tapModifyFeed = PublishRelay<Void>()
        
        let tapDeclaration = PublishRelay<Void>()
        
        let tapMoveVillage = selfView.villageBarButton.rx.tapGesture(configuration: nil).when(.recognized).map { _ in }.asObservable()
        
        selfView.feedTableView.rx
            .modelSelected(Feed.self)
            .bind(to: tapFeed)
            .disposed(by: disposeBag)
        
        selfView.categoryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
      
        selfView.categoryCollectionView.rx
            .modelSelected(FeedCategory.self)
            .bind(to: tapCategory)
            .disposed(by: disposeBag)
        
        // OUTPUT
        
        let output = viewModel.transform(input: .init(fetchUser: fetching.asObservable(),
                                                      fetchFeeds: fetching.asObservable(),
                                                      tapFeed: tapFeed.asObservable(),
                                                      tapFeedOption: tapFeedOption.asObservable(),
                                                      tapCategory: tapCategory.asObservable(),
                                                      tapUploadFeed: selfView.uploadButton.rx.tap.asObservable(),
                                                      tapDeleteFeed: tapDeleteFeed.asObservable(),
                                                      tapModifyFeed: tapModifyFeed.asObservable(),
                                                      tapDeclaration: tapDeclaration.asObservable(),
                                                      tapMoveVillage: tapMoveVillage.asObservable()))
        
        output.user
            .bind { [weak self] user in
                self?.selfView.villageBarButton.configure(mbti: user.mbti)
            }
            .disposed(by: disposeBag)
       
        output.showFeedCommentsPage
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] feed in
                self?.configureBackButtonItem(title: "게시물 보기")
                self?.coordinator?.pushCommentScene(feed: feed)
            })
            .disposed(by: disposeBag)
        
    
        output.filterdFeeds
            .asDriver(onErrorJustReturn: [])
            .drive(selfView.feedTableView.rx.items(cellIdentifier: FeedCell.identifier,
                                                   cellType: FeedCell.self)) { index, feed, cell in
                
                cell.configureUI(feed: feed)
                
                cell.likeButton.rx.tap
                    .bind(onNext: {
                        print("\(cell.feed.title): didTapLikeButton")
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.commentButton.rx.tap
                    .bind(onNext: {
                        print("\(cell.feed.title): didTapCommentButton")
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.optionButton.rx.tap
                    .bind { _ in
                        tapFeedOption.onNext(feed)
                    }
                    .disposed(by: cell.disposeBag)
                
                if let vote = feed.vote,
                   let voteContents = vote.choice {
                  
                    cell.voteView.tableView.rx
                        .modelSelected(VoteContent.self)
                        .bind { content in
                            Logger.printLog("didSelect: \(content.voteContentTitle)")
                        }
                        .disposed(by: cell.disposeBag)
                    
                    Observable.just(voteContents)
                        .bind(to: cell.voteView.tableView.rx.items(cellIdentifier: VoteCell.identifier,
                                                                   cellType: VoteCell.self)) { index, voteContent, voteCell in
                            voteCell.configureUI(text: voteContent.voteContentTitle)
                        }.disposed(by: cell.disposeBag)
                }
                
            }.disposed(by: disposeBag)
        
        
        output.allCategories
            .asDriver(onErrorJustReturn: [])
            .drive(selfView.categoryCollectionView.rx.items(cellIdentifier: FeedCategoryCell.identifier,
                                                            cellType: FeedCategoryCell.self)) { index, category, cell in
                cell.configureUI(feedCategory: category, isSelected: true)
                
                output.selectedCategories
                    .asDriver(onErrorJustReturn: [])
                    .drive(onNext: { selectedCategories in
                        let isSelected = selectedCategories.filter { $0.rawValue == category.rawValue }.count > 0
                        cell.selectCategory(isSelected: isSelected)
                    }).disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
        
        output.showUploadFeedPage
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.configureBackButtonItem(title: "글쓰기")
                self?.coordinator?.pushUploadFeedScene()
            })
            .disposed(by: disposeBag)
        
        output.showFeedOptionsPage
            .bind { [weak self] options in
                let optionActionSheet = ActionSheetViewController(options: options)
                
                Observable.of(options)
                    .asDriver(onErrorJustReturn: [])
                    .drive(optionActionSheet.tableView.rx.items(cellIdentifier: ActionSheetCell.identifier, cellType: ActionSheetCell.self)) { index, option, cell in
                        cell.configureActionSheet(option: option)
                    }.disposed(by: optionActionSheet.disposeBag)
                
                optionActionSheet.tableView.rx
                    .modelSelected(ActionSheetOption.self)
                    .bind { option in
                        switch option {
                        case .delete: tapDeleteFeed.accept(())
                        case .modify: tapModifyFeed.accept(())
                        case .declaration: tapDeclaration.accept(())
                        }
                        
                        optionActionSheet.dismiss(animated: false, completion: nil)
                    }
                    .disposed(by: optionActionSheet.disposeBag)
                
                optionActionSheet.show(parent: self, completion: nil)
            }
            .disposed(by: disposeBag)
        
        output.showDeclarationPage
            .bind { [weak self] in
                self?.configureBackButtonItem(title: "🚨 신고하기")
                self?.coordinator?.pushDeclarationScene()
            }
            .disposed(by: disposeBag)
        
        output.showDeleteFeedPage
            .bind { _ in
                Logger.printLog("삭제하기")
            }
            .disposed(by: disposeBag)

        output.showModifyPage
            .bind { _ in
                Logger.printLog("수정하기")
            }
            .disposed(by: disposeBag)
        
        output.showMoveVillagePage
            .bind { [weak self] in
                self?.configureBackButtonItem(title: "다른 마을 놀러가기")
                self?.coordinator?.pushMoveVillageScene()
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BaseTagCell.fittingsize(text: FeedCategory.allCases[indexPath.row].title)
    }
}
