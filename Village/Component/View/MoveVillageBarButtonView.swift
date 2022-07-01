import UIKit

class MoveVillageBarButtonView: BaseView {
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel = UILabel()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "ic_circlearrow_right").withRenderingMode(.alwaysOriginal).withTintColor(.villageSky)
        return imageView
    }()
    
    override func configureUI() {
        snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(32)
        }
        
        addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(4)
            make.width.height.equalTo(32)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    
        addSubview(arrowImageView)
        arrowImageView.layer.cornerRadius = 18 / 2
        arrowImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(11)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
    }
    
    func configure(mbti: MBTIType?) {
        profileImage.image = mbti?.profileImage ?? #imageLiteral(resourceName: "img_leader")
        let attributedString = mbti != nil ? setMBTIAttributedTitle(mbti: mbti!) : NSMutableAttributedString(string: "VILLAGE",
                                                                                                attributes: [.foregroundColor: UIColor.villageSky,
                                                                                                             .font: UIFont.suitFont(size: 17, weight: .bold)])
        titleLabel.attributedText = attributedString
        
        arrowImageView.isHidden = mbti == nil
    }
    
    //MARK: - Helpers
    
    private func setMBTIAttributedTitle(mbti: MBTIType) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: " \(mbti.title)",
                                                         attributes: [.foregroundColor: UIColor.villageSky,
                                                                      .font: UIFont.suitFont(size: 17, weight: .bold)])
        
        attributedString.append(NSAttributedString(string: " 빌리지",
                                                   attributes: [.foregroundColor: UIColor.black,
                                                                .font: UIFont.suitFont(size: 17, weight: .bold)]))
        return attributedString
    }
}
