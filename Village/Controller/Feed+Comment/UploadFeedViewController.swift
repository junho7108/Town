import UIKit
import FloatingPanel
import RxSwift
import RxCocoa
import RxKeyboard

final class UploadFeedViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: UploadFeedCoordinator?
    
    let viewModel: UploadFeedViewModel
    
    let imagePickerController = UIImagePickerController()
    
    private var isShownKeyboard: Bool = false
    
    //MARK: - UI Properties
    
    private(set) var floatingVC = FloatingPanelController()
    
    private let SelectTagsBottmSheet = SelectTagAndMBTIViewController()
    
    private var selfView = UploadFeedView()
    
    
    //MARK: - Lifecycles
    
    init(viewModel: UploadFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureFloatingPanel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    //MARK: - Configures
    
    override func configureUI() {
        navigationController?.navigationBar.shadowImage = UIImage()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureFloatingPanel() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 30
        appearance.backgroundColor = .white
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        
        floatingVC.surfaceView.appearance = appearance
        
        floatingVC.set(contentViewController: SelectTagsBottmSheet)
        floatingVC.layout = MyFloatingPanelLayout()
        floatingVC.addPanel(toParent: self)
        floatingVC.invalidateLayout()
        floatingVC.hide()
    }
    
    override func setUpBindins() {

        //MARK: Input
        
        let titleDidChange: Observable<String> = selfView.titleTextView.rx.text.orEmpty.asObservable()
        let contentDidChange: Observable<String> = selfView.contentsTextView.rx.text.orEmpty.asObservable()
        
        let didSelectImage: Observable<[UIImage]> = imagePickerController.rx.didSelectImage.asObservable()
        let tapRemoveImage: Observable<Void> = selfView.uploadPhotoView.closeButton.rx.tap.asObservable()
        
        let tapCreateVoteContent: Observable<Void> = selfView.uploadVoteView.actionButton.rx.tap.asObservable()
        let tapAddVoteContent: Observable<Void> = selfView.uploadVoteView.createVoteView.addVoteButton.rx.tap.asObservable()
        let voteTitleDidChange: Observable<String> = selfView.uploadVoteView.createVoteView.titleTextView.rx.text.orEmpty.asObservable()
        let voteContentDidChange: PublishSubject<(Int, String)> = PublishSubject<(Int, String)>()
        let tapRemoveVoteContent: PublishSubject<Int> = PublishSubject<Int>()
        let tapRemoveAllVoteContnet: Observable<Void> = selfView.uploadVoteView.closeButton.rx.tap.asObservable()
        
        let tapShowTagsPage: Observable<Void> = selfView.uploadTagsView.actionButton.rx.tap.asObservable()
        let didSelectTags: PublishRelay<Void> = PublishRelay<Void>()
        let didSelectCategory: PublishSubject<FeedCategory> = PublishSubject<FeedCategory>()
        let didSelectMBTI: PublishSubject<MBTIType> = PublishSubject<MBTIType>()
        let didSelectEditTags: PublishSubject<Void> = PublishSubject<Void>()
        let tapRemoveTags: Observable<Void> = selfView.uploadTagsView.closeButton.rx.tap.asObservable()

        let tapFeedUpload: Observable<Void> = selfView.completeButton.rx.tap.asObservable()
        
            
        //MARK: Binds
        
        Observable
            .merge([
            selfView.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                guard let self = self else { return }
                gestureRecognizer.delegate = self
                delegate.simultaneousRecognitionPolicy = .never
            })
            .asObservable(),
            
            selfView.uploadTagsView.collectionView.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                guard let self = self else { return }
                gestureRecognizer.delegate = self
                delegate.simultaneousRecognitionPolicy = .never
            })
            .asObservable()
            ])
            .when(.recognized)
            .bind { [weak self] _ in
                self?.selfView.endEditing(true)
            }
            .disposed(by: disposeBag)
            
        
        selfView.uploadTagsView.collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        SelectTagsBottmSheet.selfView.tagCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        SelectTagsBottmSheet.selfView.mbtiCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.merge([
            selfView.uploadTagsView.actionButton.rx.tap.asObservable(),
            selfView.uploadVoteView.actionButton.rx.tap.asObservable(),
            selfView.uploadPhotoView.actionButton.rx.tap.asObservable(),
            selfView.uploadTagsView.closeButton.rx.tap.asObservable(),
            selfView.uploadVoteView.closeButton.rx.tap.asObservable(),
            selfView.uploadPhotoView.closeButton.rx.tap.asObservable()
        ])
        .bind { [weak self] in
            self?.selfView.titleTextView.resignFirstResponder()
            self?.selfView.contentsTextView.resignFirstResponder()
        }
        .disposed(by: disposeBag)
        
        
        SelectTagsBottmSheet.selfView.completeButton.rx.tap
            .bind(to: didSelectTags)
            .disposed(by: disposeBag)
           
        selfView.uploadVoteView.actionButton.rx.tap.asObservable()
            .bind { [weak self] in
                self?.selfView.uploadVoteView.showVoteView(show: true)
            }
            .disposed(by: disposeBag)


        SelectTagsBottmSheet.selfView.tagCollectionView.rx
                  .modelSelected(FeedCategory.self)
                  .bind(to: didSelectCategory)
                  .disposed(by: disposeBag)
        
        SelectTagsBottmSheet.selfView.mbtiCollectionView.rx
                   .modelSelected(MBTIType.self)
                   .bind(to: didSelectMBTI)
                   .disposed(by: disposeBag)
        
        selfView.uploadTagsView.collectionView.rx
            .modelSelected(String.self)
             .filter { $0 == self.viewModel.viewMoreButtonTitle }
             .map { _ in }
             .bind { [weak self] in
                 self?.selfView.endEditing(true)
                 didSelectEditTags.onNext(())
             }
             .disposed(by: disposeBag)
        
        // 컨텐트 이미지뷰 바인딩
        
        selfView.uploadPhotoView.actionButton.rx.tap.asObservable()
            .bind { [weak self] in
                guard let self = self else { return }
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        imagePickerController.rx.didCancel.asObservable()
            .bind { [weak self] in
                guard let self = self else { return }
                Logger.printLog("hide Gallery")
                self.imagePickerController.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 바텀 시트 바인딩
        floatingVC.rx.didChangeState
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { floatingVC in
                switch floatingVC.state {
                case .tip:
                    floatingVC.hide(animated: true, completion: nil)

                default: return
                }
            })
            .disposed(by: disposeBag)
        
        // 키보드 바인딩
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive { [unowned self] height in
                selfView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
                isShownKeyboard = height > 0
            }
            .disposed(by: disposeBag)
    
        //MARK:  OUTPUT
        
        let output = viewModel.transform(input: UploadFeedViewModel.Input(titleDidChange: titleDidChange,
                                                                          contentDidChange: contentDidChange,
                                                                          didSelectImage: didSelectImage,
                                                                          tapRemoveImage: tapRemoveImage,
                                                                          tapCreateVoteContent: tapCreateVoteContent,
                                                                          tapAddVoteContent: tapAddVoteContent,
                                                                          voteTitleDidChange: voteTitleDidChange,
                                                                          voteContentDidChange: voteContentDidChange,
                                                                          tapRemoveVoteContent: tapRemoveVoteContent,
                                                                          tapRemoveAllVoteContnet: tapRemoveAllVoteContnet,
                                                                          tapShowTagsPage: tapShowTagsPage,
                                                                          didSelectTags: didSelectTags.asObservable(),
                                                                          didSelectCategory: didSelectCategory,
                                                                          didSelectMBTI: didSelectMBTI,
                                                                          didSelectEditTags: didSelectEditTags,
                                                                          tapRemoveTags: tapRemoveTags,
                                                                          tapFeedUpload: tapFeedUpload))
        
        //MARK: Feed
        
        output.editedFeed
            .take(1)
            .bind { [weak self] editedFeed in
                guard let self = self,
                let feed = editedFeed else { return }
                self.selfView.configureUI(feed: feed)
            }
            .disposed(by: disposeBag)

        output.selectedImages
            .filter { $0.count > 0 }
            .bind { [weak self] images in
                self?.selfView.uploadPhotoView.showImageView(show: true, image: images.first!)
                self?.imagePickerController.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        output.removeImage
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.selfView.uploadPhotoView.showImageView(show: false, image: nil)
            })
            .disposed(by: disposeBag)
        
        //MARK: Vote
        
