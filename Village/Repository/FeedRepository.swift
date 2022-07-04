import Foundation
import RxSwift
import Alamofire

protocol FeedRepository: AnyObject {
    func fetchFeeds() -> Single<NetworkResult<FeedPage>>
    func fetchMyFeeds() -> Single<NetworkResult<UserFeedPage>>
    func fetchLikeFeeds() -> Single<NetworkResult<FeedPage>>
    func fetchHiddenFeeds() -> Single<NetworkResult<FeedPage>>
    func fetchSaveFeeds() -> Single<NetworkResult<FeedPage>>
    
    func fetchFeed(feedID: Int) -> Single<NetworkResult<Feed>>
    func fetchMoreFeed(nextPageURL: String) -> Single<NetworkResult<FeedPage>>
    func uploadFeed(request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>>
    func deleteFeed(feed: Feed) -> Single<NetworkResult<Bool>>
    
    func fetchFeedComments(feedID: Int) -> Single<NetworkResult<CommentPage>>
    func fetchMoreComments(nextPageURL: String) -> Single<NetworkResult<CommentPage>>
    func uploadComments(feedId: Int, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>>
    func deleteComment(comment: Comment) -> Single<NetworkResult<Bool>>
    
    func fetchCommentReply(comment: Comment) -> Single<NetworkResult<Comment>>
    func uploadCommentReply(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>>
    func deleteCommentReply(comment: Comment) -> Single<NetworkResult<Bool>>
  
    func likeFeed(feed: Feed) -> Single<NetworkResult<LikeResponse>>
    func likeComment(comment: Comment) -> Single<NetworkResult<LikeResponse>>
    func likeCommentReply(reply: Comment) -> Single<NetworkResult<LikeResponse>>
    
    func editFeed(feed: Feed, request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>>
    func editComment(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>>
    func editReply(reply: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>>
    
    func hideFeed(feed: Feed) -> Single<NetworkResult<HideResponse>>
    func showFeed(feed: Feed) -> Single<NetworkResult<HideResponse>>
    
    func saveFeed(feed: Feed) -> Single<NetworkResult<SaveResponse>>
}

final class FeedRepositoryImpl: FeedRepository {
    private let service: NetworkService
    
    init(service: NetworkService = NetworkService()) {
        self.service = service
    }
    
    func fetchFeed(feedID: Int) -> Single<NetworkResult<Feed>> {
        return service.loadSingle(request: FeedRouter.fetchFeed(feedID: feedID))
    }
    
    func fetchMyFeeds() -> Single<NetworkResult<UserFeedPage>> {
        return service.loadSingle(request: FeedRouter.fetchMyFeeds)
    }
    
    func fetchLikeFeeds() -> Single<NetworkResult<FeedPage>> {
        return service.loadSingle(request: FeedRouter.fetchLikeFeeds)
    }
    
    func fetchHiddenFeeds() -> Single<NetworkResult<FeedPage>> {
        return service.loadSingle(request: FeedRouter.fetchHiddenFeeds)
    }
    
    func fetchSaveFeeds() -> Single<NetworkResult<FeedPage>> {
        return service.loadSingle(request: FeedRouter.fetchSaveFeeds)
    }
    
    func fetchFeeds() -> Single<NetworkResult<FeedPage>> {
        return service.loadSingle(request: FeedRouter.fetchFeeds)
    }
    
    func fetchMoreFeed(nextPageURL: String) -> Single<NetworkResult<FeedPage>> {
        return service.loadSingle(url: nextPageURL, httpMethod: .get)
    }
    
    func uploadFeed(request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>> {
        return Single.create { [unowned self] single in
            
            let request = service.session.upload(multipartFormData: { formData in
             
                formData.append(request.title.data(using: .utf8)!, withName: "title", mimeType: "application/json; charset=utf-8")
                formData.append(request.content.data(using: .utf8)!, withName: "content", mimeType: "application/json; charset=utf-8")
                
                request.taggedMBTIs.forEach { mbti in
                    formData.append(mbti.data(using: .utf8)!, withName: "mbti_tags", mimeType: "application/json; charset=utf-8")
                }
                
                request.category.forEach { category in
                    formData.append(category.data(using: .utf8)!, withName: "category", mimeType: "application/json; charset=utf-8")
                }
                
                if let voteTitle = request.voteTitle,
                   !voteTitle.isEmpty {
                    formData.append(voteTitle.data(using: .utf8)!, withName: "poll_question")
                }
                
                if let voteContents = request.voteContents,
                   !voteContents.isEmpty {
                    formData.append(voteContents.data(using: .utf8)!, withName: "poll_choices")
                }
                
                for image in images {
                    if let imageData = image.jpegData(compressionQuality: 1) {
                        formData.append(imageData, withName: "images", fileName: "\(imageData).jpg", mimeType: "image/jpeg")
                    }
                }
               
            }, with: FeedRouter.uploadFeed)
                .responseDecodable(of: Feed.self) { result in
                    Logger.debugPrintLog(result)
                    switch result.result {
                     
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func deleteFeed(feed: Feed) -> Single<NetworkResult<Bool>> {
        return service.delete(request: FeedRouter.deleteFeed(feed: feed))
    }
    
    
    func fetchFeedComments(feedID: Int) -> Single<NetworkResult<CommentPage>> {
        return service.loadSingle(request: FeedRouter.fetchFeedComments(feedID: feedID))
    }
    
    func fetchMoreComments(nextPageURL: String) -> Single<NetworkResult<CommentPage>> {
        return service.loadSingle(url: nextPageURL, httpMethod: .get)
    }
    
    func uploadComments(feedId: Int, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>> {
        return Single.create { [unowned self] single in
            let request = service.session.upload(multipartFormData: { formData in
             
                formData.append(request.content.data(using: .utf8)!, withName: "content")
            
                if let image = request.images,
                   let imageData = image.jpegData(compressionQuality: 1) {
                    formData.append(imageData, withName: "images", fileName: "\(imageData).jpg", mimeType: "image/jpeg")
                }
               
            }, with: FeedRouter.uploadFeedComment(feedID: feedId))
                .responseDecodable(of: UploadCommentResponse.self) { result in
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func fetchCommentReply(comment: Comment) -> Single<NetworkResult<Comment>> {
        return service.loadSingle(request: FeedRouter.fetchCommentReply(comment: comment))
    }
    
    func uploadCommentReply(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>> {
        return Single.create { [unowned self] single in
            let request = service.session.upload(multipartFormData: { formData in
             
                formData.append(request.content.data(using: .utf8)!, withName: "content")
            
                if let image = request.images,
                   let imageData = image.jpegData(compressionQuality: 1) {
                    formData.append(imageData, withName: "images", fileName: "\(imageData).jpg", mimeType: "image/jpeg")
                }
               
            }, with: FeedRouter.uploadCommentReply(comment: comment))
                .responseDecodable(of: UploadCommentResponse.self) { result in
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func deleteComment(comment: Comment) -> Single<NetworkResult<Bool>> {
        return service.delete(request: FeedRouter.deleteComment(comment: comment))
    }
    
    func deleteCommentReply(comment: Comment) -> Single<NetworkResult<Bool>> {
        return service.delete(request: FeedRouter.deleteCommentReply(comment: comment))
    }
    
    
    func likeFeed(feed: Feed) -> Single<NetworkResult<LikeResponse>> {
        return service.loadSingle(request: FeedRouter.likeFeed(feed: feed))
    }
    
    func likeComment(comment: Comment) -> Single<NetworkResult<LikeResponse>> {
        return service.loadSingle(request: FeedRouter.likeComment(comment: comment))
    }
    
    func likeCommentReply(reply: Comment) -> Single<NetworkResult<LikeResponse>> {
        return service.loadSingle(request: FeedRouter.likeCommentReply(reply: reply))
    }
    
    func editFeed(feed: Feed, request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>> {
        return Single.create { [unowned self] single in
            
            let request = service.session.upload(multipartFormData: { formData in
             
                formData.append(request.title.data(using: .utf8)!, withName: "title", mimeType: "application/json; charset=utf-8")
                formData.append(request.content.data(using: .utf8)!, withName: "content", mimeType: "application/json; charset=utf-8")
                
                request.taggedMBTIs.forEach { mbti in
                    formData.append(mbti.data(using: .utf8)!, withName: "mbti_tags", mimeType: "application/json; charset=utf-8")
                }
                
                request.category.forEach { category in
                    formData.append(category.data(using: .utf8)!, withName: "category", mimeType: "application/json; charset=utf-8")
                }
                
                if let voteTitle = request.voteTitle,
                   !voteTitle.isEmpty {
                    formData.append(voteTitle.data(using: .utf8)!, withName: "poll_question")
                }
                
                if let voteContents = request.voteContents,
                   !voteContents.isEmpty {
                    formData.append(voteContents.data(using: .utf8)!, withName: "poll_choices")
                }
                
                for image in images {
                    if let imageData = image.jpegData(compressionQuality: 1) {
                        formData.append(imageData, withName: "images", fileName: "\(imageData).jpg", mimeType: "image/jpeg")
                    }
                }
               
            }, with: FeedRouter.editFeed(feed: feed))
                .responseDecodable(of: Feed.self) { result in
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func editComment(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>> {
        return Single.create { [unowned self] single in
            let request = service.session.upload(multipartFormData: { formData in
             
                formData.append(request.content.data(using: .utf8)!, withName: "content")
            
                if let image = request.images,
                   let imageData = image.jpegData(compressionQuality: 1) {
                    formData.append(imageData, withName: "images", fileName: "\(imageData).jpg", mimeType: "image/jpeg")
                }
               
            }, with: FeedRouter.editComemnt(comment: comment))
                .responseDecodable(of: Comment.self) { result in
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func editReply(reply: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>> {
        return Single.create { [unowned self] single in
            let request = service.session.upload(multipartFormData: { formData in
             
                formData.append(request.content.data(using: .utf8)!, withName: "content")
            
                if let image = request.images,
                   let imageData = image.jpegData(compressionQuality: 1) {
                    formData.append(imageData, withName: "images", fileName: "\(imageData).jpg", mimeType: "image/jpeg")
                }
               
            }, with: FeedRouter.editReply(reply: reply))
                .responseDecodable(of: Comment.self) { result in
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func hideFeed(feed: Feed) -> Single<NetworkResult<HideResponse>> {
        return service.loadSingle(request: FeedRouter.hideFeed(feed: feed))
    }
    
    func showFeed(feed: Feed) -> Single<NetworkResult<HideResponse>> {
        return service.loadSingle(request: FeedRouter.showFeed(feed: feed))
    }
    
    func saveFeed(feed: Feed) -> Single<NetworkResult<SaveResponse>> {
        return service.loadSingle(request: FeedRouter.saveFeed(feed: feed))
    }
}
