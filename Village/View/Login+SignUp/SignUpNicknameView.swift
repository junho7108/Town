import UIKit

class SignUpNicknameView: BaseView {
    
    //MARK: - Properties
    
    private(set) var nicknameMaxLength: Int = 12
    
    let mbtiType: MBTIType
    
    //MARK: - UI Properties
    
    lazy var nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / \(nicknameMaxLength)"
        label.font = .suitFont(size: 13, weight: .regular)
        label.textColor = .grey300
        return label
    }()
  
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let helperLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 닉네임을 정해주세요!️"
        label.font = .suitFont(size: 17, weight: .bold)
        return label
    }()
    
    lazy var inputTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.layer.cornerRadius = 24
        textField.placeholder = mbtiType.placeholder
        textField.backgroundColor = .white
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.textColor = .villageSky
        textField.font = .suitFont(size: 17, weight: .bold)
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 0))
        textField.rightViewMode = .always
        textField.returnKeyType = .done
        textField.autoresizesSubviews = false
        return textField
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "나는 "
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "인프피야"
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    let completeButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("확인", for: .normal)
        return button
    }()
    
    //MARK: - Lifecycles
    
    init(mbti: MBTIType) {
        self.mbtiType = mbti
        profileImageView.image = mbti.characterImage
        
        super.init(frame: .zero)
        
        footerLabel.attributedText = mbtiAttributedText(mbti: mbti)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        
        let contentView = UIView()
        contentView.backgroundColor = .grey100
        contentView.layer.cornerRadius = 24
      
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(184)
        }

        addSubview(helperLabel)
        helperLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(helperLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(142)
        }
    
        contentView.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputTextField.snp.top).offset(-6)
        }
        
        contentView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputTextField.snp.bottom).offset(6)
        }
        
        addSubview(nicknameCountLabel)
        nicknameCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(2)
            make.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(completeButton)
        completeButton.layer.cornerRadius = 48 / 2
        completeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(82)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    //MARK: - Helpers
    
    private func mbtiAttributedText(mbti: MBTIType) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: mbti.nickname,
                                                         attributes: [.font: UIFont.suitFont(size: 15, weight: .bold),
                                                                      .foregroundColor: UIColor.black])
                                                                      
        attributedString.append(NSAttributedString(string: mbti.nicknameSuffix.appending("!"),
                                                   attributes: [.font: UIFont.suitFont(size: 15, weight: .regular)]))
        return attributedString
    }
}

