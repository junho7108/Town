import UIKit

class LoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 327, height: 48))
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFill
        
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .suitFont(size: 17, weight: .semibold)
      
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 287)
        
        adjustsImageWhenHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
