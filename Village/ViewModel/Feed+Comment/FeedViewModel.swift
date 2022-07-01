import RxSwift
import RxRelay
import RxCocoa
import KakaoSDKUser

enum FeedShowType {
    case showAllFeeds
    case showMyFeeds
    case showCommentFeeds
    case showLikeFeeds
    case showHiddenFeeds
    case showSaveFeeds
}

class FeedViewModel: ViewModelType {
    
    struct Input {
        var fetchUser: Observable<Void>
        var fetchFeeds: Observable<Void>
        var tapFeed: Observable<Feed>
        var tapFeedOption: Observable<(Feed, FeedCell)>
        var tapCategory: Observable<FeedCategory>
        var tapUploadFeed: Observable<Void>
        var tapDeleteFeed: Observable<Feed>
        var tapEditFeed: Observable<Feed>
        var tapDeclaration: Observable<Feed>
        var tapHideFeed: Observable<(Feed, FeedCell)>
        var tapMoveVillage: Observable<Void>
        var tapUserProfile: Observable<User>
        var tapFeedLike: Observable<Feed>
        var fetchMoreFeeds: Observable<Void>
        var refreshControlAction: Observable<Void>
    }
    
    struct Output {
        var user: Observable<User>
        var feeds: Observable<[Feed]>
        var filterdFeeds: Observable<[Feed]>
        var allCategories: Observable<[FeedCategory]>
        var selectedCategories: Observable<[FeedCategory]>
        var showFeedCommentsPage: Observable<Feed>
        var showUploadFeedPage: Observable<Void>
        var showFeedOptionsPage: Observable<(Feed, FeedCell, [ActionSheetOption])>
        
        var showEditPage: Observable<Feed>
        var showDeleteFeedPage: Observable<Void>
        var showDeclarationPage: Observable<Feed>
        var showHideFeedAnim: Observable<(Feed, FeedCell)>
        
        var showMoveVillagePage: Observable<Void>
        var showUserProfilePage: Observable<User>
        
        var showFeedLikes: Observable<Void>
        
        let refreshControlCompleted: Observable<Void>
        let isLoadingSpinnerAvailable: Observable<Bool>
    }
    
    struct Dependencies {
        let showType: FeedShowType
        let feedUsecase: FeedUsecase
        let userUsecase: UserUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    var isPaginationRequestStillResume = false
    
    var isRefreshRequstStillResume = false
  
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        //MARK: Properties
        
        var nextPageURL: String?
        
        //MARK: Output Properties
        
        let userRelay = PublishRelay<User>()
        let fetchingFeed = PublishRelay<Void>()
        
        let feeds = BehaviorRelay<[Feed]>(value: [])
        let filteredFeeds = BehaviorRelay<[Feed]>(value: feeds.value)
        let selectedCategories = BehaviorRelay<[FeedCategory]>(value: [])
        
        
        let showFeedComments = PublishSubject<Feed>()
        let allCategories = BehaviorRelay<[FeedCategory]>(value: FeedCategory.allCases)
        let showFeedOptionsPage = PublishRelay<(Feed, FeedCell, [ActionSheetOption])>()
        
        let showEditPage = input.tapEditFeed.asObservable()
        let showDeleteFeedPage = PublishRelay<Void>()
        let showDeclarationPage = input.tapDeclaration.asObservable()
        let showHideFeedAnim = PublishRelay<(Feed, FeedCell)>()
        
        let showMoveVillagePage = input.tapMoveVillage.asObservable()
        let showUserProfilePage = input.tapUserProfile.asObservable()
        
        let showFeedLikes = PublishRelay<Void>()
    
        let refreshControlCompleted = PublishRelay<Void>()
        let isLoadingSpinnerAvailable = PublishRelay<Bool>()
        
