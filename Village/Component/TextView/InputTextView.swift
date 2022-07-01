import UIKit
import RxSwift
import RxCocoa

class InputTextView: UITextView {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    var maxTextCount: Int?

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    override var text: String! {
        didSet {
            if text == nil || text.isEmpty {
                placeholderLabel.isHidden = false
            } else {
                placeholderLabel.isHidden = true
            }
        }
    }
   
    //MARK: - Lifecycle
    
    init(edgeInset: UIEdgeInsets = .zero) {
        super.init(frame: .zero, textContainer: nil)
        configureUI(edgeInset: edgeInset)
        setupBinds()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    private func configureUI(edgeInset: UIEdgeInsets) {
        textContainerInset = edgeInset
        backgroundColor = .white
     
        font = .suitFont(size: 15)
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        keyboardType = .twitter
        
        bounces = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setupBinds() {
        self.rx.didBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.placeholderLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                if let text = self?.text {
                    self?.placeholderLabel.isHidden = !text.isEmpty
                }
            })
            .disposed(by: disposeBag)
        
        self.rx.text.orEmpty
            .bind { [unowned self] text in
                guard let maxTextCount = maxTextCount else {
                    return
                }

                if text.count > maxTextCount {
                    self.text.removeLast()
                }
            }
            .disposed(by: disposeBag)
    }
}
