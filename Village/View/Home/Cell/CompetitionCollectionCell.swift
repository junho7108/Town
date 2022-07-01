import UIKit
import RxSwift

class CompetitionCollectionCell: UICollectionViewCell {
    
    static let identifier = "CompetitionCollectionCell"
    
    var disposeBag = DisposeBag()
    
    //MARK: - UI Properties
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let contentBackgroundView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .suitFont(size: 13, weight: .medium)
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
    private let mostParticipativeVillageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let votesCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("좋아요 68", for: .normal)
        button.setTitleColor(UIColor.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글 70", for: .normal)
        button.setTitleColor(UIColor.grey300, for: .normal)
        button.titleLabel?.font = .suitFont(size: 13, weight: .regular)
        return button
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureTableView()
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
        contentView.backgroundColor = .white
      
       
        contentBackgroundView.backgroundColor = .grey100
        contentBackgroundView.layer.cornerRadius = 24
        
        let infoStackView = UIStackView(arrangedSubviews: [deadlineLabel, mostParticipativeVillageLabel, votesCountLabel])
        infoStackView.spacing = 8
        infoStackView.distribution = .fillProportionally
        
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(32)
        }
        
        contentBackgroundView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.greaterThanOrEqualToSuperview().inset(32)
        }
        
        contentBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(53)
        }
        
        contentBackgroundView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        contentBackgroundView.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton.snp.centerY)
            make.leading.equalTo(likeButton.snp.trailing).offset(16)
        }
    }
    
    private func configureTableView() {
        tableView.isScrollEnabled = false
        
        tableView.register(VoteCell.self, forCellReuseIdentifier: VoteCell.identifier)
        tableView.rowHeight = VoteCell.rowHeight
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNonzeroMagnitude))
        tableView.sectionHeaderHeight = .leastNonzeroMagnitude
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNonzeroMagnitude))
        tableView.sectionFooterHeight = .leastNonzeroMagnitude
    }
    
    func configureUI(vote: Vote, colorType: BackgroundColorType) {
        titleLabel.text = "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?"
        deadlineLabel.text = "⏰ ".appending("4월15일").appending("마감")
        votesCountLabel.text = "🗳 참여자 ".appending("999")
        mostParticipativeVillageLabel.attributedText = mostParticipativeVillageText(mbti: .init(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J))
        
        switch colorType {
        case .white:
            contentView.backgroundColor = .grey100
            contentBackgroundView.backgroundColor = .white
        case .grey:
            contentView.backgroundColor = .white
            contentBackgroundView.backgroundColor = .grey100
        }
    }
    
    private func mostParticipativeVillageText(mbti: MBTIType) -> NSAttributedString {
        let text = NSMutableAttributedString(string: "🏠 참여도 높은 마을은 ", attributes: [.font: UIFont.suitFont(size: 10, weight: .bold),
                                                                                        .foregroundColor: UIColor.grey300])
        text.append(NSAttributedString(string: "\( mbti.title)", attributes: [.font: UIFont.suitFont(size: 10, weight: .bold),
                                                                              .foregroundColor: UIColor.villageSky]))
        return text
    }
}
