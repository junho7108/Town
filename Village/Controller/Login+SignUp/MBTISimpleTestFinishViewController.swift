import UIKit

class MBTISimpleTestFinishViewController: BaseViewController {
    
    var coordinator: MBTISimpleTestFinishCoordinator?
    
    let viewModel: MBTISimpleTestFinishViewModel
    
    //MARK: - UI Properties
    
    private let selfView = MBTISimpleTestFinishView()
    
    //MARK: - Lifecycles
    
    init(viewModel: MBTISimpleTestFinishViewModel) {
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
        let output = viewModel.transform(input: .init(tapCompleteButton: selfView.completeButton.rx.tap.asObservable()))
        
        output.mbti
            .bind { [weak self] mbti in
                self?.selfView.mbtiLabel.text = "\(mbti.title) (\(mbti.nickname))"
            }
            .disposed(by: disposeBag)
        
        output.showSignUpPage
            .bind { [weak self] in
                self?.backBarButtonItem.title = ""
                self?.coordinator?.popToSignUpScene()
            }
            .disposed(by: disposeBag)
        
    }
}
