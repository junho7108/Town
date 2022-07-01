import UIKit

class UploadFeedContentView: BaseView {
    
    var isActivated: Bool = false {
        didSet {
            actionButton.isHidden = isActivated
            closeButton.isHidden = !isActivated
        }
    }
    
    //MARK: - UI Properties
    
    let headerView = UIView()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .grey100
        return divider
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
   
    let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_circlearrow_right").withRenderingMode(.alwaysOriginal).withTintColor(.villageSky),
                        for: .normal)
        return button
    }()
  
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .villageSky
        button.setImage(#imageLiteral(resourceName: "ic_delete").withRenderingMode(.alwaysOriginal).withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    //MARK: - Lifecycles
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        closeButton.isHidden = true
        
        addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(19)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        headerView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        headerView.addSubview(closeButton)
        closeButton.layer.cornerRadius = 18 / 2
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(18)
        }
        
        closeButton.imageView?.snp.makeConstraints({ make in
            make.width.height.equalTo(12)
        })
    }
}
