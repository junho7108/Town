import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn
import AuthenticationServices

final class LoginViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: LoginCoordinator?
    
    let viewModel: LoginViewModel
    
    //MARK: - UI Properties
   
    private let selfView = LoginView()
    
    //MARK: - Lifecycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Binds
    
    func setupBindings() {
        
        viewModel.dependencies.googleLoginManager.viewController = self
        viewModel.dependencies.appleLoginManager.viewController = self
        
        selfView.TOSlinkLabel.rx.tapGesture(configuration: nil)
            .when(.recognized)
            .bind { _ in
                if let url = URL(string: VillageServiceURL.TOS) {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)
        
        selfView.privacyLinkLabel.rx.tapGesture(configuration: nil)
            .when(.recognized)
            .bind { _ in
                if let url = URL(string: VillageServiceURL.privacyPolicy) {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)
        
        // INPUT
        
        let tapSocialLogin =  Observable.merge(
            selfView.naverLoginButton.rx.tap.map { SocialLoginType.naver },
            selfView.googleLoginButton.rx.tap.map { SocialLoginType.google },
            selfView.kakaoLoginButton.rx.tap.map { SocialLoginType.kakao },
            selfView.appleLoginButton.rx.tap.map { SocialLoginType.apple }
        )
     
        // OUTPUT
        
        let output = viewModel.transform(input: .init(tapSocialLogin: tapSocialLogin.asObservable()))
        
        output.showMainPage.bind { [weak self] in
            self?.coordinator?.pushMainScene()
        }
        
        .disposed(by: disposeBag)
        
        output.showSignUpPage
            .bind { [weak self] request in
                self?.coordinator?.pushSignUpScene(request: request)
            }
            .disposed(by: disposeBag)
          
        output.activated
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(selfView.loadingView.rx.isHidden)
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
