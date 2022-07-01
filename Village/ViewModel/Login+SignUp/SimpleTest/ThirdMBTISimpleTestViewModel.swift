import RxSwift
import RxRelay

class ThirdMBTISimpleTestViewModel: ViewModelType {
    
    struct Input {
        var tapFButton: Observable<Void>
        var tapTButton: Observable<Void>
        var tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        var selectedThirdIndex: Observable<MBTIDecisions>
        var completeButtonEnabled: Observable<Bool>
        var showLastMBTITestPage: Observable<(MBTIEnergy, MBTIInformation, MBTIDecisions)>
    }
    
    struct Dependencies {
        var mbtiFirstIndex: MBTIEnergy
        var mbtiSecondIndex: MBTIInformation
    }
    
    var disposeBag: DisposeBag = .init()
    
    var dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        
        let firstIndex = dependencies.mbtiFirstIndex
        let secondIndex = dependencies.mbtiSecondIndex
        
        let selectedThirdIndex = PublishRelay<MBTIDecisions>()
        let completeButtonEnabled = BehaviorRelay<Bool>(value: false)
        let showLastMBTITestPage = PublishRelay<(MBTIEnergy, MBTIInformation, MBTIDecisions)>()
        
        Observable.merge([
            input.tapFButton.map { MBTIDecisions.F },
            input.tapTButton.map { MBTIDecisions.T }
        ])
            .bind(onNext: { decisions in
                selectedThirdIndex.accept(decisions)
                completeButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.tapCompleteButton
            .withLatestFrom(selectedThirdIndex)
            .map { (firstIndex, secondIndex, $0)}
            .bind(to: showLastMBTITestPage)
            .disposed(by: disposeBag)
        
        return Output(selectedThirdIndex: selectedThirdIndex.asObservable(),
                      completeButtonEnabled: completeButtonEnabled.asObservable(),
                      showLastMBTITestPage: showLastMBTITestPage.asObservable())
    }
}
