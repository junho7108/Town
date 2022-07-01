import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import RxSwift
import RxRelay

final class GoogleLoginManager: NSObject, SocialLoginManagerType {
  
    weak var viewController: UIViewController?
    
    var loginToken: PublishRelay<String> = .init()
    
    func signIn() {
        guard let vc = viewController else { return }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { [unowned self] user, error in
            if let _ = error { return }
            
            guard let authentication = user?.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let _ = error { return }
                loginToken.accept(authentication.idToken!)
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
