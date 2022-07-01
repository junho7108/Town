import RxSwift
import RxCocoa
import FloatingPanel
import UIKit

public typealias ImagePickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension UIImagePickerController: HasDelegate {
    public typealias Delegate = ImagePickerDelegate
}

class RxFloatingPanelDelegateProxy:
    DelegateProxy<FloatingPanelController, FloatingPanelControllerDelegate>,
    DelegateProxyType,
    FloatingPanelControllerDelegate {
    
    static func registerKnownImplementations() {
        self.register { parent in
            RxFloatingPanelDelegateProxy(parentObject: parent, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: FloatingPanelController) -> FloatingPanelControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: FloatingPanelControllerDelegate?, to object: FloatingPanelController) {
        object.delegate = delegate
    }
}

class RxImagePickerControllerDelegateProxy:
    DelegateProxy<UIImagePickerController, ImagePickerDelegate>,
    DelegateProxyType,
    ImagePickerDelegate {
    
    lazy var didSelectImage = PublishSubject<[UIImage]>()
    lazy var didCancelSubject = PublishSubject<Void>()
    
    init(imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerControllerDelegateProxy.self)
    }
    
    //MARK:- DelegateProxyType
    
    public static func registerKnownImplementations() {
        self.register { RxImagePickerControllerDelegateProxy(imagePicker: $0) }
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> ImagePickerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ImagePickerDelegate?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            didSelectImage.onNext([possibleImage])
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            didSelectImage.onNext([possibleImage])
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancelSubject.onNext(())
    }
}
