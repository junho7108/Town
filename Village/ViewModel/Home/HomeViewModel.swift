import RxSwift
import RxRelay

class HomeViewModel: ViewModelType {
    
    struct Input {
        let fetching: Observable<Void>
        let tapMoreCompetitionButton: Observable<Void>
    }
    
    struct Output {
        let user: Observable<User>
        let competitionVotes: Observable<[Vote]>
        let errorMessage: Observable<String>
        let activating: Observable<Bool>
        let showMoreCompetitionPage: Observable<Void>
    }
    
    struct Dependencies {
        let userUsecase: UserUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
    }
    
    func transform(input: Input) -> Output {
        
        let user = PublishRelay<User>()
        let errorMessage = PublishRelay<String>()
        let activating = BehaviorRelay<Bool>(value: false)
        let showMoreCompetitionPage = input.tapMoreCompetitionButton
        
        input.fetching
            .do(onNext: { activating.accept(true) })
            .flatMap { [unowned self] in fetchUser() }
            .bind { result in
                activating.accept(false)
                
                switch result {
                case .success(let userData):
                    user.accept(userData)
                    
                case .errorResponse(let errorResponse):
                    let error = errorResponse.errorType()
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(user: user.asObservable(),
                      competitionVotes: Observable.of([Vote(voteId: 3,
                                                            title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                                                            choice: [VoteContent(voteContentId: 1, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                                                                     VoteContent(voteContentId: 2, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)]),
                                                       
                                                       Vote(voteId: 4,
                                                            title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                                                            choice: [VoteContent(voteContentId: 3, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                                                                     VoteContent(voteContentId: 4, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)]),
                                                      ]),
                      errorMessage: errorMessage.asObservable(),
                      activating: activating.asObservable(),
                      showMoreCompetitionPage: showMoreCompetitionPage.asObservable())
    }
    
    //MARK: - API
    private func fetchUser() -> Single<NetworkResult<User>> {
        return dependencies.userUsecase.fetchUser()
    }
}
