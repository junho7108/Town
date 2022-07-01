import RxSwift
import RxRelay

enum DeclarationType {
    case AD, papering, abuse, sensational, suggest
}


class DeclarationViewModel: ViewModelType {

    struct Input {
        var tapDeclarationType: Observable<DeclarationType>
        var contentDidChange: Observable<String>
        var tapCompleteButton: Observable<Void>
        var tapDeclarationButton: Observable<Void>
    }
    
    struct Output {
        var updateContent: Observable<String>
        var selectedDeclarationType: Observable<DeclarationType>
        var completeButtonEnabled: Observable<Bool>
        var showDeclarationConfirmPage: Observable<Void>
        var declarationComplete: Observable<Void>
    }
   
    struct Dependencies {
        
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let updateContent = input.contentDidChange
        let selectedDeclarationType = input.tapDeclarationType
        let completeButtonEnabled = BehaviorRelay<Bool>(value: false)
        let showDeclarationConfirmPage = input.tapCompleteButton
        let declarationComplete = input.tapDeclarationButton
        
        selectedDeclarationType
            .map { _ in return true }
            .bind(to: completeButtonEnabled)
            .disposed(by: disposeBag)
        
        return Output(updateContent: updateContent.asObservable(),
                      selectedDeclarationType: selectedDeclarationType.asObservable(),
                      completeButtonEnabled: completeButtonEnabled.asObservable(),
                      showDeclarationConfirmPage: showDeclarationConfirmPage.asObservable(),
                      declarationComplete: declarationComplete.asObservable())
    }
}
