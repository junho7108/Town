import UIKit
import RxSwift

class MBTILinkView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 MBTI 를 알고싶다면 👇 👇 👇 "
        label.font = .suitFont(size: 17, weight: .bold)
        return label
    }()
    
    let simpleTestButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("간단히 알아볼래요!", for: .normal)
        button.backgroundColor = .villageSky
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let detailTestButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("자세히 알아볼래요!", for: .normal)
        button.backgroundColor = .villageSky
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        let buttonStackView = UIStackView(arrangedSubviews: [simpleTestButton, detailTestButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 16
      
        buttonStackView.arrangedSubviews.forEach {
            $0.layer.cornerRadius = 48 / 2
            $0.snp.makeConstraints { $0.height.equalTo(48) }
        }
    
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(24)
        }
        
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
