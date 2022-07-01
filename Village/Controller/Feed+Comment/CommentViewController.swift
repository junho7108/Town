import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard

class CommentViewController: BaseViewController, UIScrollViewDelegate {
    
    var coordinator: CommentCoordinator?
    
    let viewModel: CommentViewModel
    
    private var isShownKeyboard: Bool = false
    
    private var editedComment: Bool = false
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - UI Properties
    
    private(set) var dataSources: RxTableViewSectionedReloadDataSource<CommentSection>!
    
    private let imagePickerController = UIImagePickerController()
    
    private lazy var commentInputView = CommentInputView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 150))
  
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    let selfView = CommentTableView(frame: .zero, style: .grouped)
    
    //MARK: - Lifecycles
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
        
        //MARK: INPUT
        
        let fetching = rx.viewWillAppear.map { _ in }
        
        let tapCommentReply = PublishRelay<UploadCommentRequest>()
        let tapComentOption = viewModel.tapComentOption
        
        let tapDeleteComment = PublishRelay<Comment>()
        let tapDeleteCommentReply = PublishRelay<Comment>()
        
        let tapShowGallery: Observable<Void> = commentInputView.uploadButton.rx.tap.asObservable()
        let tapHideGallery: Observable<Void> = imagePickerController.rx.didCancel.asObservable()
        let didSelectImage: Observable<[UIImage]> = imagePickerController.rx.didSelectImage.asObservable()
        let tapRemoveImage: Observable<Void> = commentInputView.removeImageButton.rx.tap.asObservable()
        
        let tapLikeComment = viewModel.tapLikeComment.asObservable()
        let tapLikeCommentReply = PublishRelay<Comment>()
      
        let tapEditComment = PublishRelay<Comment>()
        let tapEditReply = PublishRelay<Comment>()
        let tapCancelEditComment = PublishRelay<Void>()
        
        //MARK: BINDS
        
        selfView.rx.tapGesture(configuration: nil)
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                if self.isShownKeyboard {
                    if self.editedComment {
                        let cancelPopup = BasePopupViewController(title: "알림", content: "수정을 취소하시겠습니까?")
                        cancelPopup.show(parent: self)
                        cancelPopup.okButton.rx.tap
                            .bind { _ in
                                cancelPopup.dismiss(animated: false)
                                self.commentInputView.clear()
                                tapCancelEditComment.accept(())
                                self.editedComment = false
                            }
                            .disposed(by: cancelPopup.disposeBag)
                    } else {
                        self.commentInputView.commentInputView.resignFirstResponder()
                        self.editedComment = false
                    }
                }
            }
            .disposed(by: disposeBag)
        
        commentInputView.postButton.rx.tap
            .map { [unowned self] _ in
                return  UploadCommentRequest(content: commentInputView.commentInputView.text, images: commentInputView.contentImageView.image)
            }
            .filter { !$0.content.isEmpty || $0.images != nil }
            .bind(to: tapCommentReply)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive { [unowned self] height in
                selfView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
      
                if floor(height) > floor(commentInputView.frame.height) {
                    isShownKeyboard = true
                } else {
                    isShownKeyboard = false
                }
            }
            .disposed(by: disposeBag)
        
        dataSources = RxTableViewSectionedReloadDataSource<CommentSection>.init(configureCell: {
            [unowned self] dataSource, tableView, indexPath, item in
            
            let cell = selfView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            cell.configureUI(comment: item)
            
            Observable.merge([
                cell.profileImageView.rx.tapGesture(configuration: nil).when(.recognized),
                cell.usernameLabel.rx.tapGesture(configuration: nil).when(.recognized)
            ])
                .bind { [weak self] _ in
                    self?.coordinator?.pushUserProfileScene(user: item.author)
                }
                .disposed(by: cell.disposeBag)
        
            cell.contentImageView.rx.tapGesture(configuration: nil)
                .when(.recognized)
                .filter { _ in cell.contentImageView.image != nil }
                .map { _ in cell.contentImageView.image! }
                .bind { [weak self] image in
                    self?.showImageView(image: image)
                }
                .disposed(by: cell.disposeBag)
                
            cell.likeButton.rx.tap
                .map { item }
                .bind { reply in
                    cell.like()
                    tapLikeCommentReply.accept(reply)
                }
                .disposed(by: cell.disposeBag)

            cell.optionButton.rx.tap
                .bind { _ in
                    tapComentOption.accept((item, .reply))
                }
                .disposed(by: cell.disposeBag)

            return cell
        })
        
        selfView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(fetching: fetching.asObservable(),
                                                      tapUploadComment: tapCommentReply.asObservable(),
                                                      tapComentOption: tapComentOption.asObservable(),
                                                      tapDeleteComment: tapDeleteComment.asObservable(),
                                                      tapDeleteCommentReply: tapDeleteCommentReply.asObservable(),
                                                      tapShowGallery: tapShowGallery.asObservable(),
                                                      tapHideGallery: tapHideGallery.asObservable(),
                                                      didSelectImage: didSelectImage.asObservable(),
                                                      tapRemoveImage: tapRemoveImage.asObservable(),
                                                      tapLikeComment: tapLikeComment.asObservable(),
                                                      tapLikeCommentReply: tapLikeCommentReply.asObservable(),
                                                      tapEditComment: tapEditComment.asObservable(),
                                                      tapEditReply: tapEditReply.asObservable(),
                                                      tapCancelEditComment: tapCancelEditComment.asObservable()))
        
        output.showGallery
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                present(imagePickerController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.hideGallery
            .bind { [weak self] in
                Logger.printLog("hide Gallery")
                self?.imagePickerController.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.selectedImages
            .filter { $0.count > 0 }
            .bind { [weak self] images in
                self?.commentInputView.selectImage(image: images.first!)
                self?.imagePickerController.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.removeImage
            .bind { [weak self] in
                self?.commentInputView.removeImage()
            }
            .disposed(by: disposeBag)
        
        output.comment
            .do(onNext: { [weak self] _ in self?.commentInputView.clear()})
            .bind(to: selfView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
                
        output.showCommentOption
            .bind { [weak self] (comment, options, commentType) in
                let optionActionSheet = ActionSheetViewController(options: options)
                
                Observable.of(options)
                    .asDriver(onErrorJustReturn: [])
                    .drive(optionActionSheet.tableView.rx.items(cellIdentifier: ActionSheetCell.identifier, cellType: ActionSheetCell.self)) {
                        index, option, cell in
                        cell.configureActionSheet(option: option)
                    }.disposed(by: optionActionSheet.disposeBag)
                
                optionActionSheet.tableView.rx
                    .modelSelected(ActionSheetOption.self)
                    .bind { option in
                        optionActionSheet.dismiss(animated: false) {
                            switch option {
                            case .delete:
                                let deletePopup = BasePopupViewController(title: "알림", content: "🗑 정말 삭제하실건가요?")
                                deletePopup.show(parent: self)
                                deletePopup.okButton.rx.tapGesture(configuration: nil).when(.recognized)
                                    .bind { _ in
                                        deletePopup.dismiss(animated: false, completion: nil)
            
                                        switch commentType {
                                        case .comment: tapDeleteComment.accept(comment)
                                        case .reply: tapDeleteCommentReply.accept(comment)
                                        }
                                    }
                                    .disposed(by: deletePopup.disposeBag)
                                
                            case .edit:
                                self?.editedComment = true
                                self?.commentInputView.configureUI(comment: comment)
                                
                                switch commentType {
                                case .comment: tapEditComment.accept(comment)
                                case .reply: tapEditReply.accept(comment)
                                }
                              
                            case .declaration:
                                Logger.printLog("신고")
                                
                            default:
                                break
                            }
                        }
                    }
                    .disposed(by: optionActionSheet.disposeBag)
                
                self?.present(optionActionSheet, animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
        
        output.showDeleteCommentReplyPage
            .bind { [weak self] _ in
                self?.showToast(message: "답글이 삭제되었습니다.")
            }
            .disposed(by: disposeBag)
        
        output.showDeleteCommentPage
            .bind { [weak self] _ in
                self?.showToast(message: "댓글이 삭제되었습니다.")
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDragDelegate

extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentSectionHeaderView.identifier) as! CommentSectionHeaderView
        let item = dataSources.sectionModels[section].headerComment
        header.configureUI(comment: item, showReply: false)
        
        Observable.merge([
            header.profileImageView.rx.tapGesture(configuration: nil).when(.recognized),
            header.usernameLabel.rx.tapGesture(configuration: nil).when(.recognized)
        ])
            .bind { [weak self] _ in
                self?.coordinator?.pushUserProfileScene(user: item.author)
            }
            .disposed(by: header.disposeBag)
        
        header.contentImageView.rx.tapGesture(configuration: nil)
            .when(.recognized)
            .filter { _ in header.contentImageView.image != nil }
            .map { _ in header.contentImageView.image! }
            .bind { [weak self] image in
                self?.showImageView(image: image)
            }
            .disposed(by: header.disposeBag)
        
        header.likeButton.rx.tap
            .map { item }
            .bind { [weak self] comment in
                header.like()
                self?.viewModel.tapLikeComment.accept(comment)
            }
            .disposed(by: header.disposeBag)
        
        header.commentButton.rx.tap
            .bind(onNext: {
                print("\(header.comment.author.nickname) - didTapCommentButton() called")
            })
            .disposed(by: header.disposeBag)
        
        header.optionButton.rx.tap
            .bind {  [weak self] _ in
                self?.viewModel.tapComentOption.accept((item, .comment))
            }
            .disposed(by: header.disposeBag)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
