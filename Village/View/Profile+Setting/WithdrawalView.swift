import UIKit

class WithdrawalView: BaseView {
    
    //MARK: - UI Properties
    
    let withdrawalPopup = BasePopupViewController(title: "알림", content: "회원 탈퇴시 고객정보가\n삭제되며 복구되지 않습니다.\n정말 탈퇴하실건가요? 😭🥲")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "️⛔️\n회원 탈퇴 전 안내사항을 꼭 확인해주세요."
        label.textAlignment = .center
        label.font = .suitFont(size: 17, weight: .bold)
        return label
    }()
    
    private let policyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "탈퇴 시 회원님의 빌리지 이용정보가 삭제되어 복구가 불가능합니다."
        label.textAlignment = .center
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "탈퇴를 진행하면 사용중인 계정의 모든 정보가 삭제되며 복구는 불가능합니다. 탈퇴 시 개인정보처리방침에 의거하여 모든 개인정보가 즉시 파기되며 복구할 수 없습니다."
        label.textAlignment = .left
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
  
    let agreeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_check-1").withRenderingMode(.alwaysOriginal),
                         for: .normal)
        button.setTitle("(필수) 회원 탈퇴 안내를 모두 확인했으며, 이에 동의합니다.", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    let completeButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override func configureUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(policyLabel)
        policyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(policyLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(agreeButton)
        agreeButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(86)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(completeButton)
        completeButton.layer.cornerRadius = 48 / 2
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(agreeButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
