import UIKit

class CompetitionContentCommentHeaderView: BaseView {
    
    override var intrinsicContentSize: CGSize {
        let height = systemLayoutSizeFitting(CGSize(width: frame.width, height: .greatestFiniteMagnitude),
                                                                         withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        
        return CGSize(width: frame.width, height: height)
    }
    
    //MARK: - UI Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        iv.image = #imageLiteral(resourceName: "img_leader").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        label.text = "마을 이장님"
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 10, weight: .regular)
        label.textColor = .grey300
        label.text = "1시간 전"
        return label
    }()
    
    let viewCountsLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 10, weight: .regular)
        label.textColor = .grey300
        label.text = "조회수 366"
        return label
    }()
    
    let competitionContentView = CompetitionContentView()
    
    var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("좋아요", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글쓰기", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    //MARK: - Lifecycles
    
    override func invalidateIntrinsicContentSize() {
        self.frame.size = intrinsicContentSize
        super.invalidateIntrinsicContentSize()
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        
        let userInfoStack = UIStackView(arrangedSubviews: [nicknameLabel, timestampLabel])
        userInfoStack.axis = .vertical
        userInfoStack.alignment = .leading
        
        let divider = UIView()
        divider.backgroundColor = .grey100
        
        let commentDivider = UIView()
        commentDivider.backgroundColor = .grey100
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        addSubview(userInfoStack)
        userInfoStack.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        addSubview(viewCountsLabel)
        viewCountsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(userInfoStack.snp.bottom)
            make.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        addSubview(competitionContentView)
        competitionContentView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(218)
        }
        
        addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(competitionContentView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton.snp.centerY)
            make.leading.equalTo(likeButton.snp.trailing).offset(16)
        }
    
        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }

        addSubview(commentDivider)
        commentDivider.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
