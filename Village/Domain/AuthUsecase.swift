import RxSwift

final class AuthUsecase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func signUp(request: SignUpRequest) -> Single<NetworkResult<UserAuthorization>> {
        return repository.signUp(request: request)
    }
    
    func signIn(socialAccessToken: String, provider: SocialLoginType) -> Single<NetworkResult<UserAuthorization>> {
        return repository.signIn(accessToken: socialAccessToken, provider: provider)
    }
    
    func checkNickname(nickname: String) -> Single<NetworkResult<DuplicateNicknameCheckResponse>> {
        return repository.checkNickname(nickname: nickname)
    }
}
