import UIKit
import RxSwift
import RxRelay
import RxKeyboard
import RxGesture

class DeclarationViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: DeclarationCoordinator?
    
    private let selfView = DeclarationView()
    
    let viewModel: DeclarationViewModel
    
    //MARK: - Lifecycles
    
    init(viewModel: DeclarationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Configures
    
    override func configureUI() {
        hidesBottomBarWhenPushed = true
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
      
        //MARK: INPUT
        
        var tapDeclarationType = Observable<DeclarationType>.empty()
        let contentDidChange = selfView.contentsTextView.rx.text.orEmpty
        let tapCompleteButton = selfView.completeButton.rx.tap
        let tapDeclarationButton = selfView.completePopupView.okButton.rx.tap
        
        tapDeclarationType = Observable.merge([
            selfView.ADButton.rx.tap.map { DeclarationType.AD },
            selfView.paperingButton.rx.tap.map { DeclarationType.papering },
            selfView.abuseButton.rx.tap.map { DeclarationType.abuse },
            selfView.sensationalButton.rx.tap.map { DeclarationType.sensational },
            selfView.suggestButton.rx.tap.map { DeclarationType.suggest },
            selfView.contentsTextView.rx.tapGesture(configuration: nil).when(.recognized).map { _ in DeclarationType.suggest }
        ])
        
        //MARK: BINDS
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                self.selfView.contentInset = .init(top: 0, left: 0, bottom: 60 + height, right: 0)
//                self.selfView.completeButton.snp.updateConstraints { make in
//                    make.bottom.equalToSuperview().inset(60 + height)
//                }
            })
            .disposed(by: disposeBag)

        selfView.rx.tapGesture(configuration: nil)
            .when(.recognized)
            .bind { [weak self] _ in
                self?.selfView.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(tapDeclarationType: tapDeclarationType.asObservable(),
                                                      contentDidChange: contentDidChange.asObservable(),
                                                      tapCompleteButton: tapCompleteButton.asObservable(),
                                                      tapDeclarationButton: tapDeclarationButton.asObservable()))
        
       
        
        output.updateContent
            .bind {[weak self] text in
                guard let self = self,
                      let maxCount = self.selfView.contentsTextView.maxTextCount else { return }
                self.selfView.contentsTextCountLabel.text = "\(text.count) / \(maxCount)"
                self.selfView.updateContentTextViewHeight()
            }
            .disposed(by: disposeBag)
        
        output.selectedDeclarationType
            .distinctUntilChanged()
            .bind { [weak self] declrationType in
               
                self?.selfView.selectDeclarationType(type: declrationType)
                
                if declrationType == .suggest {
                    self?.selfView.contentsTextView.becomeFirstResponder()
                } else {
                    self?.selfView.contentsTextView.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
        
        output.completeButtonEnabled
            .bind(to: selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showDeclarationConfirmPage
            .bind { [unowned self] in
                selfView.completePopupView.show(parent: self, completion: nil)
            }
            .disposed(by: disposeBag)
        
        output.declarationComplete
            .bind { [weak self] in
                self?.selfView.completePopupView.dismiss(animated: false) {
                    self?.showToast(message: "신고가 접수되었습니다.")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
