import RxDataSources

//MARK: - CommentSection

struct CommentSection {
    var headerComment: Comment
    var items: [Item]
}

extension CommentSection: AnimatableSectionModelType {
    typealias Item = Comment
    
    var identity: Int {
        return headerComment.commentID
    }
    
    init(original: CommentSection, items: [Comment]) {
        self = original
        self.items = items
    }
}

//MARK: - VillageSection
 
struct VillageSection {
    var items: [Item]
}

extension VillageSection: AnimatableSectionModelType {
    typealias Item = MBTIType
    
    var identity: String {
        return "villageHeader"
    }
    
    init(original: VillageSection, items: [MBTIType]) {
        self = original
        self.items = items
    }
}
