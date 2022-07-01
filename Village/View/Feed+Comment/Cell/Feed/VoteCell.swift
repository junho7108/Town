import UIKit
import RxSwift

class VoteCell: UITableViewCell {
    
    static let identifier = "VoteCellIdentifier"
    
    static let rowHeight: CGFloat = 48
    
    
    //MARK: - UI Properties
    
    private let containerView = UIView()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    var disposeBag = DisposeBag()
    
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
        disposeBag = DisposeBag()
    }

    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        containerView.layer.cornerRadius = 40 / 2
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(9)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    func configureUI(text: String, colorType: BackgroundColorType, numberOfLines: Int) {
        contentLabel.numberOfLines = numberOfLines
        contentLabel.text = text

        switch colorType {
        case .white:
            contentView.backgroundColor = .grey100
            containerView.backgroundColor = .white
            
        case .grey:
            contentView.backgroundColor = .white
            containerView.backgroundColor = .grey100
        }
    }
}
