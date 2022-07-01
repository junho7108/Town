import UIKit
import RxDataSources

class DetailFeedTableView: UITableView {

    //MARK: - UI Properties
    
    let headerView = DetailFeedHeaderView()
    
    let footerView = NoCommentTableFooterView()
    
    let storeFeedButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "ic_scrap_off").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "ic_more_big").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    //MARK: - Lifecycle
    
    init() {
        super.init(frame: UIScreen.main.bounds, style: .grouped)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        headerView.invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
    
    //MARK: - Configurees
    
    private func configureTableView() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .clear
        refreshControl?.tintColor = .villageSky
        
        backgroundColor = .white
        separatorStyle = .none
        sectionFooterHeight = .leastNormalMagnitude
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        estimatedRowHeight = 80
        rowHeight = UITableView.automaticDimension
        
        estimatedSectionHeaderHeight = 80
        sectionHeaderHeight = UITableView.automaticDimension
        
        register(CommentCell.self,
                 forCellReuseIdentifier: CommentCell.identifier)
        register(CommentSectionHeaderView.self,
                 forHeaderFooterViewReuseIdentifier: CommentSectionHeaderView.identifier)
    
        tableHeaderView = headerView
        headerView.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
        
        tableFooterView = footerView
        footerView.frame = .init(x: 0, y: 0, width: frame.width, height: 100)
    }
    
    func configureUI(feed: Feed) {
        saved(saved: feed.isSaved ?? false)
        headerView.configureUI(feed: feed)
        headerView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    func configureUI(likeResponse: LikeResponse) {
        headerView.configureUI(likeResponse: likeResponse)
    }

    
    //MARK: - Helpers
    
    func scrollToComment() {
        setContentOffset(CGPoint(x: 0, y: headerView.likeButton.frame.origin.y), animated: true)
    }
    
    func saved(saved: Bool) {
        let image = saved ? #imageLiteral(resourceName: "ic_scrap_on").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "ic_scrap_off").withRenderingMode(.alwaysOriginal)
        storeFeedButton.setImage(image, for: .normal)
    }
}
