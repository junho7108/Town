import UIKit

final class LastMBTISimpleTestViewController: BaseViewController {
    
    var coordinator: LastMBTISimpleTestCoordinator?
    
    let viewModel: LastMBTISimpleTestViewModel
    
    //MARK: - UI Properties
    
    private let selfView = LastMBTISimpleTestView()
    
    //MARK: - Lifecycles
    
    init(viewModel: LastMBTISimpleTestViewModel) {
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
        let output = viewModel.transform(input: .init(tapJButton: selfView.firstSelectButton.rx.tap.asObservable(),
                                                      tapPButton: selfView.secondSelectButton.rx.tap.asObservable(),
                                                      tapCompleteButton: selfView.completeButton.rx.tap.asObservable()))
        
        
        output.selectedLastIndex
            .bind { [weak self] last in
                self?.selfView.selected(mbtiLife: last)
            }
            .disposed(by: disposeBag)
        
        output.completeButtonEnabled
            .bind(to: selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showTestFinishPage
            .bind { [weak self] mbti in
                self?.backBarButtonItem.title = "간단 테스트"
                self?.coordinator?.pushTestFinishScene(mbti: mbti)
                Logger.printLog(mbti)
            }
            .disposed(by: disposeBag)
    }
}
