import UIKit
import RxSwift
import RxCocoa
import RxGesture

class FeedViewController: BaseViewController {
    
    var coordinator: FeedCoordinator?
    
    let viewModel: FeedViewModel
    
    //MARK: - UI Properties
    
    private lazy var spinner: UIView = {
        let view = UIView(frame: .init(origin: .zero, size: .init(width: view.frame.size.width, height: 100)))
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
 
    let selfView = FeedView()
    
    //MARK: - Lifecycle
    
    init(viewModel: FeedViewModel) {
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
        selfView.uploadButton.isHidden = viewModel.dependencies.showType != .showAllFeeds
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureNavigationController() {
        if viewModel.dependencies.showType == .showAllFeeds {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: selfView.villageBarButton)
        } else {
            super.configureNavigationController()
        }
    }
    
    func configureBackButtonItem(title: String = "") {
        super.configureNavigationController()
        backBarButtonItem.title = title
    }
    
    //MARK: - Binds
    
    override func setUpBindins() {
        
        //MARK: INPUT
        
        let fetching = PublishRelay<Void>()
    
        let tapFeed = PublishRelay<Feed>()
        
        let tapCategory = PublishRelay<FeedCategory>()
        
        let tapFeedOption = PublishRelay<(Feed, FeedCell)>()
        let tapDeleteFeed = PublishRelay<Feed>()
        let tapEditFeed = PublishRelay<Feed>()
        let tapDeclaration = PublishRelay<Feed>()
        let tapHideFeed = PublishRelay<(Feed, FeedCell)>()
        
        let tapMoveVillage = selfView.villageBarButton.rx.tapGesture(configuration: nil).when(.recognized).map { _ in }.asObservable()
        let tapUserProfile = PublishRelay<User>()
        
        let tapFeedLike = PublishRelay<Feed>()
        let fetchMoreFeeds = PublishRelay<Void>()
        let refreshControlAction = PublishRelay<Void>()
        
        //MARK: Binds
        
        rx.viewWillAppear
            .take(1)
            .map { _ in }
            .bind(to: fetching)
            .disposed(by: disposeBag)
        
        selfView.refreshControl.rx.controlEvent(.valueChanged)
            .bind { _ in
                refreshControlAction.accept(())
            }
            .disposed(by: disposeBag)
        
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
        
        //MARK: Paging

        selfView.feedTableView.rx.didScroll
            .bind { [weak self] in
                guard let self = self else { return }
                let offsetY = self.selfView.feedTableView.contentOffset.y
                let contentHeight = self.selfView.feedTableView.contentSize.height
             
                if offsetY > (contentHeight - self.selfView.feedTableView.frame.size.height - 100) {
                    fetchMoreFeeds.accept(())
                }
            }
            .disposed(by: disposeBag)

       
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(fetchUser: fetching.asObservable(),
                                                      fetchFeeds: fetching.asObservable(),
                                                      tapFeed: tapFeed.asObservable(),
                                                      tapFeedOption: tapFeedOption.asObservable(),
                                                      tapCategory: tapCategory.asObservable(),
                                                      tapUploadFeed: selfView.uploadButton.rx.tap.asObservable(),
                                                      tapDeleteFeed: tapDeleteFeed.asObservable(),
                                                      tapEditFeed: tapEditFeed.asObservable(),
                                                      tapDeclaration: tapDeclaration.asObservable(),
                                                      tapHideFeed: tapHideFeed.asObservable(),
                                                      tapMoveVillage: tapMoveVillage.asObservable(),
                                                      tapUserProfile: tapUserProfile.asObservable(),
                                                      tapFeedLike: tapFeedLike.asObservable(),
                                                      fetchMoreFeeds: fetchMoreFeeds.asObservable(),
                                                      refreshControlAction: refreshControlAction.asObservable()))
        
        output.isLoadingSpinnerAvailable
            .bind { [weak self] isAvailable in
                guard let self = self else { return }
                self.selfView.feedTableView.tableFooterView = isAvailable ? self.spinner : UIView(frame: .zero)
            }
            .disposed(by: disposeBag)
        
        output.refreshControlCompleted
            .bind { [weak self] in
                self?.selfView.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        output.user
            .bind { [weak self] user in
//                self?.selfView.villageBarButton.configure(mbti: user.mbti)
                self?.selfView.villageBarButton.configure(mbti: nil)
            }
            .disposed(by: disposeBag)
       
        output.showFeedCommentsPage
            .bind(onNext: { [weak self] feed in
                guard let self = self else { return }
                self.configureBackButtonItem(title: "게시물 보기")
                self.coordinator?.pushCommentScene(feed: feed, scrollToComment: false)
            })
            .disposed(by: disposeBag)
        
    
        output.filterdFeeds
            .asDriver(onErrorJustReturn: [])
            .drive(selfView.feedTableView.rx.items(cellIdentifier: FeedCell.identifier,
                                                   cellType: FeedCell.self)) { index, feed, cell in
                cell.configureUI(feed: feed)
                
                cell.contentImageView.rx.tapGesture(configuration: nil)
                    .filter { [unowned self] _ in
                        let velocity = selfView.feedTableView.panGestureRecognizer.velocity(in: selfView)
                        return velocity.y.magnitude < .leastNonzeroMagnitude
                    }
                    .when(.recognized)
                    .bind { [weak self] _ in
                        guard let image = cell.contentImageView.image else { return }
                        self?.showImageView(image: image)
                    }
                    .disposed(by: cell.disposeBag)
                
                Observable.merge([
                    cell.userProfileImageView.rx.tapGesture(configuration: nil).when(.recognized).asObservable(),
                    cell.nicknameLabel.rx.tapGesture(configuration: nil).when(.recognized).asObservable()
                ])
                    .bind { [weak self] _ in
                        self?.configureBackButtonItem(title: "이웃 정보")
                        self?.coordinator?.pushUserProfileScene(user: feed.author)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.likeButton.rx.tap
                    .map { _ in feed }
                    .bind { feed in
                        cell.like(feed: feed)
                        tapFeedLike.accept(feed)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.commentButton.rx.tap
                    .bind(onNext: { [weak self] _ in
                        self?.configureBackButtonItem(title: "게시물 보기")
                        self?.coordinator?.pushCommentScene(feed: feed, scrollToComment: true)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.optionButton.rx.tap
                    .bind { _ in
                        tapFeedOption.accept((feed, cell))
                    }
                    .disposed(by: cell.disposeBag)
                
                if let vote = feed.vote {
                    cell.feedVoteView.configureUI(vote: vote, numberOfTitleLines: 2, numberOfContentLines: 2)
                    cell.feedVoteView.contentArray.forEach { contentView in
                        contentView.rx.tapGesture(configuration: nil)
                            .when(.recognized)
                            .bind { _ in
                                cell.feedVoteView.didSelect(contentView: contentView)
                            }
                            .disposed(by: cell.disposeBag)
                    }
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
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] feedAndOptions in
                let feed = feedAndOptions.0
                let cell = feedAndOptions.1
                let options = feedAndOptions.2
                
                let optionActionSheet = ActionSheetViewController(options: options)
                optionActionSheet.show(parent: self, completion: nil)
    
                Observable.of(options)
                    .asDriver(onErrorJustReturn: [])
                    .drive(optionActionSheet.tableView.rx.items(cellIdentifier: ActionSheetCell.identifier, cellType: ActionSheetCell.self)) { index, option, cell in
                        cell.configureActionSheet(option: option)
                    }.disposed(by: optionActionSheet.disposeBag)
                
                optionActionSheet.tableView.rx
                    .modelSelected(ActionSheetOption.self)
                    .bind { option in
                        optionActionSheet.dismiss(animated: false) {
                            switch option {
                            case .delete:
                                let deletePopupVC = BasePopupViewController(title: "알림", content: "🗑 정말 삭제하실건가요?")
                                deletePopupVC.show(parent: self)
                                deletePopupVC.okButton.rx.tap
                                    .bind { _ in
                                        tapDeleteFeed.accept((feed))
                                        deletePopupVC.dismiss(animated: false)
                                    }
                                    .disposed(by: deletePopupVC.disposeBag)
                                
                            case .edit:
                                tapEditFeed.accept((feed))
                            case .declaration:
                                tapDeclaration.accept((feed))
                            case .hide, .cancelHide:
                                tapHideFeed.accept((feed, cell))
                            }
                        }
                    }
                    .disposed(by: optionActionSheet.disposeBag)

            }
            .disposed(by: disposeBag)
        
        output.showDeclarationPage
            .bind { [weak self] feed in
                self?.configureBackButtonItem(title: "🚨 신고하기")
                self?.coordinator?.pushDeclarationScene()
            }
            .disposed(by: disposeBag)
        
        output.showDeleteFeedPage
            .bind { [weak self] feed in
                self?.showToast(message: "게시글 삭제")
            }
            .disposed(by: disposeBag)

        output.showEditPage
            .bind { [weak self] feed in
                self?.configureBackButtonItem(title: "글 수정하기")
                self?.coordinator?.pushEditFeedScene(feed: feed)
            }
            .disposed(by: disposeBag)
        
        output.showHideFeedAnim
            .bind { [weak self] (feed, feedCell) in
                if let indexPath = self?.selfView.feedTableView.indexPath(for: feedCell) {
                    self?.selfView.feedTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            .disposed(by: disposeBag)
        
        output.showMoveVillagePage
            .bind { [weak self] in
//                self?.configureBackButtonItem(title: "다른 마을 놀러가기")
//                self?.coordinator?.pushMoveVillageScene()
            }
            .disposed(by: disposeBag)
        
        output.showFeedLikes
            .bind { _ in
                Logger.printLog("좋아요")
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
