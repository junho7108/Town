import Foundation
import RxKakaoSDKCommon
import KakaoSDKCommon
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import RxSwift
import RxRelay

class RxKakaoLoginManager: NSObject, SocialLoginManagerType {

    var loginToken: PublishRelay<String> = .init()
    
    weak var viewController: UIViewController?
    
    let disposeBag = DisposeBag()
    
    
    func signIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .bind { [unowned self] oauthToken in
                    loginToken.accept(oauthToken.accessToken)
                }
                .disposed(by: disposeBag)
               
            
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .bind { [unowned self] oauthToken in
                    loginToken.accept(oauthToken.accessToken)
                }
                .disposed(by: disposeBag)
        }
    }
    
    func signOut() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                print("카카오 로그아웃에 성공하였습니다.")
            }, onError: { error in
                 print("카카오 로그아웃에 실패하였습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    func unlink() {
        UserApi.shared.rx.unlink()
            .subscribe(onCompleted: {
                print("카카오계정 연결 해제에 성공하였습니다.")
            }, onError: { error in
                print("카카오계정 연결 해제에 실패하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}
