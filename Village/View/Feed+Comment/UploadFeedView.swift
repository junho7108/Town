import UIKit

class UploadFeedView: UIScrollView {
    
    //MARK: - UI Properties
    
    let contentView = UIView()

    let completeButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("완료", for: .normal)
        return button
    }()
  
    let titleTextView: InputTextView = {
        let textView = InputTextView(edgeInset: .init(top: 10, left: 16, bottom: 10, right: 16))
        textView.backgroundColor = .grey100
        textView.font = .suitFont(size: 15, weight: .regular)
        textView.placeholder = "제목을 입력해주세요."
        textView.placeholderLabel.font = .suitFont(size: 15, weight: .regular)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let contentsTextView: InputTextView = {
        let textView = InputTextView(edgeInset: .init(top: 24, left: 16, bottom: 33, right: 16))
        textView.backgroundColor = .grey100
        textView.isScrollEnabled = false
        textView.maxTextCount = 500
        textView.font = .suitFont(size: 13, weight: .regular)
        textView.placeholder = "👉 욕설 및 혐오 표현 ❌\n👉 음란성 , 선정성 게시물 ❌\n👉 과도한 만남 유도 ❌\n\n그 외 부적절한 언행 발견시 영구정지 될 수 있습니다."
        textView.placeholderLabel.font = .suitFont(size: 13, weight: .regular)
        return textView
    }()
    
    let contentsTextCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .suitFont(size: 13, weight: .regular)
        label.text = "0 / 500"
        label.textColor = .grey500
        return label
    }()
    
    let uploadPhotoView = UploadPhotoView(title: "📷 사진")
    
    let uploadVoteView = UploadVoteView(title: "🗳 투표")
    
    let uploadTagsView = UploadFeedTagsView(title: "🏷 태그")
  
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Configures
    
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(contentLayoutGuide)
            make.width.equalTo(frameLayoutGuide)
        }
        
        let uploadStackView = UIStackView(arrangedSubviews: [uploadTagsView, uploadPhotoView]) // uploadVoteView])
        uploadStackView.axis = .vertical
        uploadStackView.spacing = 16

        contentView.addSubview(titleTextView)
        titleTextView.layer.cornerRadius = 8
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(39)
        }
        
        contentView.addSubview(contentsTextView)
        contentsTextView.layer.cornerRadius = 24
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(240)
        }
        
        contentView.addSubview(contentsTextCountLabel)
        contentsTextCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentsTextView.snp.trailing).inset(16)
            make.bottom.equalTo(contentsTextView.snp.bottom).inset(8)
        }
        
        contentView.addSubview(uploadStackView)
        uploadStackView.snp.makeConstraints { make in
            make.top.equalTo(contentsTextView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(completeButton)
        completeButton.layer.cornerRadius = 42 / 2
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(uploadStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    //MARK: - Helpers
    
    func updateContentTextViewHeight() {
        let size = CGSize(width: contentsTextView.frame.size.width, height: .infinity)
        let estimatedSize = contentsTextView.sizeThatFits(size)
        
        contentsTextView.constraints.forEach { constraint in
            if estimatedSize.height <= 240 {
                
            } else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    func configureUI(feed: Feed) {
        // 컨텐츠 세팅
        titleTextView.text = feed.title
        contentsTextView.text = feed.content
        
        // 투표 세팅
//        uploadVoteView.
        
        // 이미지 세팅
        if let imageURL = feed.imageURL.first {
            DispatchQueue.global().async { [weak self] in
                let data = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    self?.uploadPhotoView.showImageView(show: true, image: image)
                }
            }
        } else {
            uploadPhotoView.showImageView(show: false)
        }
       
    }
}
