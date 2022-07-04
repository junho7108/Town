import RxSwift
import RxCocoa
import KakaoSDKUser

final class SignUpProfileViewModel: ViewModelType {
    
    struct Input {
        let tapSelectGender: Observable<Gender>
        let tapSelectDate: Observable<String>
        let tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        let completeButtonEnabled: Observable<Bool>
        let showMainPage: Observable<Void>
        let activating: Observable<Bool>
        let showErrorMessage: Observable<String>
    }
    
    struct Dependencies {
        let usecase: AuthUsecase
        let request: SignUpRequest
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let request = BehaviorRelay<SignUpRequest>(value: dependencies.request)
        let selectedGender = input.tapSelectGender.asObservable()
        let selectedDate = input.tapSelectDate
        let completeButtonEnabled = BehaviorRelay<Bool>(value: false)
        
        let signUpAuthToken = PublishRelay<NetworkResult<UserAuthorization>>()
        let showMainPage = PublishRelay<Void>()
        
        let activating = BehaviorRelay<Bool>(value: false)
        let showErrorMessage = PublishRelay<String>()
    
        input.tapCompleteButton
            .do(onNext: { _ in activating.accept(true)})
            .flatMap { [unowned self] in requestSignUp(request: request.value) }
            .do(onNext: { _ in activating.accept(false)})
            .bind(to: signUpAuthToken)
            .disposed(by: disposeBag)
        
        signUpAuthToken
            .bind { result in
                switch result {
                case .success(let token):
                    KeyChainManager.saveUserAuthorization(authorization: token)
                    showMainPage.accept(())
                    
                case .errorResponse(let error):
                    let errorType = error.errorType()
                    showErrorMessage.accept(errorType.localizedDescription)
                    
                    switch errorType {
                    case .serverError:
                        Logger.printLog("회원가입 요청 실패 서버 에러: \(error)")
                        
                    default:
                        Logger.printLog("회원가입 요청 실패 에러: \(error)")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        selectedDate
            .share()
            .map { dateString -> SignUpRequest in
                var signUpReqeust = request.value
                signUpReqeust.birthDateString = dateString
                return signUpReqeust
            }
            .bind(to: request)
            .disposed(by: disposeBag)
        
        selectedGender
            .share()
            .map { gender -> SignUpRequest in
                var signUpRequest = request.value
                signUpRequest.gender = gender
                return signUpRequest
            }
            .bind(to: request)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(selectedDate.asObservable(), selectedGender.asObservable()) { (left, right) in true }
        .bind(to: completeButtonEnabled)
        .disposed(by: disposeBag)

        return Output(completeButtonEnabled: completeButtonEnabled.asObservable(),
                      showMainPage: showMainPage.asObservable(),
                      activating: activating.asObservable(),
                      showErrorMessage: showErrorMessage.asObservable())
    }
    
    private func requestSignUp(request: SignUpRequest) -> Single<NetworkResult<UserAuthorization>> {
        return dependencies.usecase.signUp(request: request)
    }
}
