import UIKit

class FeedVoteView: BaseView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [contentView1,
                                                                       contentView2,
                                                                       contentView3,
                                                                       contentView4,
                                                                       contentView5])
    
    private(set) lazy var contentArray: [VoteContentView] = [contentView1,
                                                             contentView2,
                                                             contentView3,
                                                             contentView4,
                                                             contentView5]
    
    let contentView1 = VoteContentView()
    let contentView2 = VoteContentView()
    let contentView3 = VoteContentView()
    let contentView4 = VoteContentView()
    let contentView5 = VoteContentView()
    
    override func configureUI() {
        backgroundColor = .grey100
        layer.cornerRadius = 24
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(14)
        }
        
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(24)
        }
        
        contentStackView.arrangedSubviews.forEach { $0.isHidden = true }
    }
    
    func configureUI(vote: Vote, numberOfTitleLines: Int, numberOfContentLines: Int) {
        guard let choice = vote.choice else { return }
        
        titleLabel.text = vote.title
        titleLabel.numberOfLines = numberOfTitleLines
        
        for (index, choice) in choice.enumerated() {
            guard let contentView = contentStackView.arrangedSubviews[index] as? VoteContentView else { return }
            
            contentView.isHidden = false
            contentView.configureUI(voteContent: choice, numberOfContentLines: numberOfContentLines)
        }
    }
    
    func didSelect(contentView: VoteContentView) {
        for (index, elem) in contentArray.enumerated() {
            if let voteContent = elem.voteContent {
                if voteContent.voteContentId == contentView.voteContent?.voteContentId {
                    guard elem.didSelect == false else { return deselect() }
                    elem.didSelect(selected: true)
                } else {
                    elem.didSelect(selected: false)
                }
            }
        }
    }
    
    func deselect() {
        contentArray.forEach { elem in
            elem.deselect()
        }
    }
}

class VoteContentView: BaseView {
    
    private(set) var voteContent: VoteContent?
    
    //MARK: - UI Properties
    
    var title: String? {
        return titleLabel.text
    }
    
    private(set) var didSelect: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    //MARK: - Lifecycles
   
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(11)
        }
    }
    
    func configureUI(voteContent: VoteContent, numberOfContentLines: Int) {
        self.voteContent = voteContent
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        titleLabel.text = voteContent.voteContentTitle
        titleLabel.numberOfLines = numberOfContentLines
        
        deselect()
    }
    
    func didSelect(selected: Bool) {
        didSelect = selected
        
        if selected {
            titleLabel.textColor = .black
            layer.borderColor = UIColor.villageSky.cgColor
        } else {
            titleLabel.textColor = .grey300
            layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func deselect() {
        didSelect = false
        titleLabel.textColor = .black
        layer.borderColor = UIColor.white.cgColor
    }
}
