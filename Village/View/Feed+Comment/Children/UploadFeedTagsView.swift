import UIKit

final class UploadFeedTagsView: UploadFeedContentView {
    
    //MARK: - UI Properties
    
    private(set) lazy var collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    
    private let collectionLayout: CollectionViewLeftAlignFlowLayout = {
        let layout = CollectionViewLeftAlignFlowLayout()
        return layout
    }()
    
    //MARK: - Lifecycles
    
    override init(title: String) {
        super.init(title: title)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        Logger.printLog("태그뷰 layoutSubViews")
    }

    //MARK: - Configures
    
    override func configureUI() {
        super.configureUI()
        
        let stackView = UIStackView(arrangedSubviews: [collectionView, divider])
        collectionView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
        }

        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(BaseTagCell.self,
                                forCellWithReuseIdentifier: BaseTagCell.cellIdentifier)
    }
    
    //MARK: - Helpers

    func showTagButton(show: Bool) {
        isActivated = show
        collectionView.isHidden = !show
    }
}
