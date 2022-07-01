import UIKit

class ActionSheetCell: UITableViewCell {
    
    static let identifier = "actionSheetCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .bold)
        label.textColor = .grey300
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureActionSheet(option: ActionSheetOption) {
        self.titleLabel.text = option.title
    }
}
