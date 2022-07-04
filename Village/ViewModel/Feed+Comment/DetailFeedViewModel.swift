import RxSwift
import RxRelay
import Alamofire

final class DetailFeedViewModel: ViewModelType {
    
    struct Input {
        let fetching: Observable<Void>
        let tapLikeFeed: Observable<Void>
        let tapLikeComment: Observable<Comment>
        let tapUploadComment: Observable<String>
        let tapSaveFeed: Observable<Feed>
        let tapFeedOption: Observable<Void>
        let tapEditFeed: Observable<Feed>
        let tapDeleteFeed: Observable<Void>
        let tapDeclaration: Observable<Void>
        let tapHideFeed: Observable<Feed>
        
        let tapShowGallery: Observable<Void>
        let tapHideGallery: Observable<Void>
        let didSelectImage: Observable<[UIImage]>
        let tapRemoveImage: Observable<Void>
        let tapCommentOption: Observable<Comment>
        let tapDeleteComment: Observable<Comment>
        let tapEditComment: Observable<Comment>
        let tapCancelEditComment: Observable<Void>
        
        let fetchMoreComments: Observable<Void>
        let refreshControlAction: Observable<Void>
    }
    
    struct Output {
        let feed: Observable<Feed>
    
        let comments: Observable<[CommentSection]>
        let commentsCount: Observable<Int>
        let uploadComment: Observable<Void>
        let showSavedFeed: Observable<Bool>
        let showFeedOptionsPage: Observable<[ActionSheetOption]>
        
        let showEditFeedPage: Observable<Feed>
        let showDeleteFeedPage: Observable<Void>
        let showDeclarationPage: Observable<Void>
        
        let showGallery: Observable<Void>
        let hideGallery: Observable<Void>
        let selectedImages: Observable<[UIImage]>
        let removeImage: Observable<Void>
        
        let showCommentOptionPage: Observable<(Comment, [ActionSheetOption])>
        let showDeleteCommentMessage: Observable<Void>
        let showHideFeedPage: Observable<Void>
        
        let showLikeFeed: Observable<LikeResponse>
        let showLikeComment: Observable<LikeResponse>
        
        let refreshControlCompleted: Observable<Void>
        let isLoadingSpinnerAvailable: Observable<Bool>
    }
    
    struct Dependencies {
        let feed: Feed
        let feedUsecase: FeedUsecase
        let userUsercase: UserUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
 
    var tapCommentOption = PublishRelay<Comment>()
    
    var tapLikeComment = PublishRelay<Comment>()
    
    var isPaginationRequestStillResume = false
    
    var isRefreshRequstStillResume = false
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        //MARK: Properties
        
        var nextPageURL: String?
        
      
        //MARK: Output Properties
        
        let editCommentRelay: BehaviorRelay<Comment?> = BehaviorRelay<Comment?>(value: nil)
        let isCommentEditing: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        
        let fetching: PublishRelay<Void> = PublishRelay<Void>()
        let feed: PublishRelay<Feed> = PublishRelay<Feed>()
      
        let comments = BehaviorRelay<[CommentSection]>(value: [])
        let commentsCount = BehaviorRelay<Int>(value: 0)
        
        let uploadComment = PublishRelay<Void>()
        let showOptions = PublishRelay<[ActionSheetOption]>()
        let showEditFeedPage = input.tapEditFeed.asObservable()
        let showDeleteFeedPage = PublishRelay<Void>()
        let showDeclarationPage = input.tapDeclaration.asObservable()
        let showHideFeedPage = PublishRelay<Void>()
        
        let showGallery: Observable<Void> = input.tapShowGallery
        let hideGallery: Observable<Void> = input.tapHideGallery
        let selectedImages = BehaviorRelay<[UIImage]>(value: [])
        let removeImgae: Observable<Void> = input.tapRemoveImage
        
        let showCommentOptionPage = PublishRelay<(Comment, [ActionSheetOption])>()
       
