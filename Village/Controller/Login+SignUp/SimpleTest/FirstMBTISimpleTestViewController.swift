import UIKit
import RxSwift
import RxCocoa

class FirstMBTISimpleTestViewController: BaseViewController {
    
    var coordinator: FirstMBTISimpleTestCoordinator?
    
    let viewModel: FirstMBTISimpleTestViewModel
    
    //MARK: - UI Properties
    
    private let selfView = FirstMBTISimpleTestView()
    
    //MARK: - Lifecycles
    
    init(viewModel: FirstMBTISimpleTestViewModel) {
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
        
        let output = viewModel.transform(input: .init(tapEButton: selfView.firstSelectButton.rx.tap.asObservable(),
                                                      tapIButton: selfView.secondSelectButton.rx.tap.asObservable(),
                                                      tapCompleteButton: selfView.completeButton.rx.tap.asObservable()))
        
        output.selectedFirstIndex
            .bind { [weak self] firstIndex in
                self?.selfView.selected(mbtiEnergy: firstIndex)
            }
            .disposed(by: disposeBag)
        
        output.completeButtonEnabled
            .bind(to: selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showSecondMBTITestPage
            .bind { [weak self] energy in
                self?.backBarButtonItem.title = "간단 테스트"
                self?.coordinator?.pushSecondMBTISimpleTestScene(mbtiEnergy: energy)
            }
            .disposed(by: disposeBag)
    }
}
