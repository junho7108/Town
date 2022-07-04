import RxSwift
import RxRelay

final class FirstMBTISimpleTestViewModel: ViewModelType {
    
    struct Input {
        var tapEButton: Observable<Void>
        var tapIButton: Observable<Void>
        var tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        var selectedFirstIndex: Observable<MBTIEnergy>
        var completeButtonEnabled: Observable<Bool>
        var showSecondMBTITestPage: Observable<MBTIEnergy>
    }
    
    struct Dependencies {
        
    }
    
    var disposeBag: DisposeBag = .init()
    
    var dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let selectedFirstIndex = PublishRelay<MBTIEnergy>()
        let completeButtonEnabled = BehaviorRelay<Bool>(value: false)
        let showSecondMBTITestPage = PublishRelay<MBTIEnergy>()
        
        Observable.merge([
            input.tapEButton.map { MBTIEnergy.E },
            input.tapIButton.map { MBTIEnergy.I }
        ])
            .bind(onNext: { energy in
                selectedFirstIndex.accept(energy)
                completeButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.tapCompleteButton
            .withLatestFrom(selectedFirstIndex)
            .bind(to: showSecondMBTITestPage)
            .disposed(by: disposeBag)
        
        return Output(selectedFirstIndex: selectedFirstIndex.asObservable(),
                      completeButtonEnabled: completeButtonEnabled.asObservable(),
                      showSecondMBTITestPage: showSecondMBTITestPage.asObservable())
    }
}
