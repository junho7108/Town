import RxSwift
import RxRelay

enum DeclarationType {
    case AD, papering, abuse, sensational, suggest
}


final class DeclarationViewModel: ViewModelType {

    struct Input {
        let tapDeclarationType: Observable<DeclarationType>
        let contentDidChange: Observable<String>
        let tapCompleteButton: Observable<Void>
        let tapDeclarationButton: Observable<Void>
    }
    
    struct Output {
        let updateContent: Observable<String>
        let selectedDeclarationType: Observable<DeclarationType>
        let completeButtonEnabled: Observable<Bool>
        let showDeclarationConfirmPage: Observable<Void>
        let declarationComplete: Observable<Void>
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
