import RxSwift
import RxRelay

class CompetitionContentCommentViewModel: ViewModelType {
    
    struct Input {
        let fetching: Observable<Void>
    }
    
    struct Output {
        let content: Observable<Vote>
    }
    
    struct Dependencies {
        let content: Vote
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        let content = input.fetching.map { [unowned self] in dependencies.content }
        
        return Output(content: content.asObservable())
    }
}
