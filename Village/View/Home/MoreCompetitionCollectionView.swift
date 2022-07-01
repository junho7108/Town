import UIKit

class MoreCompetitionCollectionView: UICollectionView {
    
    //MARK: - UI Properties

    //MARK: - Lifecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .grey100
    }
    
    private func configureCollectionView() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(CompetitionCollectionCell.self,
                                forCellWithReuseIdentifier: CompetitionCollectionCell.identifier)
    }
}
