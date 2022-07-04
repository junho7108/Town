import UIKit

final class SecondMBTISimpleTestViewController: BaseViewController {
    
    var coordinator: SecondMBTISimpleTestCoordinator?
    
    let viewModel: SecondMBTISimpleTestViewModel
    
    //MARK: - UI Properties
    
    private let selfView = SecondMBTISimpleTestView()
    
    //MARK: - Lifecycles
    
    init(viewModel: SecondMBTISimpleTestViewModel) {
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
        
        let output = viewModel.transform(input: .init(tapSButton: selfView.firstSelectButton.rx.tap.asObservable(),
                                                      tapNButton: selfView.secondSelectButton.rx.tap.asObservable(),
                                                      tapCompleteButton: selfView.completeButton.rx.tap.asObservable()))
        
        output.selectedSecondIndex
            .bind { [weak self] info in
                self?.selfView.selected(mbtiInfo: info)
            }
            .disposed(by: disposeBag)
        
        output.completeButtonEnabled
            .bind(to: selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showThirdMBTITestPage
            .bind { [weak self] (first, second) in
                self?.backBarButtonItem.title = "간단 테스트"
                self?.coordinator?.pushThirdMBTISimpleTestScene(mbtiFirst: first, mbtiSecond: second)
            }
            .disposed(by: disposeBag)
    }
}
