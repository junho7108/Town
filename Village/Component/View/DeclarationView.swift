import UIKit

class DeclarationView: UIScrollView {
    
    //MARK: - UI Properties
    
    let completePopupView = BasePopupViewController(title: "알림", content: "🔫 정말 신고하실건가요?")
   
    let ADButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.setTitle("광고, 홍보성 글", for: .normal)
        button.setTitleColor(.grey600, for: .normal)
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        return button
    }()
    
    let paperingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.setTitle("중복, 도배성 글", for: .normal)
        button.setTitleColor(.grey600, for: .normal)
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.contentMode = .left
        return button
    }()
    
    let abuseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.setTitle("욕설 / 인신공격", for: .normal)
        button.setTitleColor(.grey600, for: .normal)
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        return button
    }()
    
    let suggestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.setTitle("직접 입력", for: .normal)
        button.setTitleColor(.grey600, for: .normal)
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        return button
    }()
    
    let sensationalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.setTitle("음란 / 선정성", for: .normal)
        button.setTitleColor(.grey600, for: .normal)
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        return button
    }()
    
    let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 이 게시물을 신고하는 이유"
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    private let suggestLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 직접 입력"
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    let contentsTextView: InputTextView = {
        let textView = InputTextView(edgeInset: .init(top: 24, left: 16, bottom: 33, right: 16))
        textView.backgroundColor = .grey100
        textView.isScrollEnabled = false
        textView.maxTextCount = 300
        textView.font = .suitFont(size: 13, weight: .regular)
        textView.placeholder = "신고 내용을 입력해주세요."
        textView.placeholderLabel.font = .suitFont(size: 13, weight: .regular)
        return textView
    }()
    
    let contentsTextCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .suitFont(size: 13, weight: .regular)
        label.text = "0 / 300"
        label.textColor = .grey500
        return label
    }()
    
    let completeButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .white
    
        let buttonStackView = UIStackView(arrangedSubviews: [ADButton, paperingButton, abuseButton, sensationalButton, suggestButton])
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .leading
        buttonStackView.spacing = 21
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(contentLayoutGuide)
            make.width.equalTo(frameLayoutGuide)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        contentView.addSubview(suggestLabel)
        suggestLabel.snp.makeConstraints { make in
            make.top.equalTo((buttonStackView).snp.bottom).offset(32)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        contentView.addSubview(contentsTextView)
        contentsTextView.layer.cornerRadius = 24
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(suggestLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        contentView.addSubview(contentsTextCountLabel)
        contentsTextCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentsTextView.snp.trailing).inset(16)
            make.bottom.equalTo(contentsTextView.snp.bottom).inset(8)
        }
        
        contentView.addSubview(completeButton)
        completeButton.layer.cornerRadius = 48 / 2
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(contentsTextView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
    //MARK: - Helpers
   
    func selectDeclarationType(type: DeclarationType) {
        let activeImage = #imageLiteral(resourceName: "ic_check-1").withRenderingMode(.alwaysOriginal)
        let deactiveImage = #imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysOriginal)
        switch type {
        case .AD:
            ADButton.setImage(activeImage, for: .normal)
            contentsTextView.text.removeAll()
            contentsTextView.resignFirstResponder()
            [paperingButton, abuseButton, sensationalButton, suggestButton].forEach { button in
                button.setImage(deactiveImage, for: .normal)
            }
            
        case .papering:
            paperingButton.setImage(activeImage, for: .normal)
            contentsTextView.text.removeAll()
            contentsTextView.resignFirstResponder()
            [ADButton, abuseButton, sensationalButton, suggestButton].forEach { button in
                button.setImage(deactiveImage, for: .normal)
            }
            
        case .abuse:
            abuseButton.setImage(activeImage, for: .normal)
            contentsTextView.text.removeAll()
            contentsTextView.resignFirstResponder()
            [paperingButton, ADButton, sensationalButton, suggestButton].forEach { button in
                button.setImage(deactiveImage, for: .normal)
            }
            
        case .sensational:
            sensationalButton.setImage(activeImage, for: .normal)
            contentsTextView.text.removeAll()
            contentsTextView.resignFirstResponder()
            [paperingButton, abuseButton, ADButton, suggestButton].forEach { button in
                button.setImage(deactiveImage, for: .normal)
            }
            
        case .suggest:
            suggestButton.setImage(activeImage, for: .normal)
            
            [paperingButton, abuseButton, sensationalButton, ADButton].forEach { button in
                button.setImage(deactiveImage, for: .normal)
            }
        }
    }
    
    func updateContentTextViewHeight() {
        let size = CGSize(width: contentsTextView.frame.size.width, height: .infinity)
        let estimatedSize = contentsTextView.sizeThatFits(size)
        
        contentsTextView.constraints.forEach { constraint in
            if estimatedSize.height <= 120 {
                
            } else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
