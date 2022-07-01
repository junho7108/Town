import UIKit

class LastMBTISimpleTestView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 과제가 갑자기 생겼을 때"
        label.font = .suitFont(size: 17, weight: .bold)
        return label
    }()
    
    let firstSelectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("일단 계획부터 세워서 틀을 잡는다", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.backgroundColor = .grey100
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return button
    }()
    
    let secondSelectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("일단 시작해서 틀을 잡는다", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.backgroundColor = .grey100
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return button
    }()
    
    let completeButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("검사결과 보러가기", for: .normal)
        return button
    }()
    
    override func configureUI() {
        backgroundColor = .white
        
        let selectButtonStackView = UIStackView(arrangedSubviews: [firstSelectButton, secondSelectButton])
        selectButtonStackView.spacing = 8
        selectButtonStackView.axis = .vertical
        selectButtonStackView.arrangedSubviews.forEach {
            $0.layer.cornerRadius = 40 / 2
            $0.snp.makeConstraints { $0.height.equalTo(40)}
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(selectButtonStackView)
        selectButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(completeButton)
        completeButton.layer.cornerRadius = 48 / 2
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(82)
        }
    }
    
    func selected(mbtiLife: MBTILifestyle) {
        
        switch mbtiLife {
        case .J:
            firstSelectButton.layer.borderColor = UIColor.villageSky.cgColor
            firstSelectButton.backgroundColor = .white
            firstSelectButton.setTitleColor(.black, for: .normal)
            firstSelectButton.layer.borderWidth = 2
            
            secondSelectButton.layer.borderColor = UIColor.clear.cgColor
            secondSelectButton.backgroundColor = .grey100
            secondSelectButton.setTitleColor(.grey300, for: .normal)
        case .P:
            secondSelectButton.layer.borderColor = UIColor.villageSky.cgColor
            secondSelectButton.backgroundColor = .white
            secondSelectButton.setTitleColor(.black, for: .normal)
            secondSelectButton.layer.borderWidth = 2
            
            firstSelectButton.layer.borderColor = UIColor.clear.cgColor
            firstSelectButton.backgroundColor = .grey100
            firstSelectButton.setTitleColor(.grey300, for: .normal)
        }
    }
}
