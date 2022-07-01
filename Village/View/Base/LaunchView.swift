import UIKit

final class LaunchView: BaseView {
    
    //MARK: - UI Properties
    
    
    private let launchImageView = UIImageView(image: #imageLiteral(resourceName: "LaunchScreen").withRenderingMode(.alwaysOriginal))

    override func configureUI() {
        backgroundColor = .white
        launchImageView.contentMode = .scaleAspectFit
        
        addSubview(launchImageView)
        launchImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
