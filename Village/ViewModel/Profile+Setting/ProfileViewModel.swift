import RxSwift
import RxRelay

class ProfileViewModel: ViewModelType {
    
    struct Input {
        var fetchingUser: Observable<Void>
        var tapSettingOption: Observable<VillageSettingOption>
        var tapEditProfile: Observable<Void>
        var tapLogout: Observable<Void>
    }
    
    struct Output {
        var user: Observable<User>
        var showSelectedOptionPage: Observable<VillageSettingOption>
        var showEditProfilePage: Observable<Void>
        var showLogoutPage: Observable<Void>
        var errorMessage: Observable<String>
    }
    
    struct Dependencies {
        let usecase: UserUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let userRelay = PublishRelay<User>()
        let errorMessage = PublishRelay<String>()
        
        //MARK: INPUT
        
        let showLogoutPage: Observable<Void> = input.tapLogout
        
        showLogoutPage
            .bind { [weak self] in
                self?.signOutSocialAccount()
            }
            .disposed(by: disposeBag)
        
        input.fetchingUser
            .flatMap { [unowned self] in fetchUser() }
            .bind { result in
                switch result {
                case .success(let user):
                    userRelay.accept(user)

                case .errorResponse(let errorResponse):
                    let errorType = errorResponse.errorType()
                    errorMessage.accept(errorType.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(user: userRelay.asObservable(),
                      showSelectedOptionPage: input.tapSettingOption.asObservable(),
                      showEditProfilePage: input.tapEditProfile.asObservable(),
                      showLogoutPage: showLogoutPage.asObservable(),
                      errorMessage: errorMessage.asObservable())
    }
    
    private func fetchUser() -> Single<NetworkResult<User>> {
        return dependencies.usecase.fetchUser()
    }
    
    private func signOutSocialAccount() {
            KeyChainManager.deleteUserAccount()
            NaverLoginManager().signOut()
            GoogleLoginManager().signOut()
            KakaoLoginManager().signOut()
            AppleLoginManager().signOut()
        }
}
