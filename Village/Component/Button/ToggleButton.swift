import UIKit

final class ToggleButton: UIButton {
    
    //MARK: - Properties
    
    var isToggled: Bool = false {
        didSet {
            onToggle(toggled: isToggled)
        }
    }
    
    //MARK: - UI Properties
    
    private let toggleBar: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hex: "#868E96")
        return view
    }()
    
    private let toggleArrow: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hex: "#DEE2E6")
        return view
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(toggleBar)
        toggleBar.layer.cornerRadius = 6
        toggleBar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(toggleArrow)
        toggleArrow.layer.cornerRadius = 20 / 2
        toggleArrow.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    //MARK: - Helpers
    
    private func onToggle(toggled: Bool) {
        UIView.animate(withDuration: 0.15) { [unowned self] in
            let arrowCenterPos = toggled ? toggleBar.frame.width - toggleArrow.frame.width / 4 : (toggleArrow.frame.width / 4)
            toggleArrow.center.x = arrowCenterPos
            
        } completion: { [unowned self] _ in
            toggleBar.backgroundColor = toggled ? UIColor(hex: "#1D6479") : UIColor(hex: "#868E96")
            toggleArrow.backgroundColor = toggled ? UIColor(hex: "#33C4EF") : UIColor(hex: "#DEE2E6")
        }
    }
}
