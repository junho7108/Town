import UIKit

class SelectTagsView: BaseView {
    
    private(set) var tagCollectionHeight: CGFloat = 32
    
    private(set) var mbtiCollectionHeight: CGFloat = 32
    
    //MARK: - UI Properties
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.villageSky, for: .normal)
        button.titleLabel?.font = .suitFont(size: 15, weight: .bold)
        return button
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .bold)
        label.text = "🏷 카테고리"
        return label
    }()
    
    private let taglHelperLabel: UILabel = {
        let label = UILabel()
        label.text = "한가지 이상 선택해주세요."
        label.textColor = .grey300
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
    private(set) lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagLayout)
    
    private let tagLayout: CollectionViewLeftAlignFlowLayout = {
        let layOut = CollectionViewLeftAlignFlowLayout()
        layOut.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return layOut
    }()
    
    private let mbtiLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .bold)
        label.text = "✅ MBTI"
        return label
    }()
    
    private let mbtiHelperLabel: UILabel = {
        let label = UILabel()
        label.text = "한가지 이상 선택해주세요."
        label.textColor = .grey300
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
    private(set) lazy var mbtiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mbtiLayout)
    
    private let mbtiLayout: CollectionViewLeftAlignFlowLayout = {
        let layOut = CollectionViewLeftAlignFlowLayout()
        layOut.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return layOut
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configures
    
    override func configureUI() {
        
        let divider = UIView()
        divider.backgroundColor = .grey100
        
        addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(88)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(taglHelperLabel)
        taglHelperLabel.snp.makeConstraints { make in
            make.leading.equalTo(tagLabel.snp.trailing).offset(8)
            make.centerY.equalTo(tagLabel.snp.centerY)
        }
        
        addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(32)
        }
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        addSubview(mbtiLabel)
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(mbtiHelperLabel)
        mbtiHelperLabel.snp.makeConstraints { make in
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(8)
            make.centerY.equalTo(mbtiLabel.snp.centerY)
        }
        
        addSubview(mbtiCollectionView)
        mbtiCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mbtiLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(32)
        }
    }
    
    private func configureCollectionView() {
        tagCollectionView.isScrollEnabled = false
        tagCollectionView.backgroundColor = .clear
        tagCollectionView.showsVerticalScrollIndicator = false
        tagCollectionView.showsHorizontalScrollIndicator = false
        tagCollectionView.register(FeedCategoryCell.self,
                                       forCellWithReuseIdentifier: FeedCategoryCell.identifier)
        
        mbtiCollectionView.isScrollEnabled = false
        mbtiCollectionView.backgroundColor = .clear
        mbtiCollectionView.showsVerticalScrollIndicator = false
        mbtiCollectionView.showsHorizontalScrollIndicator = false
        mbtiCollectionView.register(FeedMBTICell.self,
                                       forCellWithReuseIdentifier: FeedMBTICell.identifier)
    }
    
    func updateTagCollectionLayout() {
        guard tagCollectionHeight < tagCollectionView.contentSize.height else { return }
        tagCollectionHeight = tagCollectionView.contentSize.height
        
        tagCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(24)
            make.height.greaterThanOrEqualTo(tagCollectionHeight)
            make.leading.trailing.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
    func updateMBTICollectionLayout() {
        guard mbtiCollectionHeight < mbtiCollectionView.contentSize.height else { return }
        mbtiCollectionHeight = mbtiCollectionView.contentSize.height
        
        mbtiCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(mbtiLabel.snp.bottom).offset(24)
            make.height.greaterThanOrEqualTo(mbtiCollectionHeight)
            make.leading.trailing.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
}
