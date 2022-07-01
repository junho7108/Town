import UIKit

class HomeBottomSheetView: UIScrollView {
    
    //MARK: - UI Properties
    
    let contentView = UIView()
    
    private let competitionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "🥊 이번 주 대항전 "
        label.font = .suitFont(size: 17, weight: .bold)
        return label
    }()
    
  
    let moreCompetitionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_circlearrow_right").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    private(set) lazy var competitionCollcetionView = UICollectionView(frame: .zero, collectionViewLayout: competitionLayout)
    
    private(set) lazy var competitionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.width, height: 247 + 16 + 16)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        return layout
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(frameLayoutGuide)
        }
        
        contentView.addSubview(competitionTitleLabel)
        competitionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(moreCompetitionButton)
        moreCompetitionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalTo(competitionTitleLabel.snp.centerY)
            make.width.height.equalTo(22)
        }
        
        contentView.addSubview(competitionCollcetionView)
        competitionCollcetionView.snp.makeConstraints { make in
            make.top.equalTo(competitionTitleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(247 + 16 + 16)
        }
    }
    
    private func configureCollectionView() {
        competitionCollcetionView.backgroundColor = .white
        competitionCollcetionView.isPagingEnabled = true
        competitionCollcetionView.showsHorizontalScrollIndicator = false
        competitionCollcetionView.showsVerticalScrollIndicator = false
        competitionCollcetionView.register(CompetitionCollectionCell.self, forCellWithReuseIdentifier: CompetitionCollectionCell.identifier)
    }
}

