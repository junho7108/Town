import UIKit

class ShadowView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
