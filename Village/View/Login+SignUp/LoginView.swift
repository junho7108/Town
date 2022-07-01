import UIKit
import GoogleSignIn
import AuthenticationServices


class LoginView: BaseView {

    //MARK: - UI Properties
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "img_leader")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let kakaoLoginButton: LoginButton = {
        let button = LoginButton()
        button.backgroundColor = .init(hex: "#FEE500")
        button.setTitle("카카오로 계속하기", for: .normal)
        button.setImage(#imageLiteral(resourceName: "img_general_kakao_square@3x"), for: .normal)
        
        return button
    }()
  
    let naverLoginButton: LoginButton = {
        let button = LoginButton()
        button.backgroundColor = .init(hex: "#03C75A")
        button.setTitle("네이버로 계속하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(#imageLiteral(resourceName: "img_general_naver@3x"), for: .normal)
        return button
    }()
   
    let googleLoginButton: LoginButton = {
        let button = LoginButton()
        button.backgroundColor = .white
        button.setTitle("Google로 계속하기", for: .normal)
        button.setImage(#imageLiteral(resourceName: "img_general_google_square@3x"), for: .normal)
        return button
    }()
   
    let appleLoginButton: LoginButton = {
        let button = LoginButton()
        button.backgroundColor = .white
        button.setTitle("Apple로 계속하기", for: .normal)
        button.setImage(#imageLiteral(resourceName: "img_general_apple@3x"), for: .normal)
        return button
    }()
    
    let loadingView = LoadingView()
    
    let policyLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인하시면 아래 약관에 동의하게 됩니다."
        label.textColor = .grey300
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    let TOSlinkLabel: UILabel = {
        let label = UILabel()
        let string = NSMutableAttributedString(string: "이용약관", attributes: [.font: UIFont.suitFont(size: 13, weight: .regular),
                                                                                      .foregroundColor: UIColor.grey300])
        string.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: string.length))
        label.attributedText = string
        return label
    }()
    
    let privacyLinkLabel: UILabel = {
        let label = UILabel()
        let string = NSMutableAttributedString(string: "개인정보처리방침", attributes: [.font: UIFont.suitFont(size: 13, weight: .regular),
                                                                                      .foregroundColor: UIColor.grey300])
        string.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: string.length))
        label.attributedText = string
        return label
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .grey100
        
        let loginButtonStackView = UIStackView(arrangedSubviews: [googleLoginButton, kakaoLoginButton, naverLoginButton, appleLoginButton])
        loginButtonStackView.axis = .vertical
        loginButtonStackView.spacing = 8
        
        loginButtonStackView.arrangedSubviews.forEach {
            $0.layer.cornerRadius = 16
            $0.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }
        
        let andLabel = UILabel()
        andLabel.text = "및"
        andLabel.textColor = .grey300
        andLabel.font = .suitFont(size: 13, weight: .regular)
        
        let policyStackView = UIStackView(arrangedSubviews: [TOSlinkLabel, andLabel, privacyLinkLabel])
        policyStackView.spacing = 4
        
        addSubview(characterImageView)
        characterImageView.layer.cornerRadius = 168 / 2
        characterImageView.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(160)
            make.top.greaterThanOrEqualToSuperview().inset(80)
            make.width.height.equalTo(168)
            make.centerX.equalToSuperview()
        }
        

        addSubview(loginButtonStackView)
        loginButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(88)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        let stackView = UIStackView(arrangedSubviews: [policyLabel, policyStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(loginButtonStackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview().inset(72)
        }
    
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
