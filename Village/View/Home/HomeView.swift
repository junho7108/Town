import UIKit

class HomeView: BaseView {
    
    //MARK: - UI Properties
    
    let loadingView = LoadingView()
    
    let characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .grey100
        
        addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(92)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(230)
        }
        
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(user: User) {
        characterImageView.image = user.mbti.characterImage
        
        let nicknameString = NSMutableAttributedString(string: user.nickname, attributes: [.font: UIFont.suitFont(size: 17, weight: .bold)])
        nicknameString.append(NSAttributedString(string: " \(user.mbti.nickname)", attributes: [.font: UIFont.suitFont(size: 17, weight: .bold),
                                                                                                .foregroundColor: UIColor.villageSky]))
        
        nicknameLabel.attributedText = nicknameString
    }
}
