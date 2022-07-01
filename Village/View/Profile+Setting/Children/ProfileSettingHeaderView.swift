import UIKit

class ProfileSettingHeaderView: BaseView {
    
    let height: CGFloat = 8 + 185 + 19

    //MARK: - UI Properties
 
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysOriginal).withTintColor(.villageSky), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 20, weight: .bold)
        return label
    }()
    
    private let providerLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        label.textColor = .grey300
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        label.textColor = .grey300
        return label
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        
        let topPadding = UIView()
        topPadding.backgroundColor = .grey100
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        
        let bottomPadding = UIView()
        bottomPadding.backgroundColor = .grey100
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
        
        contentView.addSubview(topPadding)
        topPadding.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
//        contentView.addSubview(editProfileButton)
//        editProfileButton.snp.makeConstraints { make in
//            make.top.equalTo(topPadding.snp.bottom).offset(19)
//            make.trailing.equalToSuperview().inset(19)
//            make.width.height.equalTo(18)
//        }
        
        contentView.addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(topPadding.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        contentView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(providerLabel)
        providerLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(providerLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(bottomPadding)
        bottomPadding.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(16)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func bindUser(user: User) {
        characterImageView.image = user.mbti.characterImage
        nicknameLabel.attributedText = Utils.mbtiNickname(user: user)
        providerLabel.text = KeyChainManager.loadSocialProvider()?.title ?? ""
        emailLabel.text = user.email
    }
}
