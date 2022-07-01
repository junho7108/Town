import Foundation

struct Feed: Codable {
    let feedId: Int
    var category: [FeedCategory]
    var taggedMBTIs: [MBTICase]
    let author: User
    var title: String
    var content: String
    let createdDate: String
    var modifiedDate: String
    var imageURL: [URL]
    var vote: Vote?
    var likes: Int?
    var comments: Int?
    var hits: Int?
    var isSaved: Bool?
    var isLiked: Bool?
    var isBlocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case feedId = "pk"
        case category = "category"
        case taggedMBTIs = "mbti_tags"
        case author = "author"
        case title = "title"
        case content = "content"
        case createdDate = "created"
        case modifiedDate = "modified"
        case imageURL = "image_url"
        case vote = "poll"
        case likes = "number_of_likes"
        case comments = "number_of_comments_and_reply"
        case hits = "hits"
        case isSaved = "is_saved"
        case isLiked = "is_liked"
        case isBlocked = "is_blocked"
    }
}
