import UIKit
import RxSwift
import RxCocoa

class SignUpMBTIView: BaseView {
    
    //MARK: - Properties

    var profileImage: UIImage = .init() {
        didSet {
            profileImageView.image = profileImage
        }
    }
    
    let inputViewControlelr = MBTILinkViewController()
    
    //MARK: - UI Properties
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let selectionLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 어떤 성격이세요?"
        label.font = .suitFont(size: 19, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let energyView = SelectMBTIEnergyView()
    
    let informationView = SelectMBTIInformationView()
    
    let decisionsView = SelectMBTIDecisionsView()
    
    let lifestyleView = SelectMBTILifystyleView()

    let completeButton: EnableButton = {
        let button = EnableButton()
        button.titleLabel?.font = .suitFont(size: 17, weight: .heavy)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .villageSky
        return button
    }()
    
    let linkButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .suitFont(size: 15)
        let title = NSMutableAttributedString(string: "나의 MBTI가 알고싶다면 🙌", attributes: [.font: UIFont.suitFont(size: 15, weight: .bold),
                                                                                      .foregroundColor: UIColor.grey300])
        title.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.length))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        
        let stackBackgroundView = UIView()
        stackBackgroundView.backgroundColor = .grey100
        stackBackgroundView.layer.cornerRadius = 16
        
        let selectMBTIStackView = UIStackView(arrangedSubviews: [energyView, informationView, decisionsView, lifestyleView])
        selectMBTIStackView.backgroundColor = .clear
        selectMBTIStackView.axis = .horizontal
        selectMBTIStackView.distribution = .fillEqually
        selectMBTIStackView.arrangedSubviews.forEach { $0.snp.makeConstraints { $0.height.equalTo(128 + 8 + 24)}}
        
       addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.width.height.equalTo(184)
            make.centerX.equalToSuperview()
        }
    
        addSubview(selectionLabel)
        selectionLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(stackBackgroundView)
        stackBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(selectionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(203)
        }

        stackBackgroundView.addSubview(selectMBTIStackView)
        selectMBTIStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        let bottomStackView = UIStackView(arrangedSubviews: [completeButton, linkButton])
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 24
        bottomStackView.alignment = .center
        
        completeButton.layer.cornerRadius = 48 / 2
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        linkButton.snp.makeConstraints { make in
            make.height.equalTo(19)
        }
        
        addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stackBackgroundView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(66)
        }
    }
}
