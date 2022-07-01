import RxSwift
import RxRelay

class MBTISimpleTestFinishViewModel: ViewModelType {
    
    struct Input {
        var tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        var mbti: Observable<MBTIType>
        var showSignUpPage: Observable<Void>
    }
    
    struct Dependencies {
        var mbti: MBTIType
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let mbti = BehaviorRelay<MBTIType>(value: dependencies.mbti)
        let showSignUpPage = input.tapCompleteButton.asObservable()
       
        return Output(mbti: mbti.asObservable(),
                      showSignUpPage: showSignUpPage.asObservable())
    }
}
