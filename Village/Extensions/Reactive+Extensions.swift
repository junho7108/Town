import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import AuthenticationServices
import FloatingPanel

extension Reactive where Base: UIScrollView {
    var contentSize: ControlEvent<CGSize> {
        let source = observe(CGSize.self, "contentSize")
            .compactMap { $0 }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: GIDSignInButton {
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}

extension Reactive where Base: ASAuthorizationAppleIDButton {
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}

extension Reactive where Base: FloatingPanelController {
    var delegate: DelegateProxy<FloatingPanelController, FloatingPanelControllerDelegate> {
        return RxFloatingPanelDelegateProxy.proxy(for: self.base)
    }
    
    public var didChangeState: Observable<FloatingPanelController> {
        return delegate.methodInvoked(#selector(FloatingPanelControllerDelegate.floatingPanelDidChangeState(_:)))
            .map({ (parameter) in
                return parameter.first as! FloatingPanelController
            })
    }
}

extension Reactive where Base: UIImagePickerController {
    public var didSelectImage: Observable<[UIImage]> {
        return RxImagePickerControllerDelegateProxy.proxy(for: base)
            .didSelectImage
            .asObservable()
    }

    public var didCancel: Observable<Void> {
        return RxImagePickerControllerDelegateProxy.proxy(for: base)
            .didCancelSubject
            .asObservable()
    }
}
