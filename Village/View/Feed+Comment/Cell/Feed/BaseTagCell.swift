import UIKit
import RxSwift

class BaseTagCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let cellIdentifier = "baseTagCellIdentifier"
    
    private(set) var disposeBag = DisposeBag()

    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .suitFont(size: 15, weight: .bold)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        contentView.backgroundColor = .grey200
        contentView.layer.cornerRadius = 32 / 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 1
       
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configureUI(text: String, isSelected: Bool) {
        titleLabel.text = text
        selectCategory(isSelected: isSelected)
    }
    
    func configureViewMoreButton(text: String) {
        titleLabel.text = text
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.grey300.cgColor
        titleLabel.textColor = .grey300
    }
    
    //MARK: - Helpers
    
    func selectCategory(isSelected: Bool) {
        contentView.backgroundColor = isSelected ? .white : .grey200
        contentView.layer.borderColor = isSelected ? UIColor.villageSky.cgColor : UIColor.clear.cgColor
        titleLabel.textColor = isSelected ? .villageSky : .white
    }
    
    static func fittingsize(availableHeight: CGFloat = 32, text: String) -> CGSize {
        let cell = BaseTagCell()
        cell.titleLabel.text = text
      
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        let size =  cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
        return size
    }
}
