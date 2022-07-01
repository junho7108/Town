import Foundation
import NaverThirdPartyLogin
import Alamofire
import RxSwift
import RxRelay

final class NaverLoginManager: NSObject, SocialLoginManagerType {
   
    
    private let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
 
    weak var viewController: UIViewController?
    
    var loginToken: PublishRelay<String> = .init()
    
    func signIn() {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    func signOut() {
        loginInstance?.requestDeleteToken()
    }
    
    private func getNaverInfo(completion: @escaping ((Result<String, Error>) -> Void)) {
        print("Naver Login Info")
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow(),
              isValidAccessToken == true else { return }
        
        guard let tokenType = loginInstance?.tokenType,
              let accesstoken = loginInstance?.accessToken else { return }
        
        let urlString = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlString)!
        
        let authorization = "\(tokenType) \(accesstoken)"
        
        AF.request(url, method: .get,
                                 parameters: nil, encoding: JSONEncoding.default,
                                 headers: ["Authorization": authorization])
        
            .responseString { [unowned self] response in
                guard let result = response.value else { return }
              
                loginToken.accept(accesstoken)
                return completion(.success(result))
            }
    }
}

//MARK: - NaverThirdPartyLoginConnectionDelegate

extension NaverLoginManager: NaverThirdPartyLoginConnectionDelegate {
    
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverInfo { _ in
            
        }
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        guard let accessToken = loginInstance?.accessToken else { return }
        loginToken.accept(accessToken)
    }
    
    // 로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃")
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("에러 = \(error.localizedDescription)")
    }
}
