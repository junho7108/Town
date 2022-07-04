import UIKit

final class AppVersionViewController: BaseViewController {
    
    var coordinator: AppVersionCoordinator?
    
    private let selfView = AppVersionView()
    
    override func configureUI() {
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
