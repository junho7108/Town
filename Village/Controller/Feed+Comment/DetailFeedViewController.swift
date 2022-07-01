import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard
import RxViewController

class DetailFeedViewController: BaseViewController {
    
    var coordinator: DetailFeedCoordinator?

    let viewModel: DetailFeedViewModel
    
    private var isShownKeyboard: Bool = false
    
    private var editedComment: Bool = false
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private(set) var dataSources: RxTableViewSectionedReloadDataSource<CommentSection>!

    //MARK: - UI Properites
    
    private lazy var spinner: UIView = {
        let view = UIView(frame: .init(origin: .zero, size: .init(width: view.frame.size.width, height: 100)))
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    private lazy var selfView = DetailFeedTableView()

    private var scrollToComment: Bool
    
    private let imagePickerController = UIImagePickerController()
    
    private lazy var commentInputView = CommentInputView(frame: .zero)
  
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    //MARK: - Lifecycles
    
    init(viewModel: DetailFeedViewModel, scrollToComment: Bool) {
        self.viewModel = viewModel
        self.scrollToComment = scrollToComment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if scrollToComment {
            selfView.scrollToComment()
            scrollToComment = false
        }
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
    
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    override func configureNavigationController() {
        super.configureNavigationController()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: detailFeedBackButton)
        let optionBarButton = UIBarButtonItem(customView: selfView.optionButton)
        let storeFeedBarButton = UIBarButtonItem(customView: selfView.storeFeedButton)
        navigationItem.rightBarButtonItems = [optionBarButton, storeFeedBarButton]
    }
    
    func configureBackButtonItem(title: String = "") {
        super.configureNavigationController()
        backBarButtonItem.title = title
    }
    
    //MARK: - Helpers
    
    override func setUpBindins() {
        
        //MARK: INPUT
        
        let fetchComments: Observable<Void> = rx.viewWillAppear.map { _ in }.asObservable()
        let tapLikeFeed: Observable<Void> = selfView.headerView.likeButton.rx.tap.asObservable()
        let tapLikeComment = viewModel.tapLikeComment.asObservable()
      
        let tapUploadComment = PublishRelay<String>()
        let tapSaveFeed = PublishRelay<Feed>()
        let tapOptionButton: Observable<Void> = selfView.optionButton.rx.tap.asObservable()
        
        let tapEditFeed = PublishSubject<Feed>()
        let tapDeleteFeed = PublishSubject<Void>()
        let tapDeclaration = PublishSubject<Void>()
        let tapHideFeed = PublishRelay<Feed>()
   
        let tapShowGallery: Observable<Void> = commentInputView.uploadButton.rx.tap.asObservable()
        let tapHideGallery: Observable<Void> = imagePickerController.rx.didCancel.asObservable()
        let didSelectImage: Observable<[UIImage]> = imagePickerController.rx.didSelectImage.asObservable()
        let tapRemoveImage: Observable<Void> = commentInputView.removeImageButton.rx.tap.asObservable()
        
        let tapCommentOption = viewModel.tapCommentOption.asObservable()
        let tapDeleteComment = PublishRelay<Comment>()
        
        let tapEditComment = PublishRelay<Comment>()
        let tapCancelEditComment = PublishRelay<Void>()
        
        let fetchMoreComments = PublishRelay<Void>()
        let refreshControlAction = PublishRelay<Void>()
        
        //MARK: BINDS
        
        selfView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to: refreshControlAction)
            .disposed(by: disposeBag)
        
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
        
//        detailFeedBackButton.rx.tap
//            .bind(onNext: { [weak self] _ in
//                self?.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: disposeBag)
            
        selfView.headerView.commentButton.rx.tap
            .bind { [weak self] in
                self?.selfView.scrollToComment()
                self?.commentInputView.commentInputView.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        selfView.storeFeedButton.rx.tap
            .map { [unowned self] in viewModel.dependencies.feed}
            .bind(to: tapSaveFeed)
            .disposed(by: disposeBag)
        
        Observable.merge([
            selfView.headerView.userProfileImageView.rx.tapGesture(configuration: nil).when(.recognized),
            selfView.headerView.usernameLabel.rx.tapGesture(configuration: nil).when(.recognized)
        ])
        .bind { [weak self] _ in
            guard let self = self else { return }
            self.configureBackButtonItem(title: "이웃 정보")
            self.coordinator?.pushUserProfileScene(user: self.viewModel.dependencies.feed.author)
        }
        .disposed(by: disposeBag)
        
        selfView.headerView.contentImageView.rx
            .tapGesture(configuration: nil)
            .when(.recognized)
            .filter{ [unowned self] _ in selfView.headerView.contentImageView.image != nil }
            .map { [unowned self] _ in selfView.headerView.contentImageView.image! }
            .bind { [weak self] image in
                self?.showImageView(image: image)
            }
            .disposed(by: disposeBag)
        
        commentInputView.postButton.rx.tap
            .withLatestFrom(commentInputView.commentInputView.rx.text.orEmpty)
            .filter { $0.count > 0 }
            .bind(to: tapUploadComment)
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
        
        selfView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        
        self.dataSources = RxTableViewSectionedReloadDataSource<CommentSection>.init(configureCell: {
            [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            
            let cell = self.selfView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            cell.configureUI(comment: item)
            return cell
        })
        
        //MARK: Paging
        
        selfView.rx.didScroll
            .bind { [weak self] in
                guard let self = self else { return }
                let offsetY = self.selfView.contentOffset.y
                let contentHeight = self.selfView.contentSize.height
              
                if offsetY > (contentHeight - self.selfView.frame.size.height - 100) {
                    fetchMoreComments.accept(())
                }
            }
            .disposed(by: disposeBag)
        
 
        //MARK: OUTPUT
        
        let output = viewModel.transform(input: .init(fetching: fetchComments,
                                                      tapLikeFeed: tapLikeFeed.asObservable(),
                                                      tapLikeComment: tapLikeComment.asObservable(),
                                                      tapUploadComment: tapUploadComment.asObservable(),
                                                      tapSaveFeed: tapSaveFeed.asObservable(),
                                                      tapFeedOption: tapOptionButton,
                                                      tapEditFeed: tapEditFeed.asObservable(),
                                                      tapDeleteFeed: tapDeleteFeed.asObservable(),
                                                      tapDeclaration: tapDeclaration.asObservable(),
                                                      tapHideFeed: tapHideFeed.asObservable(),
                                                      tapShowGallery: tapShowGallery.asObservable(),
                                                      tapHideGallery: tapHideGallery.asObservable(),
                                                      didSelectImage: didSelectImage.asObservable(),
                                                      tapRemoveImage: tapRemoveImage.asObservable(),
                                                      tapCommentOption: tapCommentOption.asObservable(),
                                                      tapDeleteComment: tapDeleteComment.asObservable(),
                                                      tapEditComment: tapEditComment.asObservable(),
                                                      tapCancelEditComment: tapCancelEditComment.asObservable(),
                                                      fetchMoreComments: fetchMoreComments.asObservable(),
                                                      refreshControlAction: refreshControlAction.asObservable()))
        
        output.feed
            .share()
            .bind { [weak self] feed in
                guard let self = self else { return }
                self.selfView.configureUI(feed: feed)
                self.selfView.setNeedsLayout()
            }
            .disposed(by: disposeBag)
        
        output.comments
            .share()
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] comments in
                guard let self = self else { return }
                self.selfView.tableFooterView?.isHidden = !comments.isEmpty
            })
            .disposed(by: self.disposeBag)
        
