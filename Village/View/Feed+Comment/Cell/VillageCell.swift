import UIKit
import RxSwift

class VillageCell: UICollectionViewCell {
    
    static let identifier = "villageCell"
    
    var disposeBag = DisposeBag()
    
    private(set) var villageMBTI: MBTIType!
    
    //MARK: - UI Properites
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let villageLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .bold)
        label.textColor = .villageSky
        return label
    }()
    
    private let userCountsLabel: UILabel = {
        let label = UILabel()
        label.text = "마을 주민 수 56"
        label.font = .suitFont(size: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private let compatibilityView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let contentCountsLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 게시글 8"
        label.font = .suitFont(size: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
 
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Property 1=ic_home_heart_on").withRenderingMode(.alwaysOriginal), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let myVillageIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_home_on").withRenderingMode(.alwaysOriginal)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        contentView.backgroundColor = .grey100
        contentView.layer.cornerRadius = 24
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(96)
        }
        
        contentView.addSubview(villageLabel)
        villageLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(compatibilityView)
        compatibilityView.layer.cornerRadius = 8 / 2
        compatibilityView.snp.makeConstraints { make in
            make.leading.equalTo(villageLabel.snp.trailing).offset(4)
            make.centerY.equalTo(villageLabel.snp.centerY)
            make.width.height.equalTo(8)
        }
        
        contentView.addSubview(userCountsLabel)
        userCountsLabel.snp.makeConstraints { make in
            make.top.equalTo(villageLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(contentCountsLabel)
        contentCountsLabel.snp.makeConstraints { make in
            make.top.equalTo(userCountsLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(myVillageIconImageView)
        myVillageIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
        }
    }
    
    func configureUI(userMBTI: MBTIType, villageMBTI: MBTIType) {
        self.villageMBTI = villageMBTI
        
        profileImageView.image = villageMBTI.profileImage
        villageLabel.text = "\(villageMBTI.title) 마을"
        
        myVillageIconImageView.isHidden = userMBTI != villageMBTI
        followButton.isHidden = userMBTI == villageMBTI
        
        compatibilityView.backgroundColor = configureCompatibility(userMBTI: userMBTI, villageMBTI: villageMBTI)
    }
    
    private func configureCompatibility(userMBTI: MBTIType, villageMBTI: MBTIType) -> UIColor {
        let positiveColor = UIColor.green
        let negativeColor = UIColor.red
        let normalColor = UIColor.yellow
        
        switch userMBTI {
            //MARK: INFP
        case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P):
            switch villageMBTI {
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J): return positiveColor
                
            default: return negativeColor
            }
        
        case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P):
            switch villageMBTI {
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J): return positiveColor
                
            default: return negativeColor
            }
            
        case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J):
            switch villageMBTI {
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            default: return negativeColor
            }
            
        case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J):
            switch villageMBTI {
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P): return positiveColor
                
            default: return negativeColor
            }
      
        case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J):
            switch villageMBTI {
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P): return normalColor
                
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return normalColor
                
            default: return positiveColor
            }
            
        case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J):
            switch villageMBTI {
                // enfp, infj, enfj, intj, entj, intp, entp
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
                // infp, intp
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            default: return positiveColor
            }
            
        case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P):
            switch villageMBTI {
                // best: entj, estj
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                // normal: isfj, esfj, istj,
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return normalColor
                // greate: isfp, esfp, istp, estp
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P): return normalColor
                
            default: return positiveColor
            }
            
        case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P):
            switch villageMBTI {
                // best: infj, intj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J): return positiveColor
                // great: isfp, esfp, istp, estp
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P): return positiveColor
                // normal: isfj, esfj, istj, estj
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return normalColor
                
            default: return positiveColor
            }
            
        case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P):
            switch villageMBTI {
                // negative: infp, enfp, infj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                // positive: enfj, esfj, estj
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                // normal: isfp, esfp, istp, estp
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P): return normalColor
                
                // default: greate
            default: return positiveColor
            }
            
        case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P):
            switch villageMBTI {
                // negative: infp, enfp, infj, enfj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                // great: intj, entj, intp, entp
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                // best: isfj, istj
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                //default: normal
            default: return normalColor
            }
            
        case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P):
            switch villageMBTI {
                // negative: infp, enfp, infj, enfj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                // best: esfj, estj
            case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                // great: intj, entj, intp, entp
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return positiveColor
                // default: normal
            default: return normalColor
            }
            
        case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P):
            switch villageMBTI {
                // negative: infp, enfp, infj, enfj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                // best: isfj, istj
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                // great: intj, entj, intp, entp
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P): return normalColor
                // default: normal
            default: return normalColor
            }
        
        case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J):
            switch villageMBTI {
                // negative: infp, enfp, infj, enfj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                // positive: isfj, esfj, istj, estj
            case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                // best: esfp, estp
            case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P): return positiveColor
                
            default: return normalColor
            }
            
            //MARK: ESFJ
        case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J):
            switch villageMBTI {
                //negative: infp, enfp, infj, enfj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                
                // positive: esfp, estp, isfj, esfj, istj, estj
            case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                
            default: return normalColor
            }
         
            //MARK: ISTJ
        case .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J):
            switch villageMBTI {
                //negative: infp, enfp, infj, enfj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                
                // positive: esfp, estp, isfj, esfj, istj, estj
            case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                
            default: return normalColor
            }
            
            //MARK: ESTJ
        case .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J):
            switch villageMBTI {
                //negative: infp, enfp, infj, enfj
            case .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J): return negativeColor
                
                // positive: entj, isfp, istp, isfj, esfj, istj, estj
            case .init(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
                    .init(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J),
                    .init(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J): return positiveColor
                
            default: return normalColor
            }
            
        default: return negativeColor
        }
    }
}