        input.fetchUser
            .observe(on: MainScheduler.asyncInstance)
            .flatMap { [unowned self] in fetchUser() }
            .bind { [unowned self] result in
                switch result {
                case .success(let user):
                    userRelay.accept(user)
                    
                    input.tapFeedOption
                        .bind { (feed, cell) in
                            if feed.author.id == user.id {
                                showFeedOptionsPage.accept((feed, cell, [.edit, .delete]))
                            } else {
                                let hiddenType: ActionSheetOption = feed.isBlocked ?? false ? .cancelHide : .hide
                                showFeedOptionsPage.accept((feed, cell, [.declaration, hiddenType]))
                            }
                        }
                        .disposed(by: disposeBag)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("VillageViewModel - FetchUser Fail : \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.fetchFeeds
            .bind(to: fetchingFeed)
            .disposed(by: disposeBag)
        
        fetchingFeed
            .share()
            .filter { [unowned self] in isPaginationRequestStillResume == false && dependencies.showType != .showMyFeeds}
            .flatMap { [unowned self] in fetchFeeds()}
            .bind { result in
                switch result {
                case .success(let feedPage):
                    nextPageURL = feedPage.next
                    feeds.accept(feedPage.results)
                    filteredFeeds.accept(feedPage.results)

                case .errorResponse(let errorResponse):
                    Logger.printLog(errorResponse)
                }
            }
            .disposed(by: disposeBag)
        
        fetchingFeed
            .share()
            .filter { [unowned self] in isPaginationRequestStillResume == false && dependencies.showType == .showMyFeeds }
            .flatMap { [unowned self] in fetchUserFeeds()}
            .bind { result in
                switch result {
                case .success(let userFeedPage):
                    nextPageURL = userFeedPage.next
                    feeds.accept(userFeedPage.results.first?.feeds ?? [])
                    filteredFeeds.accept(userFeedPage.results.first?.feeds ?? [])

                case .errorResponse(let errorResponse):
                    Logger.printLog(errorResponse)
                }
            }
            .disposed(by: disposeBag)
        
        input.fetchMoreFeeds
            .filter { [unowned self] in nextPageURL != nil && isPaginationRequestStillResume == false }
            .do(onNext: { isLoadingSpinnerAvailable.accept(true)})
            .flatMap { [unowned self] _ in self.fetchMoreFeeds(nextPageURL: nextPageURL!)}
            .bind { [weak self] result in
                switch result {
                case .success(let feedPage):
                    nextPageURL = feedPage.next
                
                    feeds.accept(feeds.value + feedPage.results)
                    filteredFeeds.accept(feeds.value)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("피드 페이징 실패 \(errorResponse)")
                }
                
                isLoadingSpinnerAvailable.accept(false)
                self?.isPaginationRequestStillResume = false
            }
            .disposed(by: disposeBag)
            
        input.refreshControlAction
            .do(onNext: { feeds.accept([])})
            .bind { _ in
                fetchingFeed.accept(())
                refreshControlCompleted.accept(())
            }
            .disposed(by: disposeBag)
        
        input.tapFeed
            .flatMap { [unowned self] feed in
               return fetchFeed(feedID: feed.feedId)
            }
            .bind(onNext: { result in
                switch result {
                case .success(let feed):
                    showFeedComments.onNext(feed)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("fetchFeed Error \(errorResponse)")
                }
            })
            .disposed(by: disposeBag)
        
        input.tapCategory
            .flatMap { category -> Observable<[FeedCategory]> in
                    var categories = selectedCategories.value
                
                    if let firstIndex = categories.firstIndex(where: { $0.rawValue == category.rawValue }) {
                        categories.remove(at: firstIndex)
                    } else {
                        categories.append(category)
                    }
                    return Observable.of(categories)
            }
            .bind(to: selectedCategories)
            .disposed(by: disposeBag)
        
        selectedCategories
            .skip(1)
            .bind { categories in
                Logger.printLog(categories)
                if categories.count == 0 {
                    filteredFeeds.accept(feeds.value)
                    
                } else {
                    var newFilteredFeeds: [Feed] = []
                    categories.forEach { category in
                        feeds.value.forEach { feed in
                            if feed.category.contains(where: { $0.rawValue == category.rawValue }) {
                                print(category)
                                newFilteredFeeds.append(feed)
                            }
                        }
                    }
                    filteredFeeds.accept(newFilteredFeeds)
                }
            }
            .disposed(by: disposeBag)
    
        input.tapDeleteFeed
            .flatMap { [unowned self] in deleteFeed(feed: $0)}
            .bind { result in
                Logger.printLog(result)
                switch result {
                case .success(let result):
                    if result == true {
                        showDeleteFeedPage.accept(())
                        fetchingFeed.accept(())
                    } else {
                        Logger.printLog("게시물 삭제 실패")
                    }
                case .errorResponse(let errorResponse):
                    Logger.debugPrintLog(errorResponse)
                }
            }
            .disposed(by: disposeBag)
        
        input.tapHideFeed
            .bind { [weak self] (feed, feedCell) in
                guard let self = self else { return }
                
                self.hideFeed(feed: feed).asObservable()
                    .bind(onNext: { result in
                        switch result {
                        case .success(let response):
                            Logger.printLog(response)
                            
                            if let firstIndex = filteredFeeds.value.firstIndex(where: { $0.feedId == feed.feedId}) {
                                var currentFeeds = filteredFeeds.value
                                currentFeeds.remove(at: firstIndex)
                                feeds.accept(currentFeeds)
                                filteredFeeds.accept(currentFeeds)
                                
                                showHideFeedAnim.accept((feed, feedCell))
                            }
                            
                        case .errorResponse(let errorResponse):
                            Logger.printLog("FeedVM - 게시물 숨기기 에러 \(errorResponse)")
                        }
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.tapFeedLike
            .flatMap { [unowned self] feed in likeFeed(feed: feed)}
            .bind { result in
                switch result {
                case .success(let likeResponse):
                    Logger.printLog("좋아요 성공 \n \(likeResponse)")
                    showFeedLikes.accept(())
                case .errorResponse(let errorResponse):
                    Logger.printLog("feedVM - 좋아요 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        //MARK: Notification Binds
        
        VillageNotificationCenter.fetchFeed.addObserver()
            .map { _ in }
            .bind(to: fetchingFeed)
            .disposed(by: disposeBag)
        
        return Output(user: userRelay.asObservable(),
                      feeds: feeds.asObservable(),
                      filterdFeeds: filteredFeeds.asObservable(),
                      allCategories: allCategories.asObservable(),
                      selectedCategories: selectedCategories.asObservable(),
                      showFeedCommentsPage: showFeedComments.asObservable(),
                      showUploadFeedPage: input.tapUploadFeed.asObservable(),
                      showFeedOptionsPage: showFeedOptionsPage.asObservable(),
                      showEditPage: showEditPage.asObservable(),
                      showDeleteFeedPage: showDeleteFeedPage.asObservable(),
                      showDeclarationPage: showDeclarationPage.asObservable(),
                      showHideFeedAnim: showHideFeedAnim.asObservable(),
                      showMoveVillagePage: showMoveVillagePage.asObservable(),
                      showUserProfilePage: showUserProfilePage.asObservable(),
                      showFeedLikes: showFeedLikes.asObservable(),
                      refreshControlCompleted: refreshControlCompleted.asObservable(),
                      isLoadingSpinnerAvailable: isLoadingSpinnerAvailable.asObservable())
        
    }
    
    private func fetchFeeds() -> Single<NetworkResult<FeedPage>> {
        switch dependencies.showType {
        case .showAllFeeds:
            return dependencies.feedUsecase.fetchFeeds()
            
        case .showLikeFeeds:
            return dependencies.feedUsecase.fetchLikeFeeds()
            
        case .showHiddenFeeds:
            return dependencies.feedUsecase.fetchHiddenFeeds()
            
        case .showSaveFeeds:
            return dependencies.feedUsecase.fetchSaveFeeds()
            
        default: fatalError()
        }
    }
    
    private func fetchUserFeeds() -> Single<NetworkResult<UserFeedPage>> {
        return dependencies.feedUsecase.fetchMyFeeds()
    }
    
    private func fetchFeed(feedID: Int) -> Single<NetworkResult<Feed>> {
        return dependencies.feedUsecase.fetchFeed(feedID: feedID)
    }
    
    private func fetchUser() -> Single<NetworkResult<User>> {
        return dependencies.userUsecase.fetchUser()
    }
    
    private func deleteFeed(feed: Feed) -> Single<NetworkResult<Bool>> {
        return dependencies.feedUsecase.deleteFeed(feed: feed)
    }
    
    private func likeFeed(feed: Feed) -> Single<NetworkResult<LikeResponse>> {
        return dependencies.feedUsecase.likeFeed(feed: feed)
    }
    
    private func fetchMoreFeeds(nextPageURL: String) -> Single<NetworkResult<FeedPage>> {
        isPaginationRequestStillResume = true
        return dependencies.feedUsecase.fetchMoreFeeds(nextPageURL: nextPageURL)
    }
    
    private func hideFeed(feed: Feed) -> Single<NetworkResult<HideResponse>> {
        return dependencies.feedUsecase.hideFeed(feed: feed)
    }
}
