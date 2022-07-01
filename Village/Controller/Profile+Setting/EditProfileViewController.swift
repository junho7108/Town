import UIKit
import RxSwift
import RxRelay
import RxKeyboard
import FloatingPanel

class EditProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: EditProfileCoordinator?
    
    let viewModel: EditProfileViewModel
    
    private(set) var user: User
    
    //MARK: - UI Properties
    
    private(set) var floatingVC = FloatingPanelController()
    
    private lazy var editMBTIVC = EditMBTIViewController(mbti: user.mbti)
    
    private let selfView: EditProfileView
    
    //MARK: - Lifecycles
    
    init(user: User, viewModel: EditProfileViewModel) {
        self.user = user
        self.selfView = EditProfileView(user: user)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingPanel()
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureFloatingPanel() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 30
        appearance.backgroundColor = .white
        appearance.borderColor = .clear
        appearance.borderWidth = 0
       
        floatingVC.surfaceView.appearance = appearance
        floatingVC.set(contentViewController: editMBTIVC)
        floatingVC.layout = MyFloatingPanelLayout()
        floatingVC.addPanel(toParent: self)
        floatingVC.invalidateLayout()
        floatingVC.hide()
    }
    
    //MARK: - Bindis
    
    override func setUpBindins() {
    
        //MARK: BINDS
        
        floatingVC.backdropView.rx.tapGesture(configuration: nil)
            .when(.recognized)
            .bind { _ in
                self.floatingVC.hide(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        selfView.editMBTISelectTextField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.selfView.editMBTISelectTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        floatingVC.rx.didChangeState
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { floatingVC in
                switch floatingVC.state {
                case .tip:
                    floatingVC.hide(animated: true, completion: nil)

                default: return
                }
            })
            .disposed(by: disposeBag)
     
        //MARK: INPUT
        
        let tapEditMBTI = selfView.editMBTISelectTextField.rx.tapGesture().when(.recognized).map { _ in }
        
        let tapMBTIEnergy = Observable.merge([
            editMBTIVC.selfView.energyView.extraversionButton.rx.tap.asObservable().map { MBTIEnergy.E },
            editMBTIVC.selfView.energyView.introversionButton.rx.tap.asObservable().map { MBTIEnergy.I }
        ])
          
        let tapMBTIInfo = Observable.merge([
            editMBTIVC.selfView.informationView.iNtuitionButton.rx.tap.asObservable().map { MBTIInformation.N },
            editMBTIVC.selfView.informationView.sensingButton.rx.tap.asObservable().map { MBTIInformation.S }
        ])

        let tapMBTIDecisions = Observable.merge([
            editMBTIVC.selfView.decisionsView.thinkingButton.rx.tap.asObservable().map { MBTIDecisions.T },
            editMBTIVC.selfView.decisionsView.feelingButton.rx.tap.asObservable().map { MBTIDecisions.F }
        ])
      
        let tapMBTILifestyle = Observable.merge([
            editMBTIVC.selfView.lifestyleView.judgingButton.rx.tap.asObservable().map { MBTILifestyle.J },
            editMBTIVC.selfView.lifestyleView.perceivingButton.rx.tap.asObservable().map { MBTILifestyle.P }
        ])

        let tapEditNickname = PublishRelay<String>()

        let tapEditDate = PublishRelay<String>()

        let tapEditGender = PublishRelay<Gender>()

        tapMBTIEnergy
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .I)
            .drive(onNext: { [weak self] first in
                self?.editMBTIVC.selfView.energyView.selectEnergy(energy: first)
            })
            .disposed(by: disposeBag)

        tapMBTIInfo
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .N)
            .drive(onNext: { [weak self] second in
                self?.editMBTIVC.selfView.informationView.selectInformation(information: second)
                
            })
            .disposed(by: disposeBag)

        tapMBTIDecisions
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .F)
            .drive(onNext: { [weak self] third in
                self?.editMBTIVC.selfView.decisionsView.selectDecisions(decisions: third)
            })
            .disposed(by: disposeBag)

        tapMBTILifestyle
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .P)
            .drive(onNext: { [weak self] last in
                self?.editMBTIVC.selfView.lifestyleView.selectLifestyle(lifestyle: last)
            })
            .disposed(by: disposeBag)

        selfView.editNicknameTextField.rx.text.orEmpty
                .bind { [unowned self] nickname in
                    if nickname.isEmpty {
                        tapEditNickname.accept(user.nickname)
                    } else {
                        tapEditNickname.accept(nickname)
                    }
                }
                .disposed(by: disposeBag)

        selfView.selectDateBarButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let dateString = self?.selfView.selectedDateString else { return }
                tapEditDate.accept(dateString)
            })
            .disposed(by: disposeBag)

        Observable.merge([
            selfView.maleButton.rx.tap.map { Gender.male },
            selfView.femaleButton.rx.tap.map { Gender.female },
            selfView.noneButton.rx.tap.map { Gender.none }
        ])
            .distinctUntilChanged()
            .bind(to: tapEditGender)
            .disposed(by: disposeBag)

        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(tapMBTIEnergy: tapMBTIEnergy.asObservable(),
                                                      tapMBTIInformation: tapMBTIInfo.asObservable(),
                                                      tapMBTIDecisions: tapMBTIDecisions.asObservable(),
                                                      tapMBTILifestyle: tapMBTILifestyle.asObservable(),
                                                      tapEditMBTI: tapEditMBTI.asObservable(),
                                                      tapEditNickname: tapEditNickname.asObservable(),
                                                      tapEditDate: tapEditDate.asObservable(),
                                                      tapEditGender: tapEditGender.asObservable(),
                                                      tapComplete: Observable.just(Void())))

        output.showMBTIBottomSheetPage
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.floatingVC.show(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        output.editedNickname
            .bind { nickname in
                print(nickname)
            }
            .disposed(by: disposeBag)

        output.editedMBTI
            .skip(1)
            .bind { [weak self] mbti in
                guard let self = self else { return }
                self.selfView.bindMBTI(mbti: mbti)
            }
            .disposed(by: disposeBag)

        output.editedDate
            .bind { [weak self] dateString in
                self?.selfView.editDate()
            }
            .disposed(by: disposeBag)

        output.editedGender
            .bind { [weak self] gender in
                self?.selfView.selectGender(gender: gender)
            }
            .disposed(by: disposeBag)

        output.editEnabled
            .bind(onNext: { [weak self] enabled in
                self?.selfView.isEditable = enabled
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - EditProfileViewController
 
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selfView.backgroundColor = .grey300
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selfView.backgroundColor = .white
    }
}

//MARK: - FloatingPanelLayout

extension EditProfileViewController {
    class MyFloatingPanelLayout: FloatingPanelLayout {
        var position: FloatingPanelPosition {
            return .bottom
        }
        
        var initialState: FloatingPanelState {
            return .full
        }
        
        var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 334, edge: .bottom, referenceGuide: .safeArea),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: 334 / 2, edge: .bottom, referenceGuide: .safeArea),
            ]
        }
    }
}
