import UIKit

class SignUpCompleteView: BaseView {
    
    let promisePopup = UIView()
    
    let villageStartPopup = UIView()
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("도장 꾹", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .villageSky
        return button
    }()
    
    let villageStartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("빌리지 시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .villageSky
        return button
    }()
    
    override func configureUI() {
        backgroundColor = .grey100
        configurePromisePopup()
        configureStartPopup()
    }
    
    private func configurePromisePopup() {
        promisePopup.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "🤙 약속하기"
        titleLabel.font = .suitFont(size: 17, weight: .bold)
        
        let subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "✅ 개인정보를 묻거나 알려주지 않기"
        
        let subtitleLabel2 = UILabel()
        subtitleLabel2.numberOfLines = 0
        subtitleLabel2.text = "✅ 성희롱, 폭언, 과도한 만남 요구 하지 않기"
        
        let subtitleLabel3 = UILabel()
        subtitleLabel3.numberOfLines = 0
        subtitleLabel3.text = "✅ 이상한 이웃 신고하기"
        
        let subtitleLabel4 = UILabel()
        subtitleLabel4.numberOfLines = 0
        subtitleLabel4.text = "✅ 마을 이웃들과 즐거운 시간 보내기"
        
        let warningLabel = UILabel()
        warningLabel.numberOfLines = 0
        warningLabel.text = "👉 약속을 어길지 영구 정지 조치가 있을 수 있습니다."
        warningLabel.font = .suitFont(size: 13, weight: .regular)
        
        let subtitleStackView = UIStackView(arrangedSubviews: [subtitleLabel, subtitleLabel2, subtitleLabel3, subtitleLabel4])
        subtitleStackView.axis = .vertical
        subtitleStackView.spacing = 12
        subtitleStackView.alignment = .leading
        
        [subtitleLabel, subtitleLabel2, subtitleLabel3, subtitleLabel4].forEach { $0.font = .suitFont(size: 15, weight: .regular)}
        
        addSubview(promisePopup)
        promisePopup.layer.cornerRadius = 40
        promisePopup.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(461)
        }
        
        promisePopup.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(48)
            make.centerX.equalToSuperview()
        }
        
        promisePopup.addSubview(subtitleStackView)
        subtitleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        promisePopup.addSubview(warningLabel)
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleStackView.snp.bottom).offset(29)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        promisePopup.addSubview(completeButton)
        completeButton.layer.cornerRadius = 48 / 2
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func configureStartPopup() {
        villageStartPopup.backgroundColor = .white
    
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .clear
        profileImageView.image = #imageLiteral(resourceName: "img_leader")
        profileImageView.clipsToBounds = true
        
        let contentView = UIView()
        contentView.backgroundColor = .grey100
        
        let titleLabel = UILabel()
        titleLabel.text = "🏡 마을 이장님"
        titleLabel.textColor = .villageSky
        titleLabel.font = .suitFont(size: 17, weight: .bold)
        
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.text = "MBTI 마을에 놀러 오신 걸 환영합니다!\n다양한 사람들과 즐거운 일상을 보내세요 "
        contentLabel.textAlignment = .center
        contentLabel.font = .suitFont(size: 15, weight: .regular)
        
        addSubview(villageStartPopup)
        villageStartPopup.layer.cornerRadius = 40
        villageStartPopup.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(461)
        }
        
        villageStartPopup.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(168)
        }
        
        villageStartPopup.addSubview(contentView)
        contentView.layer.cornerRadius = 40
        contentView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(133)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        villageStartPopup.addSubview(villageStartButton)
        villageStartButton.layer.cornerRadius = 48 / 2
        villageStartButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        villageStartPopup.isHidden = true
        
    }
}
