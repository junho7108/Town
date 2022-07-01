import UIKit
class EditTextField: BaseTextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        font = .suitFont(size: 17, weight: .medium)
        backgroundColor = .grey100
        layer.cornerRadius = 24
        
        let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 0))
        leftView = leftPaddingView
        leftViewMode = .always
        
        let rightPaddingView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 0))
        rightView = rightPaddingView
        rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
