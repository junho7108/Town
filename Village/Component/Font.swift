import Foundation
import UIKit

extension UIFont {
    
    enum Family: String {
        case bold = "Bold"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case thin = "Thin"
    }

    static func suitFont(size: CGFloat, weight: SuitWeight = .regular) -> UIFont {
        return UIFont(name: "SUIT-\(weight.rawValue)", size: size)!
    }
    
    enum SuitWeight: String {
        /// weight 100
        case thin = "Thin"
        
        /// weight 200
        case extralight = "ExtraLight"
        
        /// weight 300
        case light = "Light"
        
        /// weight 400
        case regular = "Regular"
        
        /// weight 500
        case medium = "Medium"
        
        /// weight 600
        case semibold = "SemiBold"
        
        /// weight 700
        case bold = "Bold"
        
        /// weight 800
        case extrabold = "ExtraBold"
        
        /// weight 900
        case heavy = "Heavy"
    }
}
