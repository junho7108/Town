import Foundation
import RxSwift
import RxRelay

class WithdrawalViewModel: ViewModelType {
   
    struct Input {
        var tapAgreeButton: Observable<Void>
        var tapWithdrawalButton: Observable<Void>
        var tapWithdrawalCompleteButton: Observable<Void>
    }
    
    struct Output {
        var withdrawalButtonEnabled: Observable<Bool>
        var showWithdrawalPopup: Observable<Void>
        var showWithdrawalPage: Observable<Void>
        var errorMessage: Observable<String>
    }
    
    struct Dependencies {
        let usecase: UserUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    var dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let withdrawalButtonEnabled = BehaviorRelay<Bool>(value: false)
        let showWithdrawalPopup = PublishRelay<Void>()
        let showWithdrawPage = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        
        input.tapAgreeButton
            .map { !withdrawalButtonEnabled.value }
            .bind(to: withdrawalButtonEnabled)
            .disposed(by: disposeBag)
        
        input.tapWithdrawalButton
            .bind(to: showWithdrawalPopup)
            .disposed(by: disposeBag)
        
        input.tapWithdrawalCompleteButton
            .flatMap { [unowned self] _ in accountWithdrawal()}
            .bind { result in
                switch result {
                case .success(let result):
                    if result == true {
                        Logger.printLog("회원탈퇴 성공")
                        showWithdrawPage.accept(())
                    }
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("회원탈퇴 에러 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(withdrawalButtonEnabled: withdrawalButtonEnabled.asObservable(),
                      showWithdrawalPopup: showWithdrawalPopup.asObservable(),
                      showWithdrawalPage: showWithdrawPage.asObservable(),
                      errorMessage: errorMessage.asObservable())
    }
    
    private func accountWithdrawal() -> Single<NetworkResult<Bool>> {
        return dependencies.usecase.accountWithdrawal()
    }
}
