import UIKit

class MBTILinkViewController: BaseViewController {
    
    //MARK: - UI Properties
    
    let selfView = MBTILinkView()
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
