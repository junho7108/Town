import UIKit

class MoveVillageView: UICollectionView {
    
    //MARK: - Properties
    
    let loadingView = LoadingView()
  
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureUI()
        configureCollecctionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    private func configureCollecctionView() {
        register(VillageCell.self, forCellWithReuseIdentifier: VillageCell.identifier)
        register(MoveVillageHeaderView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: MoveVillageHeaderView.identifer)
        
    }
}
