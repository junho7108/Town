import RxSwift
import RxRelay

class MoreCompetitionViewModel: ViewModelType {
    
    struct Input {
        var fetching: Observable<Void>
        var tapCompetitionContent: Observable<Vote>
    }
    
    struct Output {
        var competitionContents: Observable<[Vote]>
        var showDetailCompetitionContentPage: Observable<Vote>
    }
    
    struct Dependencies {
        let usecase: CompetitionContentsUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let competitionContents = BehaviorRelay<[Vote]>(value: [])
        let showDetailCompetitionContentPage = input.tapCompetitionContent
        
        input.fetching
            .flatMap { [unowned self] in fetchCompetitionContents() }
            .bind(to: competitionContents)
            .disposed(by: disposeBag)
        
        return Output(competitionContents: competitionContents.asObservable(),
                      showDetailCompetitionContentPage: showDetailCompetitionContentPage.asObservable())
    }
    
    private func fetchCompetitionContents() -> Single<[Vote]> {
        return dependencies.usecase.fetchCompetitionContents()
    }
}
