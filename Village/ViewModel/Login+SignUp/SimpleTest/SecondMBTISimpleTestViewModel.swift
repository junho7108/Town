import RxSwift
import RxRelay

class SecondMBTISimpleTestViewModel: ViewModelType {
    
    struct Input {
        var tapSButton: Observable<Void>
        var tapNButton: Observable<Void>
        var tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        var selectedSecondIndex: Observable<MBTIInformation>
        var completeButtonEnabled: Observable<Bool>
        var showThirdMBTITestPage: Observable<(MBTIEnergy, MBTIInformation)>
    }
    
    struct Dependencies {
        var mbtiFirstIndex: MBTIEnergy
    }
    
    var disposeBag: DisposeBag = .init()
    
    var dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        
        let firstIndex = dependencies.mbtiFirstIndex
        
        let selectedSecondIndex = PublishRelay<MBTIInformation>()
        let completeButtonEnabled = BehaviorRelay<Bool>(value: false)
        let showThirdMBTITestPage = PublishRelay<(MBTIEnergy, MBTIInformation)>()
        
        Observable.merge([
            input.tapSButton.map { MBTIInformation.S },
            input.tapNButton.map { MBTIInformation.N }
        ])
            .bind(onNext: { info in
                selectedSecondIndex.accept(info)
                completeButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.tapCompleteButton
            .withLatestFrom(selectedSecondIndex)
            .map { (firstIndex, $0)}
            .bind(to: showThirdMBTITestPage)
            .disposed(by: disposeBag)
        
        return Output(selectedSecondIndex: selectedSecondIndex.asObservable(),
                      completeButtonEnabled: completeButtonEnabled.asObservable(),
                      showThirdMBTITestPage: showThirdMBTITestPage.asObservable())
    }
}
