import UIKit

class AppVersionView: BaseView {
    
    //MARK: - UI Properties
    
    let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .grey200
        return imageView
    }()
    
    private let newestVersionLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    private let currentVersionLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    let updateButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("최신 버전 업데이트", for: .normal)
        return button
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        
        newestVersionLabel.attributedText = versionString(title: "최신 버전", version: "1.0.0 (더미)")
        currentVersionLabel.attributedText = versionString(title: "현재 버전", version: "1.0.0 (더미)")
        
        addSubview(appImageView)
        appImageView.layer.cornerRadius = 24
        appImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(88)
        }
        
        addSubview(newestVersionLabel)
        newestVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(appImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        addSubview(currentVersionLabel)
        currentVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(newestVersionLabel.snp.bottom).offset(16)
            make.leading.equalTo(newestVersionLabel.snp.leading)
        }
        
        addSubview(updateButton)
        updateButton.layer.cornerRadius = 48 / 2
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(currentVersionLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    //MARK: - Helpers
    
    private func versionString(title: String, version: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.suitFont(size: 15, weight: .regular)])
        attributedString.append(NSAttributedString(string: "  \(version)", attributes: [.font: UIFont.suitFont(size: 15, weight: .bold),
                                                                                 .foregroundColor: UIColor.villageSky]))
        
        return attributedString
    }
}
