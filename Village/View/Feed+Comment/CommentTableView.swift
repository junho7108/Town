import UIKit

class CommentTableView: UITableView {
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configurees
    
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
    }
}


