import UIKit
import RxSwift

class CommentCell: UITableViewCell {
    
    static let identifier = "commentCellIdentifier"
    
    private(set) var disposeBag = DisposeBag()
    
    private(set) var comment: Comment!
    
    private var likes: Int = 0
    
    private var isLiked: Bool = false
 
    //MARK: - UI Properties
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .medium)
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 10, weight: .regular)
        label.textColor = .grey300
        label.text = "1시간 전"
        return label
    }()
    
    let contentImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let commentUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("좋아요", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 10, weight: .regular)
        return button
    }()
    
    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .right
        button.setImage(#imageLiteral(resourceName: "ic_more_small").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        let contentStackView = UIStackView(arrangedSubviews: [contentImageView, commentLabel, likeButton])
        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        contentStackView.spacing = 8
        
        contentImageView.snp.makeConstraints { make in
            make.width.equalTo(137)
            make.height.equalTo(80)
        }
       
        contentView.addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 24 / 2
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(51)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(optionButton)
        optionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentView.addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(usernameLabel.snp.trailing).offset(4)
        }
        
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.leading.equalTo(usernameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureUI(comment: Comment) {
        self.comment = comment
        self.likes = comment.likes
        
        profileImageView.backgroundColor = comment.author.mbti.mbtiColor
        profileImageView.image = comment.author.mbti.profileImage
       
        usernameLabel.text = "\(comment.author.nickname) \(comment.author.mbti.nickname)"
        commentLabel.text = comment.content
     
        if let date = comment.modified.toDate() {
            let timeInterval = Utils.timeInterval(startDate: date)
            timestampLabel.text = Utils.timeStamp(timeInterval: timeInterval)
        }
        
        isLiked = comment.isLiked
        likes = comment.likes
        
        let likeButtonColor: UIColor = isLiked ? UIColor.villageSky : UIColor.grey300
        likeButton.setTitleColor(likeButtonColor, for: .normal)
        
        let likeString = likes == 0 ? "좋아요" : "좋아요 \(likes)"
        likeButton.setTitle(likeString, for: .normal)
        
        contentImageView.isHidden = comment.image == nil
        contentImageView.kf.indicatorType = .activity
        contentImageView.kf.setImage(with: comment.image)
    }
    
    func like() {
        self.isLiked.toggle()
        
        let likeButtonColor: UIColor = isLiked ? UIColor.villageSky : UIColor.grey300
        likeButton.setTitleColor(likeButtonColor, for: .normal)
        
        if isLiked {
            self.likes += 1
        } else {
            self.likes -= 1
        }
        
        let likeString = likes == 0 ? "좋아요" : "좋아요 \(likes)"
        likeButton.setTitle(likeString, for: .normal)
    }
}
