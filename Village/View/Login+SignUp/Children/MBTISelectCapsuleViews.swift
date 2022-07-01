import UIKit

class SelectMBTIEnergyView: BaseView {
    let introversionButton =  MBTIComponentEllipseButton(arrow: .top, title: "I", isSelected: true)
    let extraversionButton =  MBTIComponentEllipseButton(arrow: .bottom, title: "E", isSelected: false)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내향형"
        label.font = .suitFont(size: 15, weight: .regular)
        label.textColor = .grey300
        return label
    }()
  
    override func configureUI() {
        addSubview(introversionButton)
        introversionButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        let divider = UIView()
        divider.backgroundColor = .grey100
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(introversionButton.snp.bottom)
            make.width.equalTo(introversionButton.snp.width)
            make.height.equalTo(1)
        }
        
        addSubview(extraversionButton)
        extraversionButton.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(extraversionButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        deselect()
    }
    
    func selectEnergy(energy: MBTIEnergy) {
        switch energy {
        case .E:
            titleLabel.text = "외향형"
            extraversionButton.select(isSelected: true)
            introversionButton.select(isSelected: false)
        case .I:
            titleLabel.text = "내향형"
            extraversionButton.select(isSelected: false)
            introversionButton.select(isSelected: true)
        }
    }
    
    func deselect() {
        extraversionButton.select(isSelected: false)
        introversionButton.select(isSelected: false)
    }
}

class SelectMBTIInformationView: BaseView {
    let iNtuitionButton =  MBTIComponentEllipseButton(arrow: .top, title: "N", isSelected: true)
    let sensingButton =  MBTIComponentEllipseButton(arrow: .bottom, title: "S", isSelected: false)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "직관형"
        label.font = .suitFont(size: 15, weight: .regular)
        label.textColor = .grey300
        return label
    }()
    
    override func configureUI() {
        addSubview(iNtuitionButton)
        iNtuitionButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        let divider = UIView()
        divider.backgroundColor = .grey100
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(iNtuitionButton.snp.bottom)
            make.width.equalTo(iNtuitionButton.snp.width)
            make.height.equalTo(1)
        }
        
        addSubview(sensingButton)
        sensingButton.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sensingButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        deselect()
    }
    
    func selectInformation(information: MBTIInformation) {
        switch information {
        case .N:
            titleLabel.text = "직관형"
            iNtuitionButton.select(isSelected: true)
            sensingButton.select(isSelected: false)
        case .S:
            titleLabel.text = "감각형"
            iNtuitionButton.select(isSelected: false)
            sensingButton.select(isSelected: true)
        }
    }
    
    func deselect() {
        iNtuitionButton.select(isSelected: false)
        sensingButton.select(isSelected: false)
    }
}

class SelectMBTIDecisionsView: BaseView {
    let feelingButton =  MBTIComponentEllipseButton(arrow: .top, title: "F", isSelected: true)
    let thinkingButton =  MBTIComponentEllipseButton(arrow: .bottom, title: "T", isSelected: false)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "감정형"
        label.font = .suitFont(size: 15, weight: .regular)
        label.textColor = .grey300
        return label
    }()
    
    override func configureUI() {
        addSubview(feelingButton)
        feelingButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        let divider = UIView()
        divider.backgroundColor = .grey100
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(feelingButton.snp.bottom)
            make.width.equalTo(feelingButton.snp.width)
            make.height.equalTo(1)
        }
        
        addSubview(thinkingButton)
        thinkingButton.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thinkingButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        deselect()
    }
    
    func selectDecisions(decisions: MBTIDecisions) {
        switch decisions {
        case .T:
            titleLabel.text = "사고형"
            thinkingButton.select(isSelected: true)
            feelingButton.select(isSelected: false)
        case .F:
            titleLabel.text = "감정형"
            thinkingButton.select(isSelected: false)
            feelingButton.select(isSelected: true)
        }
    }
    
    func deselect() {
        thinkingButton.select(isSelected: false)
        feelingButton.select(isSelected: false)
    }
}

class SelectMBTILifystyleView: BaseView {
    let perceivingButton =  MBTIComponentEllipseButton(arrow: .top, title: "P", isSelected: true)
    let judgingButton =  MBTIComponentEllipseButton(arrow: .bottom, title: "J", isSelected: false)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인식형"
        label.font = .suitFont(size: 15, weight: .regular)
        label.textColor = .grey300
        return label
    }()
    
    override func configureUI() {
        addSubview(perceivingButton)
        perceivingButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        let divider = UIView()
        divider.backgroundColor = .grey100
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(perceivingButton.snp.bottom)
            make.width.equalTo(perceivingButton.snp.width)
            make.height.equalTo(1)
        }
        
        addSubview(judgingButton)
        judgingButton.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(judgingButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        deselect()
    }
    
    func selectLifestyle(lifestyle: MBTILifestyle) {
        switch lifestyle {
        case .J:
            titleLabel.text = "판단형"
            judgingButton.select(isSelected: true)
            perceivingButton.select(isSelected: false)
        case .P:
            titleLabel.text = "인식형"
            judgingButton.select(isSelected: false)
            perceivingButton.select(isSelected: true)
        }
    }
    
    func deselect() {
        judgingButton.select(isSelected: false)
        perceivingButton.select(isSelected: false)
    }
}

//MARK: - MBTIComponentEllipseView

class MBTIComponentEllipseButton: UIButton {
    
    enum EllipseArrow {
        case top, bottom
    }
    
    private var path: UIBezierPath
    
    private var fillColor: UIColor
    
    //MARK: - Lifecycles
    
    init(arrow: EllipseArrow, title: String, isSelected: Bool) {
        let roundingCorners: UIRectCorner
        switch arrow {
        case .top:
            roundingCorners = [.topLeft, .topRight]
        case .bottom:
            roundingCorners = [.bottomLeft, .bottomRight]
        }
        
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 64, height: 64),
                                byRoundingCorners: roundingCorners,
                                cornerRadii: CGSize(width: 40, height: 40))
        
        self.fillColor = isSelected ? UIColor.villageSky : UIColor.white
        super.init(frame: .zero)
 
        setTitle(title, for: .normal)
        setTitleColor(isSelected ? .white : .grey200, for: .normal)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        fillColor.set()
        path.fill()
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .clear
        titleLabel?.font = .suitFont(size: 28, weight: .heavy)
    }
    
    //MARK: - Helpers
    
    func select(isSelected: Bool) {
        setTitleColor(isSelected ? .white : .grey200, for: .normal)
        fillColor = isSelected ? UIColor.villageSky : .white
        setNeedsDisplay()
    }
}
