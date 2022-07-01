import UIKit

extension UIBarButtonItem {
    convenience init(image: UIImage, title: String, titleLeftPadding: CGFloat = 8.0, target: Any? = nil, action: Selector? = nil) {
        let button = UIButton(type: .system)
        
        let labelWidth = (title as NSString).size(withAttributes: [.font: UIFont.suitFont(size: 20, weight: .bold)]).width
        
        button.frame = CGRect(x: 0, y: 0, width: image.size.width + titleLeftPadding + labelWidth + 24,
                              height: image.size.height)
        
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = .zero
        
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.imageEdgeInsets = .zero
        
        button.titleLabel?.font = .suitFont(size: 20, weight: .bold)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleLeftPadding, bottom: 0, right: 0)
        
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
     
        self.init(customView: button)
    }
}
