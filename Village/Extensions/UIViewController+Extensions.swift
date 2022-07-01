import UIKit

extension UIViewController {
    
    func showToast(message : String, duration: Double = 1.5) {
        let toastLabel = UILabel()
        
        toastLabel.text = message
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = .suitFont(size: 15, weight: .regular)
        toastLabel.numberOfLines = 0
        
        let toastBackgroundView = UIView()
        toastBackgroundView.backgroundColor = UIColor(hex: "#212529").withAlphaComponent(0.7)
        toastBackgroundView.clipsToBounds = true
        toastBackgroundView.layer.cornerRadius = 20
        
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(toastBackgroundView)
        toastBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.greaterThanOrEqualTo(208)
            make.height.greaterThanOrEqualTo(40)
        }
        
        toastBackgroundView.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(22)
            make.centerY.equalToSuperview()
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn) {
            toastBackgroundView.alpha = 0.0
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastBackgroundView.removeFromSuperview()
        }
    }
    
    func showImageView(image: UIImage) {
        let imageVC = PinchImageViewController(image: image)
        
        var superVC: UIViewController
        
        if let tabBarVC = self.tabBarController {
            superVC = tabBarVC
        } else {
            superVC = self.navigationController == nil ? self : self.navigationController!
        }
        
        superVC.present(imageVC, animated: false)
    }
}
