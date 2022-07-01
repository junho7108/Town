import UIKit

class ThirdMBTISimpleTestViewController: BaseViewController {
    
    var coordinator: ThirdMBTISimpleTestCoordinator?
    
    let viewModel: ThirdMBTISimpleTestViewModel
    
    //MARK: - UI Properties
    
    private let selfView = ThirdMBTISimpleTestView()
    
    //MARK: - Lifecycles
    
    init(viewModel: ThirdMBTISimpleTestViewModel) {
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
        let output = viewModel.transform(input: .init(tapFButton: selfView.firstSelectButton.rx.tap.asObservable(),
                                                      tapTButton: selfView.secondSelectButton.rx.tap.asObservable(),
                                                      tapCompleteButton: selfView.completeButton.rx.tap.asObservable()))
        
        output.selectedThirdIndex
            .bind { [weak self] third in
                self?.selfView.selected(mbtiDecisions: third)
            }
            .disposed(by: disposeBag)
        
        output.completeButtonEnabled
            .bind(to: selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showLastMBTITestPage
            .bind { [weak self] (first, second, third) in
                self?.backBarButtonItem.title = "간단 테스트"
                self?.coordinator?.pushLastMBTISimpleTestScene(mbtiFirst: first, mbtiSecond: second, mbtiThird: third)
            }
            .disposed(by: disposeBag)
    }
}