        let showDeleteCommentMessage = PublishRelay<Void>()
        let showLikeFeed = PublishRelay<LikeResponse>()
        let showLikeComment = PublishRelay<LikeResponse>()
        
        let refreshControlCompleted = PublishRelay<Void>()
        let isLoadingSpinnerAvailable = PublishRelay<Bool>()
        
        let showSavedFeed = PublishRelay<Bool>()
        
        //MARK: INPUT
        
        fetchUser().asObservable()
            .share()
            .bind { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    input.tapFeedOption
                        .bind { _ in
                            if self.dependencies.feed.author.id == user.id {
                                showOptions.accept([.edit, .delete])
                            } else {
                                let hiddenType: ActionSheetOption = self.dependencies.feed.isBlocked ?? false ? .cancelHide : .hide
                                showOptions.accept([.declaration, hiddenType])
                            }
                        }
                        .disposed(by: self.disposeBag)
                    
                    self.tapCommentOption
                        .bind { comment in
                            if comment.author.id == user.id {
                                showCommentOptionPage.accept((comment, [.edit, .delete]))
                            } else {
                                showCommentOptionPage.accept((comment, [.declaration]))
                            }
                        }
                        .disposed(by: self.disposeBag)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("detailFeedVM 유저 조회 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.fetching
            .bind(to: fetching)
            .disposed(by: disposeBag)
        
        fetching
            .flatMap { [unowned self] _ in fetchFeed(feedId: dependencies.feed.feedId)}
            .bind { [unowned self] result in
                switch result {
                case .success(let feedData):
                    feed.accept(feedData)
                    
                    fetchFeedComments(feedID: dependencies.feed.feedId).asObservable()
                        .share()
                        .bind { result in
                            switch result {
                            case .success(let commentPage):
                                nextPageURL = commentPage.next
                                var commentSection: [CommentSection] = []
                                let fetchedCommentCounts = commentPage.results.count
                                var fetchedCommentReplyCount = 0
                                
                                commentPage.results.forEach { comment in
                                    commentSection.append(CommentSection(headerComment: comment, items: []))
                                    fetchedCommentReplyCount += comment.reply?.count ?? 0
                                }
                             
                                commentsCount.accept(fetchedCommentCounts + fetchedCommentReplyCount)
                                comments.accept(commentSection)
                                
                            case .errorResponse(let errorResponse):
                                Logger.printLog("detailFeedVM 댓글 조회 실패: \(errorResponse)")
                            }
                        }
                        .disposed(by: disposeBag)
    
                case .errorResponse(let errorResponse):
                    Logger.printLog("detailFeedVM - 피드 조회 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapLikeFeed
            .flatMap { [unowned self] _ in likeFeed(feed: dependencies.feed)}
            .bind { result in
                switch result {
                case .success(let likeResponse):
                    showLikeFeed.accept(likeResponse)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("deleteFeedVM - 좋아요 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapLikeComment
            .flatMap { [unowned self] comment in likeComment(comment: comment)}
            .bind { result in
                switch result {
                case .success(let likeResponse):
                    showLikeComment.accept(likeResponse)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("deleteFeedVM - 좋아요 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapUploadComment
            .share()
            .filter { _ in (isCommentEditing.value == false && editCommentRelay.value == nil)}
            .flatMap { [unowned self] in
                self.uploadFeedComment(feedID: dependencies.feed.feedId, request: UploadCommentRequest(content: $0, images: selectedImages.value.first))
            }
            .bind { result in
                editCommentRelay.accept(nil)
                isCommentEditing.accept(false)
                selectedImages.accept([])
                
                switch result {
                case .success(_):
                    fetching.accept(())
                    uploadComment.accept(())
                case .errorResponse(let errorResponse):
                    Logger.printLog("detailFeedVM 댓글업로드 실패: \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapUploadComment
            .share()
            .filter { _ in isCommentEditing.value == true }
            .flatMap { [unowned self] content -> Single<NetworkResult<Comment>> in
                self.editComment(comment: editCommentRelay.value!, request: UploadCommentRequest(content: content, images: selectedImages.value.first))
            }
            .bind { result in
                editCommentRelay.accept(nil)
                isCommentEditing.accept(false)
                selectedImages.accept([])
                
                switch result {
                case .success(let comment):
                    if let firstIndex = comments.value.firstIndex(where: {$0.headerComment.commentID == comment.commentID}) {
                        var editedComments = comments.value
                        editedComments[firstIndex] = CommentSection(headerComment: comment, items: comment.reply ?? [])
                        
                        comments.accept(editedComments)
                        uploadComment.accept(())
                    }
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("detailFeedVM 댓글수정 실패: \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        
        input.didSelectImage
            .bind(to: selectedImages)
            .disposed(by: disposeBag)
        
        input.tapRemoveImage
            .bind { _ in
                selectedImages.accept([])
            }
            .disposed(by: disposeBag)
        
        input.tapDeleteFeed
            .flatMap { [unowned self] in deleteFeed(feed: dependencies.feed) }
            .bind { result in
                switch result {
                case .success(let result):
                    if result == true {
                        showDeleteFeedPage.accept(())
                    } else {
                        Logger.printLog("detailFeedVM - deleteFeed fail)")
                    }
                case .errorResponse(let errorResponse):
                    Logger.printLog("detailFeedVM - deleteFeed error \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapHideFeed
            .flatMap { [unowned self] feed in hideFeed(feed: feed)}
            .bind { result in
                switch result {
                case .success(let response):
                    showHideFeedPage.accept(())
                case .errorResponse(let errorResponse):
                    Logger.printLog("DetailFeedVM - 게시물 숨기기 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapDeleteComment
            .bind { [weak self] comment in
                guard let self = self else { return }
                self.deleteComment(comment: comment).asObservable()
                    .bind { result in
                        switch result {
                        case .success(let deleteResult):
                            guard deleteResult == true else { fatalError() }
                            
                            if let firstIndex = comments.value.firstIndex(where: {$0.headerComment.commentID == comment.commentID}) {
                                var removedComments = comments.value
                                removedComments.remove(at: firstIndex)
                                
                                comments.accept(removedComments)
                                showDeleteCommentMessage.accept((()))
                            }
                            
                        case .errorResponse(let errorResponse):
                            Logger.printLog("DetailFeedVM - 댓글 삭제 실패 에러 \(errorResponse)")
                        }
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.tapEditComment
            .bind { comment in
                editCommentRelay.accept(comment)
                isCommentEditing.accept(true)
                
                if let imageURL = comment.image,
                   let data = try? Data(contentsOf: imageURL) {
                    let image = UIImage(data: data)!
                    selectedImages.accept([image])
                }
            }
            .disposed(by: disposeBag)
        
        input.tapCancelEditComment
            .bind { _ in
                selectedImages.accept([])
                editCommentRelay.accept(nil)
                isCommentEditing.accept(false)
            }
            .disposed(by: disposeBag)
        
        input.refreshControlAction
            .do(onNext: { comments.accept([])})
            .bind { _ in
                fetching.accept(())
                refreshControlCompleted.accept(())
            }
            .disposed(by: disposeBag)
        
        input.fetchMoreComments
            .filter { [weak self] _ in nextPageURL != nil && self?.isPaginationRequestStillResume == false }
            .do(onNext: { isLoadingSpinnerAvailable.accept(true)})
            .flatMap { [unowned self] _ in self.fetchMoreComments(nextPageURL: nextPageURL!)}
            .bind { [weak self] result in
                isLoadingSpinnerAvailable.accept(false)
                self?.isPaginationRequestStillResume = false
                
                switch result {
                case .success(let commentPage):
                    nextPageURL = commentPage.next

                    var fetchedComments: [CommentSection] = []
                    commentPage.results.forEach { comment in
                        fetchedComments.append(CommentSection(headerComment: comment, items: []))
                    }

                    comments.accept(comments.value + fetchedComments)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("DetailFeedVM - 댓글 페이징 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapSaveFeed
            .flatMap { [unowned self] feed in saveFeed(feed: feed)}
            .bind { result in
                switch result {
                case .success(let response):
                    showSavedFeed.accept(response.saved)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("DetailFeedVM - 게시물 저장 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
      
        //MARK: OUTPUT
        
        return Output(feed: feed.asObservable(),
                      comments: comments.asObservable(),
                      commentsCount: commentsCount.asObservable(),
                      uploadComment: uploadComment.asObservable(),
                      showSavedFeed: showSavedFeed.asObservable(),
                      showFeedOptionsPage: showOptions.asObservable(),
                      showEditFeedPage: showEditFeedPage.asObservable(),
                      showDeleteFeedPage: showDeleteFeedPage.asObservable(),
                      showDeclarationPage: showDeclarationPage.asObservable(),
                      showGallery: showGallery.asObservable(),
                      hideGallery: hideGallery.asObservable(),
                      selectedImages: selectedImages.asObservable(),
                      removeImage: removeImgae.asObservable(),
                      showCommentOptionPage: showCommentOptionPage.asObservable(),
                      showDeleteCommentMessage: showDeleteCommentMessage.asObservable(),
                      showHideFeedPage: showHideFeedPage.asObservable(),
                      showLikeFeed: showLikeFeed.asObservable(),
                      showLikeComment: showLikeComment.asObservable(),
                      refreshControlCompleted: refreshControlCompleted.asObservable(),
                      isLoadingSpinnerAvailable: isLoadingSpinnerAvailable.asObservable())
            
    }
    
    //MARK: - API
    
    private func fetchFeed(feedId: Int) -> Single<NetworkResult<Feed>> {
        return dependencies.feedUsecase.fetchFeed(feedID: feedId)
    }
    
    private func fetchFeedComments(feedID: Int) -> Single<NetworkResult<CommentPage>> {
        return dependencies.feedUsecase.fetchFeedComments(feedID: feedID)
    }
    
    private func uploadFeedComment(feedID: Int, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>> {
        return dependencies.feedUsecase.uploadFeedComment(feedID: feedID, request: request)
    }
    
    private func fetchUser() -> Single<NetworkResult<User>> {
        return dependencies.userUsercase.fetchUser()
    }
    
    private func deleteFeed(feed: Feed) -> Single<NetworkResult<Bool>> {
        return dependencies.feedUsecase.deleteFeed(feed: feed)
    }
    
    private func deleteComment(comment: Comment) -> Single<NetworkResult<Bool>> {
        return dependencies.feedUsecase.deleteComment(comment: comment)
    }
    
    private func likeFeed(feed: Feed) -> Single<NetworkResult<LikeResponse>> {
        return dependencies.feedUsecase.likeFeed(feed: feed)
    }
    
    private func likeComment(comment: Comment) -> Single<NetworkResult<LikeResponse>> {
        return dependencies.feedUsecase.likeComment(comment: comment)
    }
    
    private func editComment(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>> {
        return dependencies.feedUsecase.editComment(comment: comment, request: request)
    }
    
    private func fetchMoreComments(nextPageURL: String) -> Single<NetworkResult<CommentPage>> {
        isPaginationRequestStillResume = true
        return dependencies.feedUsecase.fetchMoreComments(nextPageURL: nextPageURL)
    }
    
    private func hideFeed(feed: Feed) -> Single<NetworkResult<HideResponse>> {
        return dependencies.feedUsecase.hideFeed(feed: feed)
    }
    
    private func saveFeed(feed: Feed) -> Single<NetworkResult<SaveResponse>> {
        return dependencies.feedUsecase.saveFeed(feed: feed)
    }
}


