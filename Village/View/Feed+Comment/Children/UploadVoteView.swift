import UIKit

final class UploadVoteView: UploadFeedContentView {
    
    //MARK: - UI Properties
    
    let createVoteView = CreateVoteView(frame: .zero)
    
    private var voteContents: [String] = ["", ""]
 
    //MARK: - Configures
    
    override func configureUI() {
        super.configureUI()
        createVoteView.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [createVoteView, divider])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        createVoteView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(192)
        }
   
        divider.snp.remakeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Helpers
    
    func showVoteView(show: Bool) {
        createVoteView.titleTextView.text = nil
        createVoteView.isHidden = !show
        isActivated = show
        endEditing(true)
    }
    
    func updateVoteContentsHeight() {
        let titlesize = CGSize(width: createVoteView.titleTextView.frame.size.width, height: .infinity)
        let titleEstimatedSize = createVoteView.titleTextView.sizeThatFits(titlesize)
        
        for constraint in createVoteView.titleTextView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = titleEstimatedSize.height
                setNeedsLayout()
                break
            }
        }
        
        let contentSize = CGSize(width: createVoteView.tableView.frame.size.width, height: .infinity)
        let contentEstimatedSize = createVoteView.tableView.sizeThatFits(contentSize)
        for constraint in createVoteView.constraints {
            if constraint.firstAttribute == .height {
                let height = titleEstimatedSize.height + contentEstimatedSize.height + 10 + 24
                constraint.constant = height
                setNeedsLayout()
                break
            }
        }
    }
}
