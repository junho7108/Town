import Foundation
import RxSwift
import KakaoSDKUser
import RxRelay

final class KakaoLoginManager: NSObject, SocialLoginManagerType {
    
    weak var viewController: UIViewController?
    
    var loginToken: PublishRelay<String> = .init()
    
    func signIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [unowned self] (oauthToken, error)in
                if let _ = error { return }
                else {
                    UserApi.shared.me { (user, error) in
                        if let _ = error { return }
                        else {
                            guard let token = oauthToken?.accessToken else { return }
                            self.loginToken.accept(token)
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [unowned self] (oauthToken, error) in
                if let _ = error { return }
                else {
                    UserApi.shared.me { (user, error) in
                        if let _ = error { return }
                        else {
                            guard let token = oauthToken?.accessToken else { return }
                            self.loginToken.accept(token)
                        }
                    }
                }
            }
        }
    }
    
    func signOut() {
        UserApi.shared.logout { [weak self] error in
            if let _ = error {
            } else {
                self?.unlink()
            }
        }
    }
    
    func unlink() {
        UserApi.shared.unlink { error in
        }
    }
}
