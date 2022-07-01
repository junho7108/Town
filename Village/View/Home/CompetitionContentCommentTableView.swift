import UIKit

class CompetitionContentCommentTableView: UITableView {
    
    //MARK: - UI Properties
    
    let headerView = CompetitionContentCommentHeaderView()
    
    let footerView = NoCommentTableFooterView()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        headerView.invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
    
    
    //MARK: - Configures
    
    private func configureTableView() {
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
    
    //MARK: - Helpers
    
    func scrollToComment() {
        setContentOffset(CGPoint(x: 0, y: headerView.likeButton.frame.origin.y), animated: true)
    }
}