//        output.showVoteContent
//            .asDriver(onErrorJustReturn: ())
//            .drive(onNext: { [weak self] in
//                self?.selfView.uploadVoteView.showVoteView(show: true)
//            })
//            .disposed(by: disposeBag)
        
        output.removeVoteContent
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.selfView.uploadVoteView.showVoteView(show: false)
            })
            .disposed(by: disposeBag)
        
        output.updateVoteTitle
            .bind { [weak self] title in
                self?.selfView.uploadVoteView.updateVoteContentsHeight()
            }
            .disposed(by: disposeBag)
   
        output.voteContentList
            .asDriver(onErrorJustReturn: [])
            .drive(selfView.uploadVoteView.createVoteView.tableView.rx.items(cellIdentifier: CreateVoteCell.identifier,
                                                                              cellType: CreateVoteCell.self)) { index, contents, cell in
                cell.configureUI(text: contents)
                cell.contentsTextView.rx.text.orEmpty
                    .bind { [weak self] text in
                        voteContentDidChange.onNext((index, text))
                        
                    
                        UIView.setAnimationsEnabled(false)
                        self?.selfView.uploadVoteView.createVoteView.tableView.beginUpdates()
                        self?.selfView.uploadVoteView.createVoteView.tableView.endUpdates()
                        UIView.setAnimationsEnabled(true)
                        
                        self?.selfView.uploadVoteView.updateVoteContentsHeight()
                    }.disposed(by: cell.disposeBag)
                
                cell.removeButton.rx.tap
                    .map { index }
                    .bind(to: tapRemoveVoteContent)
                    .disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
        
       
        //MARK: Tags
        
        output.showTagsPage
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.floatingVC.show(animated: true)
                self?.SelectTagsBottmSheet.selfView.updateTagCollectionLayout()
                self?.SelectTagsBottmSheet.selfView.updateMBTICollectionLayout()
            })
            .disposed(by: disposeBag)
        
        output.hideTagsPage
            .bind { [weak self] in
                self?.floatingVC.hide(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.removeTags
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.selfView.uploadTagsView.showTagButton(show: false)
                self?.selfView.uploadTagsView.setNeedsLayout()
            })
            .disposed(by: disposeBag)

        output.allCategories
            .bind(to: SelectTagsBottmSheet.selfView.tagCollectionView.rx.items(cellIdentifier: FeedCategoryCell.identifier,
                                                                    cellType: FeedCategoryCell.self)) { index, category, cell in
                cell.configureUI(feedCategory: category, isSelected: false)

                output.selectedCategories
                    .asDriver(onErrorJustReturn: [])
                    .drive(onNext: { selectedCategories in
                        let isSelected = selectedCategories.contains(where: { $0.rawValue == category.rawValue })
                        cell.selectCategory(isSelected: isSelected)
                    }).disposed(by: cell.disposeBag)

            }.disposed(by: disposeBag)

        output.allMBTIs
            .bind(to: SelectTagsBottmSheet.selfView.mbtiCollectionView.rx.items(cellIdentifier: FeedMBTICell.identifier,
                                                                     cellType: FeedMBTICell.self)) { index, mbti, cell in
                cell.configureUI(mbtiType: mbti)
                output.selectedMBTIs
                    .asDriver(onErrorJustReturn: [])
                    .drive(onNext: { selectedMBTIs in
                        let isSelected = selectedMBTIs.contains(where: { $0 == mbti })
                        cell.selectCategory(isSelected: isSelected)
                    }).disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)

        output.selectedTags
            .asDriver(onErrorJustReturn: [])
            .drive(selfView.uploadTagsView.collectionView.rx.items(cellIdentifier: BaseTagCell.cellIdentifier,
                                                                              cellType: BaseTagCell.self)) { [weak self] index, tagText, cell in
                if tagText == self?.viewModel.viewMoreButtonTitle {
                    cell.configureViewMoreButton(text: tagText)
                } else {
                    cell.configureUI(text: tagText, isSelected: true)
                }
            }.disposed(by: disposeBag)

        output.selectedTags
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] tags in
                let show = tags.count > 0
                self?.selfView.uploadTagsView.showTagButton(show: show)
            })
            .disposed(by: disposeBag)

        //MARK: Upload Button
        
        output.uploadButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(selfView.completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showUploadPage
            .bind { [weak self] feed in
                VillageNotificationCenter.fetchFeed.post()
                self?.backBarButtonItem.title = "게시물 보기"
                self?.coordinator?.pushDetailFeedScene(feed: feed)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension UploadFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == SelectTagsBottmSheet.selfView.tagCollectionView {
            return BaseTagCell.fittingsize(text: FeedCategory.allCases[indexPath.row].title)
        } else if collectionView == SelectTagsBottmSheet.selfView.mbtiCollectionView {
            return BaseTagCell.fittingsize(text: MBTIType.allCases[indexPath.row].emojiTitle)
        } else if collectionView == selfView.uploadTagsView.collectionView {
            return BaseTagCell.fittingsize(text: viewModel.selectedTags.value[indexPath.row])
        }
        return .zero
    }
}

//MARK: - UploadFeedViewController

extension UploadFeedViewController {
    class MyFloatingPanelLayout: FloatingPanelLayout {
        var position: FloatingPanelPosition {
            return .bottom
        }
        
        var initialState: FloatingPanelState {
            return .full
        }
        
        var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 40, edge: .top, referenceGuide: .safeArea),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: 200, edge: .bottom, referenceGuide: .safeArea),
            ]
        }
    }
}

//MARK: - UIGestureRecognizerDelegate

extension UploadFeedViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: selfView.uploadTagsView.collectionView) == false else { return false }
        return true
    }
}
