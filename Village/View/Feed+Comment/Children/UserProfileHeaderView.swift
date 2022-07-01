import UIKit
import KakaoSDKUser

class UserProfileHeaderView: BaseView {
    
    //MARK: - UI Properties
    
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
    
    //MARK: - Lifecycles
    
    init(user: User) {
        super.init(frame: .zero)
        characterImageView.image = user.mbti.characterImage
        nicknameLabel.attributedText = attributedNicknameString(user: user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func attributedNicknameString(user: User) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: user.nickname, attributes: [.font: UIFont.suitFont(size: 17, weight: .bold)])
        attributedString.append(NSAttributedString(string: " \(user.mbti.nickname)", attributes: [.font: UIFont.suitFont(size: 17, weight: .bold),
                                                                                                  .foregroundColor: UIColor.villageSky]))
        
        return attributedString
    }
}
