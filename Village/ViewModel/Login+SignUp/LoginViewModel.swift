import RxSwift
import RxRelay
import AuthenticationServices
import KakaoSDKCommon

enum SocialLoginType: String, Codable {
    case apple, google, kakao, naver
    
    var title: String {
        switch self {
        case .apple: return "애플 계정 회원"
        case .google: return "구글 계정 회원"
        case .kakao: return "카카오 계정 회원"
        case .naver: return "네이버 계정 회원"
        }
    }
}

class LoginViewModel: ViewModelType {
    
    struct Input {
        var tapSocialLogin: Observable<SocialLoginType>
    }
    
    struct Output {
        var showSignUpPage: Observable<SignUpRequest>
        var showMainPage: Observable<Void>
        var showErrorMessage: Observable<String>
        var activated: Observable<Bool>
    }
    
    struct Dependencies {
        let usecase: AuthUsecase
        let naverLoginManager: SocialLoginManagerType
        let appleLoginManager: SocialLoginManagerType
        let googleLoginManager: SocialLoginManagerType
        let kakaoLoginManager: SocialLoginManagerType
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {

        let showSignUpPage = PublishRelay<SignUpRequest>()
        let showMainPage = PublishRelay<Void>()
        let showErrorMessage = PublishRelay<String>()
        let activated = BehaviorRelay<Bool>(value: false)
       
        let signUpRequest = BehaviorRelay<SignUpRequest>(value: SignUpRequest())
       
        input.tapSocialLogin
            .bind { [unowned self] loginType in
                switch loginType {
                case .apple: dependencies.appleLoginManager.signIn()
                case .kakao: dependencies.kakaoLoginManager.signIn()
                case .google: dependencies.googleLoginManager.signIn()
                case .naver: dependencies.naverLoginManager.signIn()
                }
            }
            .disposed(by: disposeBag)
            
        
        let appleLoginResult = dependencies.appleLoginManager.loginToken.map { SignUpRequest(accessToken: $0, provider: .apple) }
        let kakaoLoginResult = dependencies.kakaoLoginManager.loginToken.map { SignUpRequest(accessToken: $0, provider: .kakao) }
        let naverLoginResult = dependencies.naverLoginManager.loginToken.map { SignUpRequest(accessToken: $0, provider: .naver) }
        let googleLoginResult = dependencies.googleLoginManager.loginToken.map { SignUpRequest(accessToken: $0, provider: .google) }
        
        Observable.merge([
            appleLoginResult,
            kakaoLoginResult,
            naverLoginResult,
            googleLoginResult
        ])
            .bind(to: signUpRequest)
            .disposed(by: disposeBag)
        
        signUpRequest
            .skip(1)
            .do(onNext: { _ in activated.accept(true)})
            .flatMap { [unowned self] in trySignIn(socialAccessToken: $0.accessToken!, provider: $0.provider!) }
            .do(onNext: { _ in activated.accept(false)})
            .bind { [weak self] result in
                switch result {
                case .success(let token):
                    KeyChainManager.saveUserAuthorization(authorization: token)
                    showMainPage.accept(())
                    
                case .errorResponse(let error):
                    let errorType = error.errorType()
                 
                    switch errorType {
                    case .unregisteredUser:
                        showSignUpPage.accept(signUpRequest.value)
                        
                        
                    default:
                        showErrorMessage.accept(errorType.localizedDescription)
                        self?.signOutSocialAccount()
                    }
                }
            }
            .disposed(by: disposeBag)
            

        return Output(showSignUpPage: showSignUpPage.asObservable(),
                      showMainPage: showMainPage.asObservable(),
                      showErrorMessage: showErrorMessage.asObservable(),
                      activated: activated.asObservable())
    }
    
    private func trySignIn(socialAccessToken: String, provider: SocialLoginType) -> Single<NetworkResult<UserAuthorization>> {
        KeyChainManager.saveSocialProvider(provider: provider)
        KeyChainManager.saveSocialAccessToken(accessToken: socialAccessToken)
        return dependencies.usecase.signIn(socialAccessToken: socialAccessToken, provider: provider)
    }
    
    private func signOutSocialAccount() {
        dependencies.naverLoginManager.signOut()
        dependencies.googleLoginManager.signOut()
        dependencies.kakaoLoginManager.signOut()
        dependencies.appleLoginManager.signOut()
    }
}
