import Foundation
import RxSwift

class FeedUsecase {
    private let repositry: FeedRepository
    
    init(repository: FeedRepository) {
        self.repositry = repository
    }
    
    func fetchFeed(feedID: Int) -> Single<NetworkResult<Feed>> {
        return repositry.fetchFeed(feedID: feedID)
    }
    
    func fetchFeeds() -> Single<NetworkResult<FeedPage>> {
        return repositry.fetchFeeds()
    }
    
    func fetchMyFeeds() -> Single<NetworkResult<UserFeedPage>> {
        return repositry.fetchMyFeeds()
    }
    
    func fetchLikeFeeds() -> Single<NetworkResult<FeedPage>> {
        return repositry.fetchLikeFeeds()
    }
    
    func fetchHiddenFeeds() -> Single<NetworkResult<FeedPage>> {
        return repositry.fetchHiddenFeeds()
    }
    
    func fetchSaveFeeds() -> Single<NetworkResult<FeedPage>> {
        return repositry.fetchSaveFeeds()
    }
    
    func uploadFeed(request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>> {
        return repositry.uploadFeed(request: request, images: images)
    }
    
    func deleteFeed(feed: Feed) -> Single<NetworkResult<Bool>> {
        return repositry.deleteFeed(feed: feed)
    }
    
    func fetchFeedComments(feedID: Int) -> Single<NetworkResult<CommentPage>> {
        return repositry.fetchFeedComments(feedID: feedID)
    }
    
    func uploadFeedComment(feedID: Int, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>> {
        return repositry.uploadComments(feedId: feedID, request: request)
    }
    
    func fetchCommentReply(comment: Comment) -> Single<NetworkResult<Comment>> {
        return repositry.fetchCommentReply(comment: comment)
    }
    
    func uploadCommentReply(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>> {
        return repositry.uploadCommentReply(comment: comment, request: request)
    }
    
    func deleteComment(comment: Comment) -> Single<NetworkResult<Bool>> {
        return repositry.deleteComment(comment: comment)
    }
    
    func deleteCommentReply(comment: Comment) -> Single<NetworkResult<Bool>> {
        return repositry.deleteCommentReply(comment: comment)
    }
    
    func likeFeed(feed: Feed) -> Single<NetworkResult<LikeResponse>> {
        return repositry.likeFeed(feed: feed)
    }
    
    func likeComment(comment: Comment) -> Single<NetworkResult<LikeResponse>> {
        return repositry.likeComment(comment: comment)
    }
    
    func likeReply(reply: Comment) -> Single<NetworkResult<LikeResponse>> {
        return repositry.likeCommentReply(reply: reply)
    }
    
    func edityFeed(feed: Feed, request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>> {
        return repositry.editFeed(feed: feed, request: request, images: images)
    }
    
    func editComment(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>> {
        return repositry.editComment(comment: comment, request: request)
    }
    
    func editReply(reply: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>> {
        return repositry.editReply(reply: reply, request: request)
    }
    
    func fetchMoreFeeds(nextPageURL: String) -> Single<NetworkResult<FeedPage>> {
        return repositry.fetchMoreFeed(nextPageURL: nextPageURL)
    }
    
    func fetchMoreComments(nextPageURL: String) -> Single<NetworkResult<CommentPage>> {
        return repositry.fetchMoreComments(nextPageURL: nextPageURL)
    }
    
    func hideFeed(feed: Feed) -> Single<NetworkResult<HideResponse>> {
        return repositry.hideFeed(feed: feed)
    }
    
    func showFeed(feed: Feed) -> Single<NetworkResult<HideResponse>> {
        return repositry.showFeed(feed: feed)
    }
    
    func saveFeed(feed: Feed) -> Single<NetworkResult<SaveResponse>> {
        return repositry.saveFeed(feed: feed)
    }
}
