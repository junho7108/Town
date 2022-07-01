import UIKit

class FeedView: BaseView {
    
    //MARK: - Properties
    
    //MARK: - UI Properties
    
    let refreshControl = UIRefreshControl()
  
    let villageBarButton = MoveVillageBarButtonView()
 
    let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.contentMode = .scaleToFill
        button.backgroundColor = .villageSky
        button.setImage(#imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    private(set) lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    private(set) var feedTableView = UITableView()
    
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor  = .grey100
        feedTableView.refreshControl = refreshControl
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .villageSky
        
//        addSubview(categoryCollectionView)
//        categoryCollectionView.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(48)
//        }
    
        addSubview(feedTableView)
        feedTableView.snp.makeConstraints { make in
//            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        addSubview(uploadButton)
        uploadButton.layer.cornerRadius = 56 / 2
        uploadButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(56)
        }
    }
    
    private func configureTableView() {
        feedTableView.backgroundColor = .grey100
        feedTableView.showsVerticalScrollIndicator = false
        feedTableView.showsHorizontalScrollIndicator = false
        feedTableView.separatorStyle = .none
        
        feedTableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
       
        feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.estimatedRowHeight = 400
        
        feedTableView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func configureCollectionView() {
        categoryCollectionView.backgroundColor = .white
        categoryCollectionView.clipsToBounds = true
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56)
        categoryCollectionView.register(FeedCategoryCell.self, forCellWithReuseIdentifier: FeedCategoryCell.identifier)
    }
}
