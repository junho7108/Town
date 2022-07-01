import UIKit

class EnableButton: UIButton {
    
    override var buttonType: UIButton.ButtonType {
        return .custom
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .villageSky : .grey200
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .villageSky
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .suitFont(size: 15, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
