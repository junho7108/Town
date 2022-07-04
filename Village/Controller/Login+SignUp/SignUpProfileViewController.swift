import UIKit
import RxSwift
import RxCocoa

final class SignUpProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: SignUpProfileCoordinator?
    
    let viewModel: SignUpProfileViewModel
    
    //MARK: - UI Properties
    
    private let selfView = SignUpProfileView()
    
    //MARK: - Lifecycles
    
    init(viewModel: SignUpProfileViewModel) {
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
        
        // INPUT
        
        let tapSelectGender = PublishRelay<Gender>()
        let tapSelectDate = PublishRelay<String>()
        let tapCompleteButton = selfView.completeButton.rx.tap
        
        Observable.merge([
            selfView.maleButton.rx.tap.map { Gender.male },
            selfView.femaleButton.rx.tap.map { Gender.female },
            selfView.noneButton.rx.tap.map { Gender.none }
        ])
            .distinctUntilChanged()
            .do(onNext: { [weak self] gender in self?.selfView.selectGender(gender: gender)})
            .bind(to: tapSelectGender)
            .disposed(by: disposeBag)
        
        selfView.selectDateBarButton.rx.tap
            .bind{ [weak self] in
                self?.selfView.selectDate()
                guard let dateString = self?.selfView.selectDateTextField.text else { return }
                tapSelectDate.accept(dateString)
            }
            .disposed(by: disposeBag)
        

        // OUTPUT
        
        let output = viewModel.transform(input: .init(tapSelectGender: tapSelectGender.asObservable(),
                                                      tapSelectDate: tapSelectDate.asObservable(),
                                                      tapCompleteButton: tapCompleteButton.asObservable()))
      
        output.completeButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showMainPage
            .bind { [weak self] in
//                self?.coordinator?.pushMainScene()
                self?.coordinator?.pushSignUpCompleteScene()
            }
            .disposed(by: disposeBag)
        
        output.activating
            .map { !$0 }
            .bind(to: selfView.loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .bind { errorMessage in
                Logger.printLog(errorMessage)
//                let errorPopup = BasePopupViewController(message: errorMessage)
//                errorPopup.show(parent: self, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
