import UIKit

class ProfileSettingFeedActivityView: BaseView {
    
    //MARK: - UI Properties
    
    private let postCountLabel: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .villageSky
        label.font = .suitFont(size: 15, weight: .heavy)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    //MARK: - Lifecycles
    
    init(title: String, counts: Int) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        postCountLabel.text = "\(counts)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        
        addSubview(postCountLabel)
        postCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(postCountLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
