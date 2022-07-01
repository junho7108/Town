import UIKit
import RxSwift

class FeedMBTICell: BaseTagCell {
    
    //MARK: - Properties
    
    static let identifier = "FeedMBTICellIdentifier"

    private(set) var mbtiType: MBTIType!
    
  
    //MARK: - Configures

    func configureUI(mbtiType: MBTIType, isSelected: Bool = false) {
        self.mbtiType = mbtiType
        self.titleLabel.text = mbtiType.emojiTitle
        selectCategory(isSelected: isSelected)
    }
}