        output.comments
            .share()
            .asDriver(onErrorJustReturn: [])
            .drive(self.selfView.rx.items(dataSource: self.dataSources))
            .disposed(by: self.disposeBag)
                 
        output.showGallery
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                present(imagePickerController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.hideGallery
            .bind { [weak self] in
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
                Logger.printLog("이미지 삭제")
                self?.commentInputView.removeImage()
            }
            .disposed(by: disposeBag)
        
        output.uploadComment
            .bind { [weak self] in
                self?.commentInputView.removeImage()
                self?.commentInputView.commentInputView.text = nil
                self?.commentInputView.commentInputView.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        output.showCommentOptionPage
            .bind { [weak self] (comment, options) in
                let optionActionSheet = ActionSheetViewController(options: options)
                
                Observable.of(options)
                    .asDriver(onErrorJustReturn: [])
                    .drive(optionActionSheet.tableView.rx.items(cellIdentifier: ActionSheetCell.identifier, cellType: ActionSheetCell.self)) { index, option, cell in
                        cell.configureActionSheet(option: option)
                    }.disposed(by: optionActionSheet.disposeBag)
                
                optionActionSheet.tableView.rx
                    .modelSelected(ActionSheetOption.self)
                    .bind { [weak self] option in
                        
                        optionActionSheet.dismiss(animated: false) {
                            switch option {
                            case .delete:
                                let deletePopup = BasePopupViewController(title: "알림", content: "🗑 정말 삭제하실건가요?")
                                deletePopup.show(parent: self)
                                deletePopup.okButton.rx.tap
                                    .bind { _ in
            
                                        deletePopup.dismiss(animated: false)
                                        tapDeleteComment.accept(comment)
                                    }
                                    .disposed(by: deletePopup.disposeBag)
                                
                            case .edit:
                                self?.editedComment = true
                                self?.commentInputView.configureUI(comment: comment)
                                tapEditComment.accept(comment)
                                
                            case .declaration:
                                Logger.printLog("댓글 신고")
                                
                            default:
                                break
                            }
                        }
                    }
                    .disposed(by: optionActionSheet.disposeBag)
                
                self?.present(optionActionSheet, animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
            
  
        output.showFeedOptionsPage
            .bind { [weak self] options in
                let optionActionSheet = ActionSheetViewController(options: options)
                
                Observable.of(options)
                    .asDriver(onErrorJustReturn: [])
                    .drive(optionActionSheet.tableView.rx.items(cellIdentifier: ActionSheetCell.identifier, cellType: ActionSheetCell.self)) { index, option, cell in
                        cell.configureActionSheet(option: option)
                    }.disposed(by: optionActionSheet.disposeBag)
                
                optionActionSheet.tableView.rx
                    .modelSelected(ActionSheetOption.self)
                    .bind { [weak self] option in
                        guard let self = self else { return }
                        
                        optionActionSheet.dismiss(animated: false) {
                            
                            switch option {
                            case .delete:
                                let deleteFeedPopup = BasePopupViewController(title: "알림", content: "🗑 정말 삭제하실건가요?")
                                deleteFeedPopup.show(parent: self)
                                deleteFeedPopup.okButton.rx.tap
                                    .bind { _ in
                                        deleteFeedPopup.dismiss(animated: false)
                                        tapDeleteFeed.onNext(())
                                    }
                                    .disposed(by: deleteFeedPopup.disposeBag)

                            case .edit:
                                tapEditFeed.onNext(self.viewModel.dependencies.feed)
                                
                            case .declaration:
                                tapDeclaration.onNext(())
                                
                            case .hide, .cancelHide:
                                tapHideFeed.accept(self.viewModel.dependencies.feed)
                            }
                        }
                    }
                    .disposed(by: optionActionSheet.disposeBag)
                
                self?.present(optionActionSheet, animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
        
        output.showEditFeedPage
            .bind { [weak self] feed in
                self?.configureBackButtonItem(title: "글 수정하기")
                self?.coordinator?.pushEditFeedScene(feed: feed)
            }
            .disposed(by: disposeBag)
        
        
        output.showDeleteFeedPage
            .bind { [weak self] _ in
                VillageNotificationCenter.fetchFeed.post()
                self?.showToast(message: "게시물이 삭제되었습니다.")
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showHideFeedPage
            .bind { [weak self] in
                VillageNotificationCenter.fetchFeed.post()
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showDeclarationPage
            .bind { [weak self] in
                self?.configureBackButtonItem(title: "🚨 신고하기")
                self?.coordinator?.pushDeclarationScene()
            }
            .disposed(by: disposeBag)
        
        output.showDeleteCommentMessage
            .bind { [weak self] in
                self?.showToast(message: "댓글이 삭제되었습니다.")
            }
            .disposed(by: disposeBag)
        
        output.showLikeFeed
            .bind { [weak self] likeResponse in
                self?.selfView.configureUI(likeResponse: likeResponse)
            }
            .disposed(by: disposeBag)
        
        output.showLikeComment
            .bind { likeResponse in
                Logger.printLog("좋아요")
            }
            .disposed(by: disposeBag)
        
        output.refreshControlCompleted
            .bind { [weak self] in
                self?.selfView.refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        output.isLoadingSpinnerAvailable
            .bind { [weak self] isAvailable in
                guard let self = self else { return }
                self.selfView.tableFooterView = isAvailable ? self.spinner : self.selfView.footerView
            }
            .disposed(by: disposeBag)
        
        output.showSavedFeed
            .bind { [weak self] result in
                self?.selfView.saved(saved: result)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate

extension DetailFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = dataSources.sectionModels[section].headerComment
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentSectionHeaderView.identifier) as! CommentSectionHeaderView
        header.configureUI(comment: item, showReply: true)
   
        header.likeButton.rx.tap
            .map { item }
            .bind(onNext: { [weak self] comment in
                self?.viewModel.tapLikeComment.accept(comment)
                header.like()
            })
            .disposed(by: header.disposeBag)
        
        Observable.merge([
            header.commentButton.rx.tap.asObservable(),
            header.moreReplayButton.rx.tap.asObservable()
        ])
            .bind(onNext: { [weak self ] _ in
                self?.configureBackButtonItem(title: "답글")
                self?.coordinator?.pushCommentScene(comment: item)
            })
            .disposed(by: header.disposeBag)
        
        header.optionButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                Logger.printLog("댓글 옵션: \(item.content)")
                self.viewModel.tapCommentOption.accept(item)
            }
            .disposed(by: header.disposeBag)
        
        header.contentImageView.rx.tapGesture(configuration: nil)
            .when(.recognized)
            .map { _ in header.contentImageView.image }
            .filter { $0 != nil }
            .bind { [weak self] image in
                self?.showImageView(image: image!)
            }
            .disposed(by: header.disposeBag)
        
        Observable.merge([header.profileImageView.rx.tapGesture(configuration: nil).when(.recognized),
                          header.usernameLabel.rx.tapGesture(configuration: nil).when(.recognized)])
        .bind { [weak self] _ in
            self?.configureBackButtonItem(title: "이웃 정보")
            self?.coordinator?.pushUserProfileScene(user: item.author)
        }
        .disposed(by: header.disposeBag)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
