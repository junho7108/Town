import RxSwift
import RxCocoa

struct DuplicateNicknameCheckResponse: Codable {
    let duplicate: Bool
}

class SignUpNicknameViewModel: ViewModelType {
    
    struct Input {
        let editUserNickname: Observable<String>
        let tapCompleteButton: Observable<Void>
    }
    
    struct Output {
        let showSignUpProfilePage: Observable<SignUpRequest>
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
        let userNickname = PublishRelay<String>()
        let availableNickname = PublishRelay<Void>()
        let validateNickname = PublishRelay<Void>()
        
        let showSignUpProfilePage = PublishRelay<SignUpRequest>()
        let showErrorMessage = PublishRelay<String>()
        
        input.editUserNickname
            .bind(to: userNickname)
            .disposed(by: disposeBag)
        
        input.tapCompleteButton
            .withLatestFrom(userNickname)
            .map { $0.validNicknameCheck() }
            .bind(onNext: { result in
                if result {
                    validateNickname.accept(())
                } else { showErrorMessage.accept("닉네임 규정에 맞지 않습니다.") }
            })
            .disposed(by: disposeBag)
        
        validateNickname
            .withLatestFrom(userNickname)
            .flatMap { [unowned self] nickname in
                checkNickname(nickname: nickname)
            }
            .bind { result in
                switch result {
                case .success(let result):
                    if result.duplicate { // 닉네임이 중복 된 경우
                        showErrorMessage.accept(VillageError.duplicateNickname.localizedDescription)
                    } else { // 닉네임이 중복되지 않는 경우
                        availableNickname.accept(())
                    }
                
                case .errorResponse(let error):
                    let errorType = error.errorType()
                    showErrorMessage.accept(errorType.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
            
        availableNickname
            .withLatestFrom(userNickname)
            .map { nickname -> SignUpRequest in
                var request = request.value
                request.nickname = nickname
                return request
            }
            .bind(to: showSignUpProfilePage)
            .disposed(by: disposeBag)
            
        
        return Output(showSignUpProfilePage: showSignUpProfilePage.asObservable(),
                      showErrorMessage: showErrorMessage.asObservable())
    }
    
    private func checkNickname(nickname: String) -> Single<NetworkResult<DuplicateNicknameCheckResponse>> {
        return dependencies.usecase.checkNickname(nickname: nickname)
    }
}
