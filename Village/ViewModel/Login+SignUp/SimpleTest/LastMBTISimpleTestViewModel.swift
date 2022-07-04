import RxSwift
import RxRelay

final class LastMBTISimpleTestViewModel: ViewModelType {
    
    struct Input {
        var tapJButton: Observable<Void>
        var tapPButton: Observable<Void>
        var tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        var selectedLastIndex: Observable<MBTILifestyle>
        var completeButtonEnabled: Observable<Bool>
        var showTestFinishPage: Observable<MBTIType>
    }
    
    struct Dependencies {
        var mbtiFirstIndex: MBTIEnergy
        var mbtiSecondIndex: MBTIInformation
        var mbtiThirdIndex: MBTIDecisions
    }
    
    var disposeBag: DisposeBag = .init()
    
    var dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        
        let firstIndex = dependencies.mbtiFirstIndex
        let secondIndex = dependencies.mbtiSecondIndex
        let thirdIndex = dependencies.mbtiThirdIndex
        
        let selectedLastIndex = PublishRelay<MBTILifestyle>()
        let completeButtonEnabled = BehaviorRelay<Bool>(value: false)
        let showSignUpPage = PublishRelay<MBTIType>()
        
        Observable.merge([
            input.tapJButton.map { MBTILifestyle.J },
            input.tapPButton.map { MBTILifestyle.P }
        ])
            .bind(onNext: { life in
                selectedLastIndex.accept(life)
                completeButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.tapCompleteButton
            .withLatestFrom(selectedLastIndex)
            .map { MBTIType(firstIndex: firstIndex, secondIndex: secondIndex, thirdIndex: thirdIndex, lastIndex: $0) }
            .bind(to: showSignUpPage)
            .disposed(by: disposeBag)
        
        return Output(selectedLastIndex: selectedLastIndex.asObservable(),
                      completeButtonEnabled: completeButtonEnabled.asObservable(),
                      showTestFinishPage: showSignUpPage.asObservable())
    }
}
