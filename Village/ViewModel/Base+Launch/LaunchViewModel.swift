import RxSwift
import RxRelay
import KakaoSDKUser
import KakaoSDKAuth

final class LaunchViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let showMainPage: Observable<Void>
        let showSignUpPage: Observable<Void>
        let showErrorMessage: Observable<String>
    }
    
    struct Dependencies {
        let usecase: AuthUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
    
        let showMainPage = PublishRelay<Void>()
        let showSignUpPage = PublishRelay<Void>()
        let showErrorMessage = PublishRelay<String>()
        
        let accessTokenRelay = PublishRelay<String>()
        let providerRelay = PublishRelay<SocialLoginType>()
        
        let requestSignInResult = PublishRelay<NetworkResult<UserAuthorization>>()
        
        input.viewDidLoad
            .bind { _ in
                guard let accessToken = KeyChainManager.loadSocialAccessToken(),
                      let provider = KeyChainManager.loadSocialProvider() else {
                          KeyChainManager.deleteUserAccount()
                          showSignUpPage.accept(())
                          return
                      }
                switch provider {
                    
                case .apple:
                    break
                    
                case .google:
                    break
                    
                case .kakao:
                    if AuthApi.hasToken() {
                        AuthApi.shared.refreshToken { token, error in
                            if let _ = error {
                                showSignUpPage.accept(())
                                KeyChainManager.deleteUserAccount()
                                return
                            } else {
                                KeyChainManager.saveSocialAccessToken(accessToken: token!.accessToken)
                                KeyChainManager.saveSocialProvider(provider: .kakao)
                            }
                        }
                    } else {
                        showSignUpPage.accept(())
                        KeyChainManager.deleteUserAccount()
                    }
                    
                case .naver:
                    break
                }
                
                accessTokenRelay.accept(accessToken)
                providerRelay.accept(provider)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(accessTokenRelay, providerRelay) { (accessToken, provider) in
            (accessToken, provider)
        }
        .flatMap { [unowned self] in trySignIn(accessToken: $0, provider: $1) }
        .bind(to: requestSignInResult)
        .disposed(by: disposeBag)
        
        requestSignInResult
            .bind { result in
                switch result {
                case .success(let userAuth):
                    KeyChainManager.saveUserAuthorization(authorization: userAuth)
                    showMainPage.accept(())
                    
                case .errorResponse(let errorResponse):
                    let error = errorResponse.errorType()
                    showErrorMessage.accept(error.localizedDescription)
                    showSignUpPage.accept(())
                    KeyChainManager.deleteUserAccount()
                }
            }
            .disposed(by: disposeBag)
        
        return Output(showMainPage: showMainPage.asObservable(),
                      showSignUpPage: showSignUpPage.asObservable(),
                      showErrorMessage: showErrorMessage.asObservable())
    }
    
    private func trySignIn(accessToken: String, provider: SocialLoginType) -> Observable<NetworkResult<UserAuthorization>> {
        return dependencies.usecase.signIn(socialAccessToken: accessToken, provider: provider).asObservable()
    }
}
