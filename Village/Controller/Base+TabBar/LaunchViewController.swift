import UIKit

final class LaunchViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: LaunchCoordinator?
    
    let viewModel: LaunchViewModel
    
    //MARK: - UI Properties
    
    private let selfView = LaunchView()
    
    //MARK: - Lifecycles
    
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setUpBindins() {
        
        let output = viewModel.transform(input: .init(viewDidLoad: rx.viewDidAppear.map { _ in }.asObservable()))
        
        output.showSignUpPage
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.coordinator?.pushLoginScene()
            })
            .disposed(by: disposeBag)
        
        output.showMainPage
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.coordinator?.pushMainScene()
            })
            .disposed(by: disposeBag)

        output.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
    }
}
