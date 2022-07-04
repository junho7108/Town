import RxSwift
import RxRelay

final class MBTISimpleTestFinishViewModel: ViewModelType {
    
    struct Input {
        let tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        let mbti: Observable<MBTIType>
        let showSignUpPage: Observable<Void>
    }
    
    struct Dependencies {
        let mbti: MBTIType
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
