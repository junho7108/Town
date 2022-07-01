import UIKit
import RxSwift
import RxCocoa

final class CommentInputView: BaseView {
    
    //MARK: - Properties

    private(set) var maxHeight: CGFloat = 110.0
    
    override var intrinsicContentSize: CGSize {
        if commentInputView.isScrollEnabled {
            return .init(width: UIScreen.main.bounds.width, height: maxHeight + 16)
        } else {
            return .init(width: UIScreen.main.bounds.width, height: estimatedSize.height + 16)
        }
    }
    
    private(set) var estimatedSize: CGSize = .zero
    
    //MARK: - UI Properties
    
    let commentInputView: InputTextView = {
        let textView = InputTextView(edgeInset: .init(top: 8, left: 8, bottom: 8, right: 8))
        textView.isScrollEnabled = false
        textView.backgroundColor = .white
        textView.placeholder = "댓글을 남겨보세요."
        textView.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 24)
        textView.font = .suitFont(size: 13, weight: .regular)
        return textView
    }()
   
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_circlearrow_enter").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let imageBackgroundView = UIView()
    
    let contentImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .grey100
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let removeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_delete").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .grey100
        autoresizingMask = .flexibleHeight
        layer.cornerRadius = 24
        
        let commentInputBackgroundView = UIView()
        commentInputBackgroundView.backgroundColor = .grey100
        
        let spacingView = UIView()
        spacingView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        let stackView = UIStackView(arrangedSubviews: [imageBackgroundView, commentInputBackgroundView])
        stackView.axis = .vertical
        stackView.spacing = 0
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageBackgroundView.backgroundColor = .black.withAlphaComponent(0.7)

        imageBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(104)
        }

        imageBackgroundView.addSubview(contentImageView)
        contentImageView.backgroundColor = .red
        contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(137)
            make.height.equalTo(80)
        }

        imageBackgroundView.addSubview(removeImageButton)
        removeImageButton.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.top).inset(7)
            make.trailing.equalTo(contentImageView.snp.trailing).inset(7)
            make.width.height.equalTo(16)
        }

        commentInputBackgroundView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(56)
        }
    
        commentInputBackgroundView.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(19)
            make.width.height.equalTo(18)
        }
    
        commentInputBackgroundView.addSubview(commentInputView)
        commentInputView.layer.cornerRadius = 16
        commentInputView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(uploadButton.snp.trailing).offset(11)
            make.trailing.equalToSuperview().inset(16)
            make.height.lessThanOrEqualTo(maxHeight)
        }
        
        commentInputView.placeholderLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        commentInputBackgroundView.addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        imageBackgroundView.isHidden = true
    }
    
    
    func configureUI(comment: Comment) {
        commentInputView.text = comment.content
        commentInputView.becomeFirstResponder()
        
        if let imageURL = comment.image {
            DispatchQueue.global().async { [weak self] in
                let data = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    let commentImage = UIImage(data: data!)
                    self?.selectImage(image: commentImage!)
                }
            }
        } else {
            removeImage()
        }
    }
     
    //MARK: - Helpers
    
    override func setUpBindis() {
        
        commentInputView.rx.text.orEmpty
            .share()
            .map { $0.isEmpty }
            .bind(to: postButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.merge([
            commentInputView.rx.didChange.map { _ in }.asObservable(),
            commentInputView.rx.text.orEmpty.share().map { _ in }.asObservable()
        ])
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                let size = CGSize(width: self.commentInputView.frame.width, height: .infinity)
                estimatedSize = self.commentInputView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height >= maxHeight
                commentInputView.isScrollEnabled = isMaxHeight
                
                commentInputView.invalidateIntrinsicContentSize()
                invalidateIntrinsicContentSize()
            })
            .disposed(by: disposeBag)
    }
    
    
    func selectImage(image: UIImage) {
        contentImageView.image = image
        uploadButton.setImage(#imageLiteral(resourceName: "ic_photo-1").withRenderingMode(.alwaysOriginal),
                              for: .normal)

        imageBackgroundView.isHidden = false
    }
    
    func removeImage() {
        contentImageView.image = nil
       
        uploadButton.setImage(#imageLiteral(resourceName: "ic_photo").withRenderingMode(.alwaysOriginal),
                              for: .normal)
        imageBackgroundView.isHidden = true
    }
    
    func clear() {
        removeImage()
        commentInputView.text = nil
        commentInputView.resignFirstResponder()
    }
}
