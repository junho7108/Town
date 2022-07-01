import UIKit

class NetworkErrorView: BaseView {
    
    //MARK: - UI Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        iv.image = #imageLiteral(resourceName: "img_leader")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "📍연결실패"
        label.font = .suitFont(size: 17, weight: .bold)
        label.textColor = .villageSky
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "서버에 연결되지 않았어요.\n연결 확인 후 다시 시도해주세요."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .villageSky
        button.setTitle("다시시도", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .grey100
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        
        let titleContentView = UIView()
        titleContentView.layer.cornerRadius = 24
        titleContentView.backgroundColor = .grey100
        
        addSubview(contentView)
        contentView.layer.cornerRadius = 24
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(461)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(168)
        }
        
        contentView.addSubview(titleContentView)
        titleContentView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(133)
        }
        
        titleContentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        titleContentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(retryButton)
        retryButton.layer.cornerRadius = 48 / 2
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(titleContentView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
