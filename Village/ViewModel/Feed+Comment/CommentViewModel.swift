import RxSwift
import RxRelay

class CommentViewModel: ViewModelType {
    struct Input {
        let fetching: Observable<Void>
        let tapUploadComment: Observable<UploadCommentRequest>
        let tapComentOption: Observable<(Comment, CommentType)>
        let tapDeleteComment: Observable<Comment>
        let tapDeleteCommentReply: Observable<Comment>
        
        let tapShowGallery: Observable<Void>
        let tapHideGallery: Observable<Void>
        let didSelectImage: Observable<[UIImage]>
        let tapRemoveImage: Observable<Void>
    
        let tapLikeComment: Observable<Comment>
        let tapLikeCommentReply: Observable<Comment>
        
        let tapEditComment: Observable<Comment>
        let tapEditReply: Observable<Comment>
        let tapCancelEditComment: Observable<Void>
    }
    
    struct Output {
        let comment: Observable<[CommentSection]>
        let showCommentOption: Observable<(Comment, [ActionSheetOption], CommentType)>
        let showDeleteCommentPage: Observable<Void>
        let showDeleteCommentReplyPage: Observable<Void>
       
        let showGallery: Observable<Void>
        let hideGallery: Observable<Void>
        let selectedImages: Observable<[UIImage]>
        let removeImage: Observable<Void>
    }
    
    struct Dependencies {
        let comment: Comment
        let userUsecase: UserUsecase
        let feedUsecase: FeedUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    let tapComentOption = PublishRelay<(Comment, CommentType)>()
    
    let tapLikeComment = PublishRelay<Comment>()
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let editCommentRelay = BehaviorRelay<Comment?>(value: nil)
        
        let isReplyEditing = BehaviorRelay<Bool>(value: false)
        let isCommentEditing = BehaviorRelay<Bool>(value: false)
    
        let fetching = PublishRelay<Void>()
        let commentRelay = PublishRelay<[CommentSection]>()
        let showCommentOption = PublishRelay<(Comment, [ActionSheetOption], CommentType)>()
        let showDeleteCommentPage = PublishRelay<Void>()
        let showDeleteCommentReplyPage = PublishRelay<Void>()
        let showGallery = input.tapShowGallery
        let hideGallery = input.tapHideGallery
        let selectedImages = BehaviorRelay<[UIImage]>(value: [])
        let removeImgae = input.tapRemoveImage
     
        input.fetching
            .bind(to: fetching)
            .disposed(by: disposeBag)
        
