import UIKit

class DetailFeedHeaderView: UIView {
    
    private(set) var tagList: [String] = []
    
    override var intrinsicContentSize: CGSize {
        let height = systemLayoutSizeFitting(CGSize(width: frame.width, height: .greatestFiniteMagnitude),
                                                                         withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        
        return CGSize(width: frame.width, height: height)
    }
    
    //MARK: - UI Properties
    
    private var contentStackView = UIStackView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey100
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
    private let hitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byCharWrapping
        label.font = .suitFont(size: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .grey200
        return imageView
    }()
    
    let feedVoteView = FeedVoteView()

    var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    
    private let commentUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey300
        return view
    }()
    
    private(set) lazy var tagCollectionView = DynamicHeightCollectionView(frame: .zero,
                                                                          collectionViewLayout: tagLayout)
    private let tagLayout: CollectionViewLeftAlignFlowLayout = {
        let layOut = CollectionViewLeftAlignFlowLayout()
        layOut.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return layOut
    }()
    
    //MARK: - Lifecycles
    
    init() {
        super.init(frame: .zero)
        configureUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func invalidateIntrinsicContentSize() {
        self.frame.size = intrinsicContentSize
        super.invalidateIntrinsicContentSize()
    }
 
    //MARK: - Configures
    
    func configureUI() {
        backgroundColor = .white

        let usernameTimeStackView = UIStackView(arrangedSubviews: [usernameLabel, timestampLabel])
        usernameTimeStackView.axis = .vertical
        usernameTimeStackView.alignment = .leading
        usernameTimeStackView.spacing = 4
        
        contentStackView = UIStackView(arrangedSubviews: [contentLabel, contentImageView, feedVoteView])
        contentStackView.axis = .vertical
        contentStackView.spacing = 16

        contentImageView.snp.makeConstraints { $0.height.equalTo(187) }
    
        let profileDivider = UIView()
        profileDivider.backgroundColor = .grey100
        
        let commentDivider = UIView()
        commentDivider.backgroundColor = .grey100
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(userProfileImageView)
        userProfileImageView.layer.cornerRadius = 32 / 2
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }

        addSubview(usernameTimeStackView)
        usernameTimeStackView.snp.makeConstraints { make in
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(userProfileImageView)
        }
        
        addSubview(hitsLabel)
        hitsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(usernameTimeStackView.snp.bottom)
        }

      addSubview(profileDivider)
        profileDivider.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }

        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(profileDivider.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview()
        }

        addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(24)
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
    
    func configureUI(feed: Feed) {
        titleLabel.text = feed.title
        contentLabel.text = feed.content
        hitsLabel.text = "조회수 \(feed.hits ?? 0)"
       
        let likes = feed.likes ?? 0
        let liked = feed.isLiked ?? false
        let likeButtonColor: UIColor = liked ? UIColor.villageSky : UIColor.grey300
        likeButton.setTitleColor(likeButtonColor, for: .normal)
        likeButton.setTitle(likes == 0 ? "좋아요" : "좋아요 \(likes)", for: .normal)
        
        let comments = feed.comments ?? 0
        commentButton.setTitle(comments == 0 ? "댓글쓰기" : "댓글 \(comments)", for: .normal)
        
        if let date = feed.modifiedDate.toDate() {
            let timeInterval = Utils.timeInterval(startDate: date)
            timestampLabel.text = Utils.timeStamp(timeInterval: timeInterval)
        }
      
        userProfileImageView.image = feed.author.mbti.profileImage
        userProfileImageView.backgroundColor = feed.author.mbti.mbtiColor
        usernameLabel.text = "\(feed.author.nickname) \(feed.author.mbti.nickname)"
        
        contentImageView.isHidden = feed.imageURL.first == nil
        contentImageView.kf.indicatorType = .activity
        contentImageView.kf.setImage(with: feed.imageURL.first)
        
        if let _ = feed.vote?.voteId,
           let vote = feed.vote {
            feedVoteView.isHidden = false
            feedVoteView.configureUI(vote: vote, numberOfTitleLines: 0, numberOfContentLines: 0)
        } else {
            feedVoteView.isHidden = true
        }
        
        tagList = []
        
        feed.category.forEach { tagList.append($0.title)}
        feed.taggedMBTIs.forEach { tagList.append($0.emojiTitle())}
        
        tagCollectionView.reloadData()
    }

    func configureUI(likeResponse: LikeResponse) {
        let likes = likeResponse.likes.likes
        let isLiked = likeResponse.likes.isLiked
        likeButton.setTitle(likes == 0 ? "좋아요" : "좋아요 \(likes)", for: .normal)
        likeButton.setTitleColor(isLiked ? .villageSky : .grey300, for: .normal)
    }
    
    private func configureCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.showsVerticalScrollIndicator = false
        tagCollectionView.showsHorizontalScrollIndicator = false
        tagCollectionView.register(BaseTagCell.self,
                                       forCellWithReuseIdentifier: BaseTagCell.cellIdentifier)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailFeedHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseTagCell.cellIdentifier,
                                                      for: indexPath) as! BaseTagCell
        cell.configureUI(text: tagList[indexPath.row], isSelected: true)
        return cell
    }
}

extension DetailFeedHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BaseTagCell.fittingsize(text: tagList[indexPath.row])
    }
}
