import Foundation

struct Vote: Codable {
    var voteId: Int?
    var title: String?
    var choice: [VoteContent]?
    
    enum CodingKeys: String, CodingKey {
        case voteId = "pk"
        case title = "title"
        case choice = "choice"
    }
}

struct VoteContent: Codable {
    let voteContentId: Int
    let voteContentTitle: String
    let votes: Int
    
    enum CodingKeys: String, CodingKey {
        case voteContentId = "pk"
        case voteContentTitle = "choice_text"
        case votes = "votes"
    }
}
