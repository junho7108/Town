import UIKit

class NoCommentTableFooterView: BaseView {
    
    //MARK: - UI Properties
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 댓글이 없어요 💬"
        label.textColor = .grey300
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    //MARK: - Lifecycles
    
    //MARK: - Configures
    
    override func configureUI() {
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
    }
}
