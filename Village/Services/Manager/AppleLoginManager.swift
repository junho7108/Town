import AuthenticationServices
import RxSwift
import RxRelay

final class AppleLoginManager: NSObject, SocialLoginManagerType {

    weak var viewController: UIViewController?
    
    var loginToken: PublishRelay<String> = .init()
    
    func signIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self 
        controller.performRequests()
    }
    
    func signOut() {
        
    }
    
    func setAppleLoginPresentationAnchorView(_ view: UIViewController) {
        self.viewController = view
    }
}

//MARK: - ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding

extension AppleLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredentail as ASAuthorizationAppleIDCredential:
        
            let _ = appleIDCredentail.user
            let _ = appleIDCredentail.fullName
            let _ = appleIDCredentail.email
            
            let idToken = appleIDCredentail.identityToken!
            let tokenStr = String(data: idToken, encoding: .utf8)!
            loginToken.accept(tokenStr)
            
        default:
            break
        }
    }
        
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
