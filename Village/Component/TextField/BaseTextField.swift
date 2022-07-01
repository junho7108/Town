import UIKit

class BaseTextField: UITextField {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
