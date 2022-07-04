import Alamofire
import RxSwift

protocol AuthRepository: AnyObject {
    func signIn(accessToken: String, provider: SocialLoginType) -> Single<NetworkResult<UserAuthorization>>
    func signUp(request: SignUpRequest) -> Single<NetworkResult<UserAuthorization>>
    func checkNickname(nickname: String) -> Single<NetworkResult<DuplicateNicknameCheckResponse>>
}

final class AuthRepositoryImpl: AuthRepository {
   
    private let service: NetworkService
    
    init(service: NetworkService = NetworkService()) {
        self.service = service
    }
    
    func signIn(accessToken: String, provider: SocialLoginType) -> Single<NetworkResult<UserAuthorization>> {
        return service.loadSingle(request: AuthRouter.signIn(accessToken: accessToken, provider: provider))
    }
    
    func signUp(request: SignUpRequest) -> Single<NetworkResult<UserAuthorization>> {
        return service.loadSingle(request: AuthRouter.signUp(reqeust: request))
    }
    
    func checkNickname(nickname: String) -> Single<NetworkResult<DuplicateNicknameCheckResponse>> {
        return service.loadSingle(request: AuthRouter.checkNickname(nickname: nickname))
    }
}
