import UIKit
import RxSwift
import RxCocoa
import RxGesture
import MaterialComponents

class SignUpMBTIViewConroller: BaseViewController {
    
    //MARK: - Properties
    
    let viewModel: SignUpMBTIViewModel
    
    var coordinator: SignUpMBTICoordinator?
    
    
    //MARK: - UI Properties
    
    private let selfView = SignUpMBTIView()
    
    //MARK: - Lifecycle
    
    init(viewModel: SignUpMBTIViewModel) {
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
        
        let tapMBTIEnergy = Observable.merge([
            selfView.energyView.extraversionButton.rx.tap.map { MBTIEnergy.E },
            selfView.energyView.introversionButton.rx.tap.map { MBTIEnergy.I }
        ])
        
        let tapMBTIInformation = Observable.merge([
            selfView.informationView.sensingButton.rx.tap.map { MBTIInformation.S },
            selfView.informationView.iNtuitionButton.rx.tap.map { MBTIInformation.N }
        ])
        
        let tapMBTIDecisions = Observable.merge([
            selfView.decisionsView.thinkingButton.rx.tap.map { MBTIDecisions.T },
            selfView.decisionsView.feelingButton.rx.tap.map { MBTIDecisions.F }
        ])
        
        let tapMBTILifestyle = Observable.merge([
            selfView.lifestyleView.judgingButton.rx.tap.map { MBTILifestyle.J },
            selfView.lifestyleView.perceivingButton.rx.tap.map { MBTILifestyle.P }
        ])
        
        // UI Bindings
        
        tapMBTIEnergy
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .I)
            .drive(onNext: { [weak self] energy in
                self?.selfView.energyView.selectEnergy(energy: energy)
            })
            .disposed(by: disposeBag)
        
        tapMBTIInformation
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .N)
            .drive(onNext: { [weak self] info in
                self?.selfView.informationView.selectInformation(information: info)
            })
            .disposed(by: disposeBag)
        
        tapMBTIDecisions
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .F)
            .drive(onNext: { [weak self] decisions in
                self?.selfView.decisionsView.selectDecisions(decisions: decisions)
            })
            .disposed(by: disposeBag)
        
        tapMBTILifestyle
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .P)
            .drive(onNext: { [weak self] lifestyle in
                self?.selfView.lifestyleView.selectLifestyle(lifestyle: lifestyle)
            })
            .disposed(by: disposeBag)
        
        
        // OUTPUT
        
        let output = viewModel.transform(input: .init(tapMBTIEnergy: tapMBTIEnergy.asObservable(),
                                                      tapMBTIInformation: tapMBTIInformation.asObservable(),
                                                      tapMBTIDecisions: tapMBTIDecisions.asObservable(),
                                                      tapMBTILifestyle: tapMBTILifestyle.asObservable(),
                                                      tapComplete: selfView.completeButton.rx.tap.asObservable(),
                                                      tapMBTILink: selfView.linkButton.rx.tap.asObservable(),
                                                      tapSimpleMBTITest: selfView.inputViewControlelr.selfView.simpleTestButton.rx.tap.asObservable(),
                                                      tapDetailMBTITest: selfView.inputViewControlelr.selfView.detailTestButton.rx.tap.asObservable()))
        
        output.selectButtonEnabled
            .bind(to: selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.selectedMBTI
            .observe(on: MainScheduler.instance)
            .bind { [weak self] mbti in
                self?.selfView.profileImage = mbti?.characterImage ?? #imageLiteral(resourceName: "img_home_leader")
            }
            .disposed(by: disposeBag)
        
        output.showSignInPage
            .bind { [weak self] request in
                self?.backBarButtonItem.title = ""
                self?.coordinator?.pushInputNicknameScene(request: request)
            }
            .disposed(by: disposeBag)
        
        output.showMBTILinkPage
            .bind { [unowned self] _ in
                let bottomSheetVC = MDCBottomSheetController(contentViewController: selfView.inputViewControlelr)
                bottomSheetVC.mdc_bottomSheetPresentationController?.preferredSheetHeight = 255
                present(bottomSheetVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        output.showSimpleMBTITestPage
            .bind { [weak self] in
                self?.selfView.inputViewControlelr.dismiss(animated: true) {
                    self?.backBarButtonItem.title = "간단 테스트"
                    self?.coordinator?.pushMBTISimpleTestScene()
                }
            }
            .disposed(by: disposeBag)
        
        output.showDetailMBTITestPage
            .bind { [weak self] _ in
                self?.selfView.inputViewControlelr.dismiss(animated: true) {
                    if let url = URL(string: "https://www.16personalities.com/ko/%EB%AC%B4%EB%A3%8C-%EC%84%B1%EA%B2%A9-%EC%9C%A0%ED%98%95-%EA%B2%80%EC%82%AC") {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helpers
    
    func configureMBTI(mbti: MBTIType) {
        selfView.energyView.selectEnergy(energy: mbti.firstIndex)
        selfView.informationView.selectInformation(information: mbti.secondIndex)
        selfView.decisionsView.selectDecisions(decisions: mbti.thirdIndex)
        selfView.lifestyleView.selectLifestyle(lifestyle: mbti.lastIndex)
        
        viewModel.selectedMBTI.accept(mbti)
    }
}
