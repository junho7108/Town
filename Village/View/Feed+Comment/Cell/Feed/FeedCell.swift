import UIKit
import RxSwift
import Kingfisher

class FeedCell: UITableViewCell {
    
    static let identifier = "feedCellIdentifier"
    
    private(set) var disposeBag = DisposeBag()
    
    private(set) var feed: Feed!
    
    private(set) var isLiked: Bool = false
    
    private(set) var likes: Int = 0
    
    //MARK: - UI Properteis

    private(set) lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.text = "1시간 전"
        label.textColor = .grey300
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_more_small").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.lineBreakStrategy = .pushOut
        label.font = .suitFont(size: 13, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
   
    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey100
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let feedVoteView = FeedVoteView()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("좋아요 10", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
  
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글 5", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
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
        
        contentView.backgroundColor = .grey100

        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 24

        let underlindeView = UIView()
        underlindeView.backgroundColor = .grey100
    
        let contentsStackView = UIStackView(arrangedSubviews: [contentImageView, feedVoteView])
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 8

        contentImageView.snp.makeConstraints { make in
            make.height.equalTo(187).priority(999)
        }
        
        let actionButtonStackView = UIStackView(arrangedSubviews: [likeButton, commentButton])
        actionButtonStackView.axis = .horizontal
        actionButtonStackView.spacing = 16
        
        contentView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }

        backgroundView.addSubview(userProfileImageView)
        userProfileImageView.layer.cornerRadius = 32 / 2
        userProfileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }

        let userNameTimeStampStackView = UIStackView(arrangedSubviews: [nicknameLabel, timestampLabel])
        userNameTimeStampStackView.axis = .vertical
        userNameTimeStampStackView.spacing = 4
        userNameTimeStampStackView.alignment = .leading

        backgroundView.addSubview(userNameTimeStampStackView)
        userNameTimeStampStackView.snp.makeConstraints { make in
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(userProfileImageView.snp.centerY)
        }
        
        backgroundView.addSubview(optionButton)
        optionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(userNameTimeStampStackView.snp.centerY)
            make.height.equalTo(24)
        }
        
        backgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTimeStampStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        backgroundView.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        backgroundView.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        backgroundView.addSubview(actionButtonStackView)
        actionButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentsStackView.snp.bottom).offset(8)
            make.leading.bottom.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
    }

    func configureUI(feed: Feed) {
        self.feed = feed
        titleLabel.text = feed.title
        contentsLabel.text = feed.content
      
        if let date = feed.modifiedDate.toDate() {
            let timeInterval = Utils.timeInterval(startDate: date)
            timestampLabel.text = Utils.timeStamp(timeInterval: timeInterval)
        }
        
        nicknameLabel.attributedText = Utils.mbtiNickname(user: feed.author,
                                                          font: .suitFont(size: 13, weight: .regular),
                                                          textColor: .black)
        
        userProfileImageView.image = feed.author.mbti.profileImage
        userProfileImageView.backgroundColor = feed.author.mbti.mbtiColor

        isLiked = feed.isLiked ?? false
        likes = feed.likes ?? 0
        
        let likeButtonColor: UIColor = isLiked ? UIColor.villageSky : UIColor.grey300
        let likeString = likes == 0 ? "좋아요" : "좋아요 \(likes)"
        likeButton.setTitleColor(likeButtonColor, for: .normal)
        likeButton.setTitle(likeString, for: .normal)
        
        let comments = feed.comments ?? 0
        commentButton.setTitle("댓글 \(comments)", for: .normal)
        
        contentImageView.isHidden = feed.imageURL.first == nil
        contentImageView.kf.indicatorType = .activity
        contentImageView.kf.setImage(with: feed.imageURL.first)
        
        feedVoteView.isHidden = feed.vote?.voteId == nil
    }
    
    func like(feed: Feed) {
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
    
    func hide() {
        titleLabel.text = "사용자가 숨긴 게시물입니다."
        contentsLabel.text = nil
        likeButton.setTitle(nil, for: .normal)
        commentButton.setTitle(nil, for: .normal)
            
    }
}
