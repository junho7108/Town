import UIKit

class EditMBTIProfileViewController: BaseViewController {
    
    let contentView: EditMBTIView
    
    init(mbti: MBTIType) {
        contentView = EditMBTIView(mbti: mbti, frame: .zero)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
