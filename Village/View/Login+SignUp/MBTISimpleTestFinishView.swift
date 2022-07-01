import UIKit

class MBTISimpleTestFinishView: BaseView {
  
    //MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 검사결과가 나왔어요!"
        label.font = .suitFont(size: 17, weight: .bold)
        return label
    }()
    
    let mbtiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = .suitFont(size: 17, weight: .bold)
        label.textAlignment = .center
        label.textColor = .villageSky
        label.clipsToBounds = true
        label.layer.cornerRadius = 24
        return label
    }()
    
    let completeLabel: UILabel = {
        let label = UILabel()
        label.text = "완료버튼을 눌러 회원가입을 진행해주세요"
        label.textColor = .grey300
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    let completeButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("완료", for: .normal)
        button.isEnabled = true
        return button
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        
        backgroundColor = .white
        
        let contentView = UIView()
        contentView.backgroundColor = .grey100
        
        let headerLabel = UILabel()
        headerLabel.backgroundColor = .clear
        headerLabel.text = "당신은"
        headerLabel.textAlignment = .center
        headerLabel.font = .suitFont(size: 15, weight: .regular)
    
        let footerLabel = UILabel()
        footerLabel.backgroundColor = .clear
        footerLabel.text = "시군요!"
        footerLabel.textAlignment = .center
        footerLabel.font = .suitFont(size: 15, weight: .regular)
        
        let labelStack = UIStackView(arrangedSubviews: [headerLabel, mbtiLabel, footerLabel])
        labelStack.backgroundColor = .clear
        labelStack.axis = .vertical
        labelStack.spacing = 3
        labelStack.alignment = .center
        
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(contentView)
        contentView.layer.cornerRadius = 24
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(142)
        }

        contentView.addSubview(mbtiLabel)
        mbtiLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mbtiLabel.snp.top).offset(-3)
        }

        contentView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints { make in
            make.top.equalTo(mbtiLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
        
        addSubview(completeButton)
        completeButton.layer.cornerRadius = 48 / 2
        completeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(82)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        addSubview(completeLabel)
        completeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(completeButton.snp.top).offset(-13)
            make.centerX.equalToSuperview()
        }
    }
}
