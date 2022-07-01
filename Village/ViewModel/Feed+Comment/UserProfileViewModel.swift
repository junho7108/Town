import RxSwift
import RxRelay
import KakaoSDKUser

class UserProfileViewModel: ViewModelType {
    
    struct Input {
        let fetching: Observable<Void>
    }
    
    struct Output {
        let feeds: Observable<[Feed]>
    }
    
    struct Dependencies {
        let user: User
        let usecase: FeedUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let feeds = BehaviorRelay<[Feed]>(value: [])
        
        input.fetching
            .flatMap { [unowned self] in fetchFeeds()}
            .bind { [unowned self] result in
                switch result {
                case .success(let feedPage):
                    let userFeeds = feedPage.results.filter { $0.author.id == dependencies.user.id }
                    feeds.accept(userFeeds)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("userProfileVC - fetchFeeds Error: \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(feeds: feeds.asObservable())
    }
    
    private func fetchFeeds() -> Single<NetworkResult<FeedPage>> {
        return dependencies.usecase.fetchFeeds()
    }
}
