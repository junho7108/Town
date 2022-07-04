import UIKit

final class SignUpCompleteViewController: BaseViewController {
    
    var coordinator: SignUpCompleteCoordinator?
    
    //MARK: - UI Properites
    
    private let selfView = SignUpCompleteView()
    
    //MARK: - Configures
    
    override func configureUI() {
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
        
        selfView.completeButton.rx.tap
            .bind { [weak self] in
                self?.selfView.promisePopup.isHidden = true
                self?.selfView.villageStartPopup.isHidden = false
            }
            .disposed(by: disposeBag)
        
        selfView.villageStartButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.pushMainScene()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
}
