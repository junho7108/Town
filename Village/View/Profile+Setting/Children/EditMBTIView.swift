import UIKit

class EditMBTIView: BaseView {
    
    //MARK: - Properties
    
    private(set) var mbti: MBTIType
    
    //MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 MBTI"
        label.font = .suitFont(size: 24, weight: .medium)
        return label
    }()
    
    let energyView = SelectMBTIEnergyView()
    
    let informationView = SelectMBTIInformationView()
    
    let decisionsView = SelectMBTIDecisionsView()
    
    let lifestyleView = SelectMBTILifystyleView()
    
    //MARK: - Lifecycles
    
    init(mbti: MBTIType, frame: CGRect) {
        self.mbti = mbti
        super.init(frame: frame)
        
        energyView.selectEnergy(energy: mbti.firstIndex)
        informationView.selectInformation(information: mbti.secondIndex)
        decisionsView.selectDecisions(decisions: mbti.thirdIndex)
        lifestyleView.selectLifestyle(lifestyle: mbti.lastIndex)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        self.clearsContextBeforeDrawing = true
        
        let contentView = UIView()
        contentView.backgroundColor = .grey100
        contentView.layer.cornerRadius = 24
    
        let mbtiStackView = UIStackView(arrangedSubviews: [energyView, informationView, decisionsView, lifestyleView])
        mbtiStackView.spacing = 16
        mbtiStackView.distribution = .fillEqually
        mbtiStackView.alignment = .center
        
        mbtiStackView.arrangedSubviews.forEach { $0.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(128)
        }}
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(24)
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(203)
        }
        
        contentView.addSubview(mbtiStackView)
        mbtiStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
    }
}
