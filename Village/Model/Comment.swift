import Foundation
import Differentiator

struct CommentPage: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Comment]
}

struct Comment: Codable {
    let commentID: Int
    let created: String
    let modified: String
    let author: User
    let content: String
    let image: URL?
    var isLiked: Bool = false
    var likes: Int = 0
    var reply: [Comment]?
    
    
    enum CodingKeys: String, CodingKey {
        case commentID = "pk"
        case created = "created"
        case modified = "modified"
        case author = "author"
        case content = "content"
        case image = "image"
        case isLiked = "is_liked"
        case likes = "number_of_likes"
        case reply = "reply"
    }
}

extension Comment: IdentifiableType, Equatable {
    var identity: Int {
        return commentID
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.commentID == rhs.commentID
    }
}
