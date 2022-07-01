import UIKit
import RxSwift

class FeedCategoryCell: BaseTagCell {
    
    //MARK: - Properties

    static let identifier = "FeedCategoryCellIdentifier"

    private(set) var feedCategory: FeedCategory!
 
  
    //MARK: - Configures
    
    func configureUI(feedCategory: FeedCategory, isSelected: Bool = false) {
        self.feedCategory = feedCategory
        self.titleLabel.text = feedCategory.title
        selectCategory(isSelected: isSelected)
    }
}
