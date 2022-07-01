import UIKit

class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    var cellSpacing: CGFloat = 8
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = cellSpacing
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1
        
        attributes?.forEach({ layoutAttibutes in
            if layoutAttibutes.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttibutes.frame.origin.x = leftMargin
            leftMargin += layoutAttibutes.frame.width + cellSpacing
            maxY = max(layoutAttibutes.frame.maxY, maxY)
        })
       
        return attributes
    }
}
