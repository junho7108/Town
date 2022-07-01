import UIKit
import RxSwift

class CreateVoteCell: UITableViewCell {
    
    static let identifier = "VoteCellIdentifier"
    
    //MARK: - UI Properties
    
    let contentsTextView: InputTextView = {
        let textView = InputTextView(edgeInset: .init(top: 9, left: 16, bottom: 10, right: 26))
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.maxTextCount = 50
        textView.font = .suitFont(size: 13, weight: .regular)
        textView.placeholder = "내용을 작성해주세요."
        textView.placeholderLabel.font = .suitFont(size: 13, weight: .regular)
        return textView
    }()

    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_arrow_left"), for: .normal)
        return button
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
        selectionStyle = .none
    
        contentView.backgroundColor = .grey100
        contentsTextView.sizeToFit()

        contentsTextView.layer.cornerRadius = contentsTextView.frame.height / 2
        contentView.addSubview(contentsTextView)
        contentsTextView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(15)
            make.width.height.equalTo(10)
        }
    }
    
    func configureUI(text: String) {
        self.contentsTextView.text = text
    }
}
