import UIKit
import RxSwift

class MoveVillageHeaderView: UICollectionReusableView {
    
    static let identifer = "moveVillageHeaderIdentifier"
    
    var disposeBag = DisposeBag()
    
    //MARK: - UI Properties
  
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.image = #imageLiteral(resourceName: "img_leader")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "VILLAGE 전체보기"
        label.font = .suitFont(size: 15, weight: .bold)
        label.textColor = .villageSky
        return label
    }()
    
    private let contentCountsLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 전체 게시글 8"
        label.font = .suitFont(size: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .white
        
        let contentView = UIView()
        contentView.backgroundColor = .grey100
        
        addSubview(contentView)
        contentView.layer.cornerRadius = 24
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(96)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalTo(profileImageView.snp.trailing).offset(24)
        }
        
        contentView.addSubview(contentCountsLabel)
        contentCountsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
        }
    }
}
