import UIKit
import RxSwift
import RxCocoa

class WithdrawalViewController: BaseViewController {
    
    var coordinator: WithdrawalCoordinator?
    
    let viewModel: WithdrawalViewModel
    
    //MARK: - UI Properties
    
    private let selfView = WithdrawalView()
    
    //MARK: - Lifecycles
    
    init(viewModel: WithdrawalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
        
        let tapAgreeButton: Observable<Void> = selfView.agreeButton.rx.tap.asObservable()
        let tapWithdrawalButton = selfView.completeButton.rx.tap.asObservable()
        let tapWithdrawalCompleteButton = PublishRelay<Void>()
        
        let output = viewModel.transform(input: .init(tapAgreeButton: tapAgreeButton,
                                                      tapWithdrawalButton: tapWithdrawalButton,
                                                      tapWithdrawalCompleteButton: tapWithdrawalCompleteButton.asObservable()))
        
        output.withdrawalButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] enabled in
                self?.selfView.completeButton.isEnabled = enabled
                
                let enabledAgreeImage = enabled ? #imageLiteral(resourceName: "ic_check-1").withRenderingMode(.alwaysOriginal).withTintColor(.villageSky) : #imageLiteral(resourceName: "ic_check").withRenderingMode(.alwaysOriginal)
                self?.selfView.agreeButton.setImage(enabledAgreeImage, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.showWithdrawalPopup
            .bind { [weak self] in
                guard let self = self else { return }
                let withdrawalPopup = BasePopupViewController(title: "알림", content: "회원 탈퇴시 고객정보가\n삭제되며 복구되지 않습니다.\n정말 탈퇴하실건가요? 😭🥲")
                withdrawalPopup.show(parent: self, completion: nil)
                
                withdrawalPopup.okButton.rx.tap
                    .bind { _ in
                        withdrawalPopup.dismiss(animated: false, completion: nil)
                        tapWithdrawalCompleteButton.accept(())
                    }
                    .disposed(by: withdrawalPopup.disposeBag)
            }
            .disposed(by: disposeBag)

        output.showWithdrawalPage
            .bind { [weak self] in
                self?.coordinator?.popToLoginScene()
            }
            .disposed(by: disposeBag)
    }
}
