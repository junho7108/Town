import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

final class SignUpNicknameViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: SignUpNicknameCoordinator?
    
    let viewModel: SignUpNicknameViewModel

    //MARK: - UI Properties
    
    private var selfView: SignUpNicknameView
    
    //MARK: - Lifecycles
    
    init(mbti: MBTIType, viewModel: SignUpNicknameViewModel) {
        self.selfView = SignUpNicknameView(mbti: mbti)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                if height > 0 {
                    self?.keyboardWillShow()
                } else {
                    self?.keyboardWillHide()
                }
            })
            .disposed(by: disposeBag)
        
        // INPUT
    
        let editUserNickname = selfView.inputTextField.rx.text.orEmpty
        let tapCompleteButton = selfView.completeButton.rx.tap.map { _ in }
        
        editUserNickname.bind { [weak self] nickname in
            guard let self = self else { return }
            
            if nickname.count >= 12 {
                self.selfView.inputTextField.text?.removeLast()
            }
            
            self.selfView.nicknameCountLabel.text = "\(nickname.count) / \(self.selfView.nicknameMaxLength)"
        }
        .disposed(by: disposeBag)
        
        // OUTPUT
        
        let output = viewModel.transform(input: .init(editUserNickname: editUserNickname.asObservable(),
                                                      tapCompleteButton: tapCompleteButton.asObservable()))
        
       
        output.showSignUpProfilePage
            .bind { [weak self] request in
                self?.coordinator?.pushSignUpProfileScene(request: request)
            }
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .bind { [weak self] errorMessage in
                self?.showToast(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helpers
    
    private func keyboardWillShow() {
        selfView.completeButton.isHidden = true
        self.selfView.profileImageView.snp.remakeConstraints({ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(-200)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(184)
            
            self.selfView.setNeedsLayout()
        })
    }
    
    private func keyboardWillHide() {
        selfView.completeButton.isHidden = false
        self.selfView.profileImageView.snp.remakeConstraints({ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(184)
            
            self.selfView.setNeedsLayout()
        })
    }
}