        input.tapLikeComment
            .flatMap { [unowned self] comment in likeComment(comment: comment)}
            .bind { result in
                switch result {
                case .success(let likeResponse):
                    Logger.printLog(likeResponse)
                case .errorResponse(let errorResponse):
                    Logger.printLog("ComemntVM - 댓글 좋아요 실패 \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapLikeCommentReply
            .flatMap { [unowned self] reply in likeCommentReply(reply: reply)}
            .bind { result in
                switch result {
                case .success(let likeResponse):
                    Logger.printLog(likeResponse)
                case .errorResponse(let errorResponse):
                    Logger.printLog("ComemntVM - 댓글 좋아요 실패 \(errorResponse)")
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
        
        input.tapEditComment
            .bind { comment in
                editCommentRelay.accept(comment)
                isCommentEditing.accept(true)
                isReplyEditing.accept(false)
                
                if let imageURL = comment.image,
                   let data = try? Data(contentsOf: imageURL) {
                    let image = UIImage(data: data)!
                    selectedImages.accept([image])
                }
            }
            .disposed(by: disposeBag)
        
        input.tapEditReply
            .bind { comment in
                editCommentRelay.accept(comment)
                isReplyEditing.accept(true)
                isCommentEditing.accept(false)
                
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
                isReplyEditing.accept(false)
            }
            .disposed(by: disposeBag)
        
        fetching.asObservable()
            .share()
            .flatMap { [unowned self] _ in fetchCommentReply(comment: dependencies.comment) }
            .bind { result in
                switch result {
                case .success(let comment):
                    let commentSection = [CommentSection(headerComment: comment, items: comment.reply ?? [])]
                    commentRelay.accept(commentSection)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("commentVM - fetchCommentReply Error \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
                
        
        fetching.asObservable()
            .take(1)
            .flatMap { [unowned self] _ in fetchUser() }
            .bind { [unowned self] result in
                switch result {
                case .success(let user):
                  
                    input.tapUploadComment
                        .share()
                        .filter { _ in (isReplyEditing.value == false && isCommentEditing.value == false && editCommentRelay.value == nil) }
                        .flatMap { [unowned self] request in uploadCommentReply(comment: dependencies.comment, request: request) }
                        .bind { result in
                            switch result {
                            case .success:
                                fetching.accept(())
                                
                            case .errorResponse(let errorResponse):
                                Logger.printLog("commentVM - 대댓글업로드 실패: \(errorResponse)")
                            }
                        }
                        .disposed(by: self.disposeBag)
                    
                    input.tapUploadComment
                        .share()
                        .filter { _ in isReplyEditing.value == true && isCommentEditing.value == false  && editCommentRelay.value != nil }
                        .flatMap { [unowned self] request in editReply(reply: editCommentRelay.value!, request: request) }
                        .bind { result in
                            switch result {
                            case .success:
                                fetching.accept(())
                                
                            case .errorResponse(let errorResponse):
                                Logger.printLog("commentVM - 대댓글업로드 실패: \(errorResponse)")
                            }
                        }
                        .disposed(by: self.disposeBag)
                    
                    input.tapUploadComment
                        .share()
                        .filter { _ in isCommentEditing.value == true && isReplyEditing.value == false && editCommentRelay.value != nil }
                        .flatMap { [unowned self] request in editComment(comment: editCommentRelay.value!, request: request)}
                        .bind { result in
                            switch result {
                            case .success:
                                fetching.accept(())
                                
                            case .errorResponse(let errorResponse):
                                Logger.printLog("commentVM - 대댓글업로드 실패: \(errorResponse)")
                            }
                        }
                        .disposed(by: self.disposeBag)
                    
                    self.tapComentOption
                        .bind { (comment, commentType) in
                            if user.id == comment.author.id {
                                showCommentOption.accept((comment, [.edit, .delete], commentType))
                            } else {
                                showCommentOption.accept((comment, [.declaration], commentType))
                            }
                        }
                        .disposed(by: self.disposeBag)
                    
                    input.tapDeleteComment
                        .flatMap { [unowned self] comment in deleteComment(comment: comment)}
                        .bind { result in
                            switch result {
                            case .success:
                                showDeleteCommentPage.accept(())
                                
                            case .errorResponse(let errorResponse):
                                Logger.printLog("commentVM - 댓글 삭제 실패 \(errorResponse)")
                            }
                        }
                        .disposed(by: disposeBag)
                    
                    input.tapDeleteCommentReply
                        .flatMap { [unowned self] comment in deleteCommentReply(comment: comment)}
                        .bind { result in
                            switch result {
                            case.success:
                                showDeleteCommentReplyPage.accept(())
                                fetching.accept(())
                              
                            case .errorResponse(let errorResponse):
                                Logger.printLog("commentVM - 대댓글 삭제 실패 \(errorResponse)")
                            }
                        }
                        .disposed(by: disposeBag)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("commentVM - fetchUser Error: \(errorResponse)")
                }
            }
            .disposed(by: disposeBag)
        
        fetching.asObservable()
            .map { [unowned self] in [CommentSection(headerComment: dependencies.comment, items: dependencies.comment.reply ?? [])] }
            .bind(to: commentRelay)
            .disposed(by: disposeBag)
        
        return Output(comment: commentRelay.asObservable(),
                      showCommentOption: showCommentOption.asObservable(),
                      showDeleteCommentPage: showDeleteCommentPage.asObservable(),
                      showDeleteCommentReplyPage: showDeleteCommentReplyPage.asObservable(),
                      showGallery: showGallery.asObservable(),
                      hideGallery: hideGallery.asObservable(),
                      selectedImages: selectedImages.asObservable(),
                      removeImage: removeImgae.asObservable())
    }
    
    private func fetchUser() -> Single<NetworkResult<User>> {
        return dependencies.userUsecase.fetchUser()
    }
    
    private func deleteComment(comment: Comment) -> Single<NetworkResult<Bool>> {
        return dependencies.feedUsecase.deleteComment(comment: comment)
    }
    
    private func fetchCommentReply(comment: Comment) -> Single<NetworkResult<Comment>> {
        return dependencies.feedUsecase.fetchCommentReply(comment: comment)
    }
    
    private func uploadCommentReply(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<UploadCommentResponse>> {
        return dependencies.feedUsecase.uploadCommentReply(comment: comment, request: request)
    }
    
    private func deleteCommentReply(comment: Comment) -> Single<NetworkResult<Bool>> {
        return dependencies.feedUsecase.deleteCommentReply(comment: comment)
    }
    
    private func likeComment(comment: Comment) -> Single<NetworkResult<LikeResponse>> {
        return dependencies.feedUsecase.likeComment(comment: comment)
    }
    
    private func likeCommentReply(reply: Comment) -> Single<NetworkResult<LikeResponse>> {
        return dependencies.feedUsecase.likeReply(reply: reply)
    }
    
    private func editComment(comment: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>> {
        return dependencies.feedUsecase.editComment(comment: comment, request: request)
    }
    
    private func editReply(reply: Comment, request: UploadCommentRequest) -> Single<NetworkResult<Comment>> {
        return dependencies.feedUsecase.editReply(reply: reply, request: request)
    }
}
