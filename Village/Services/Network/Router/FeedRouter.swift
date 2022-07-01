import Alamofire
import Foundation
import UIKit

struct UploadFeedRequest: Encodable {
    var category: [String]
    var taggedMBTIs: [String]
    var title: String
    var content: String
    var voteTitle: String?
    var voteContents: String?
  
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case taggedMBTIs = "mbti_tags"
        case title = "title"
        case content = "content"
        case voteTitle = "poll_question"
        case voteContents = "poll_choices"
    }
}

struct UploadCommentRequest {
    var content: String
    var images: UIImage?
}

struct UploadCommentResponse: Decodable {
    var content: String
    var image: URL?
}

struct LikeResponse: Decodable {
    struct Likes: Decodable {
        var likes: Int
        var isLiked: Bool
        
        enum CodingKeys: String, CodingKey {
            case likes = "number_of_likes"
            case isLiked = "is_liked"
        }
    }
    
    var likes: Likes
}

struct HideResponse: Decodable {
    let blocked: Bool
}

struct SaveResponse: Decodable {
    let saved: Bool
}

enum FeedRouter {
    case fetchFeeds
    case fetchMyFeeds
    case fetchLikeFeeds
    case fetchHiddenFeeds
    case fetchSaveFeeds
    case fetchMoreFeeds(nextURL: String)
    case uploadFeed
    case editFeed(feed: Feed)
    case deleteFeed(feed: Feed)
    case fetchFeed(feedID: Int)
    
    case fetchFeedComments(feedID: Int)
    case uploadFeedComment(feedID: Int)
    case deleteComment(comment: Comment)
    case editComemnt(comment: Comment)
    case editReply(reply: Comment)
    
    case fetchCommentReply(comment: Comment)
    case uploadCommentReply(comment: Comment)
    case deleteCommentReply(comment: Comment)
    
    case likeFeed(feed: Feed)
    case likeComment(comment: Comment)
    case likeCommentReply(reply: Comment)
    
    case hideFeed(feed: Feed)
    case showFeed(feed: Feed)
    
    case saveFeed(feed: Feed)
 
}

extension FeedRouter: APIRouter {
    var baseURL: String {
        return APIKey.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .fetchFeed(let pk): return "/posts/\(pk)/"
        case .fetchMyFeeds: return "/accounts/users/me/posts/"
        case .fetchLikeFeeds: return "/accounts/users/me/like/"
        case .fetchHiddenFeeds: return "/accounts/users/me/block/"
        case .fetchSaveFeeds: return "/accounts/users/me/save/"
        case .fetchFeeds, .uploadFeed: return "/posts/"
        case .editFeed(let feed): return "/posts/\(feed.feedId)/"
            
        case .fetchFeedComments(let pk): return "/posts/\(pk)/comments/list/"
        case .uploadFeedComment(let pk): return "/posts/\(pk)/comments/"
        case .deleteFeed(let feed): return "/posts/\(feed.feedId)/"
        case .deleteComment(let comment): return "/posts/comments/\(comment.commentID)/"
        case .editComemnt(let comment): return "/posts/comments/\(comment.commentID)/"
        case .editReply(let reply): return "/posts/comments/reply/\(reply.commentID)/"
            
        case .fetchCommentReply(let comment): return "/posts/comments/\(comment.commentID)/reply/list/"
        case .uploadCommentReply(let comment): return "/posts/comments/\(comment.commentID)/reply/"
        case .deleteCommentReply(let comment): return "/posts/comments/reply/\(comment.commentID)/"
            
        case .likeFeed(let feed): return "/posts/\(feed.feedId)/like/"
        case .likeComment(let comment): return "/posts/comments/\(comment.commentID)/like/"
        case .likeCommentReply(let reply): return "/posts/reply/\(reply.commentID)/like/"
        case .fetchMoreFeeds(nextURL: let nextURL): return nextURL
            
        case .hideFeed(let feed), .showFeed(let feed): return "/posts/\(feed.feedId)/block/"
            
        case .saveFeed(let feed): return "/posts/\(feed.feedId)/save/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchFeeds, .fetchMyFeeds, .fetchLikeFeeds, .fetchHiddenFeeds, .fetchSaveFeeds: return .get
        case .fetchFeed: return .get
        case .fetchMoreFeeds: return .get
        case .fetchFeedComments, .fetchCommentReply: return .get
        case .uploadFeed, .uploadFeedComment, .uploadCommentReply: return .post
        case .deleteFeed, .deleteComment, .deleteCommentReply: return .delete
        case .likeFeed, .likeComment, .likeCommentReply: return .post
            
        case .editFeed, .editComemnt, .editReply: return .put
        case .hideFeed, .showFeed: return .post
        case .saveFeed: return .post
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .uploadFeed, .uploadFeedComment, .uploadCommentReply, .editFeed, .editReply: return ["Content-Type": "multipart/form-data"]
        default: return nil
        }
    }
    
    var body: Data? {
        switch self {
        default: return nil
        }
    }
    
    var queries: [String : String]? {
        switch self {
        default: return nil
        }
    }
}
