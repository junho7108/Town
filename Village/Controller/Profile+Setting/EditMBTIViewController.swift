import UIKit

final class EditMBTIViewController: BaseViewController {
    
    //MARK: - UI Properties
    
    let selfView: EditMBTIView
    
    //MARK: - Configures
    
    init(mbti: MBTIType) {
        selfView = EditMBTIView(mbti: mbti, frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
