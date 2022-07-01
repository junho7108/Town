import UIKit

class SelectTextField: EditTextField {
   
    init(placeholder: String, inputView: UIView, inputAccessoryView: UIView?) {
        inputAccessoryView?.backgroundColor = .clear
        inputAccessoryView?.clearsContextBeforeDrawing = true
        super.init(placeholder: placeholder)
       
        self.inputAccessoryView = inputAccessoryView
        self.inputView = inputView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
