import UIKit

final class HomeBottomSheetViewController: BaseViewController {
    
    //MARK: - UI Properties
    
    let selfView = HomeBottomSheetView()
    
    
    //MARK: - Configures
    
    override func configureUI() {
        selfView.competitionLayout.itemSize = CGSize(width: view.frame.width, height: 247)
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
