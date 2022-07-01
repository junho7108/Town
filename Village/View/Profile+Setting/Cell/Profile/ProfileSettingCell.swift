import UIKit
import RxSwift

class ProfileSettingCell: UITableViewCell {
    
    static let identifier = "profileSettingCellIdentifier"
    
    private(set) var settingOption: VillageSettingOption!
    
    var disposeBag = DisposeBag()
    
    //MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .medium)
        return label
    }()

    //MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        contentView.backgroundColor = .white
       
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureUI(option: VillageSettingOption) {
        settingOption = option
        titleLabel.text = option.title
    }
}
