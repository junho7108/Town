import RxSwift
import RxRelay

protocol SocialLoginManagerType: AnyObject {

    var viewController: UIViewController? { get set }    
    var loginToken: PublishRelay<String> { get set }

    func signIn()
    func signOut()
}
