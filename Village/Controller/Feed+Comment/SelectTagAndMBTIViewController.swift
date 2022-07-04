import UIKit

final class SelectTagAndMBTIViewController: BaseViewController {
    
    //MARK: - UI Properties
    
    private(set) var selfView = SelectTagsView()
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

