import RxSwift
import RxRelay
import Accelerate
import Alamofire
import os

class UploadFeedViewModel: ViewModelType {
    
    struct Input {
        let titleDidChange: Observable<String>
        let contentDidChange: Observable<String>
        
        let didSelectImage: Observable<[UIImage]>
        let tapRemoveImage: Observable<Void>
        
        let tapCreateVoteContent: Observable<Void>
        let tapAddVoteContent: Observable<Void>
        let voteTitleDidChange: Observable<String>
        let voteContentDidChange: Observable<(Int, String)>
        let tapRemoveVoteContent: Observable<Int>
        let tapRemoveAllVoteContnet: Observable<Void>
        
        let tapShowTagsPage: Observable<Void>
        let didSelectTags: Observable<Void>
        let didSelectCategory: Observable<FeedCategory>
        let didSelectMBTI: Observable<MBTIType>
        let didSelectEditTags: Observable<Void>
        let tapRemoveTags: Observable<Void>
       
        let tapFeedUpload: Observable<Void>
    }
    
    struct Output {
        let editedFeed: Observable<Feed?>
        let updateContent: Observable<String>
        
        let selectedImages: Observable<[UIImage]>
        let removeImage: Observable<Void>
    
        let updateVoteTitle: Observable<String>
        let voteContentList: Observable<[String]>
        let removeVoteContent: Observable<Void>
        
        let showTagsPage: Observable<Void>
        let allCategories: Observable<[FeedCategory]>
        let selectedCategories: Observable<[FeedCategory]>
        let originFeedCategories: Observable<[FeedCategory]>
        let allMBTIs: Observable<[MBTIType]>
        let selectedMBTIs: Observable<[MBTIType]>
        let originMBTIs: Observable<[MBTIType]>
        let selectedTags: Observable<[String]>
        let hideTagsPage: Observable<Void>
        let removeTags: Observable<Void>
        
        let uploadButtonEnabled: Observable<Bool>
        let showUploadPage: Observable<Feed>
    }
    
    struct Dependencies {
        var feed: Feed? = nil
        let usecase: FeedUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    let viewMoreButtonTitle: String =  "+ 더보기"
    
    let selectedTags = BehaviorRelay<[String]>(value: [])
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        //MARK: Dependencies
        
        let dependenciesTitle = dependencies.feed?.title ?? ""
        let dependenciesContentTitle = dependencies.feed?.content ?? ""
        let dependenciesVoteTitle = dependencies.feed?.vote?.title ?? ""
        let dependenciesMBTICases = dependencies.feed?.taggedMBTIs ?? []
        let dependenciesCategories = dependencies.feed?.category ?? []
        //        let dependenciesVoteContentList = dependencies.feed?.vote?.choice
      
        
        var categoriesString: [String] = []
        var taggedMBTIString: [String] = []
        var dependenciesMBTIs: [MBTIType] = []
      
        dependenciesMBTICases.forEach { dependenciesMBTIs.append($0.mbtiType())}
        dependenciesCategories.forEach { categoriesString.append($0.title)}
        dependenciesMBTIs.forEach { taggedMBTIString.append($0.title)}
   
        // 선택 된 태그가 1개 이상일 시에는, 더보기 버튼 추가
        
        if categoriesString.count + taggedMBTIString.count > 0 {
            self.selectedTags.accept(categoriesString + taggedMBTIString + [viewMoreButtonTitle])
        } else {
            self.selectedTags.accept(categoriesString + taggedMBTIString)
        }
     
        //MARK: Output
        
        let editedFeedRelay = BehaviorRelay<Feed?>(value: dependencies.feed)
        let updateContent = input.contentDidChange
    
        let selectedImages = BehaviorRelay<[UIImage]>(value: [])
        let removeImgae = input.tapRemoveImage

        let voteContentList = BehaviorRelay<[String]>(value: ["", ""])
        
        let showTagsPage = Observable.merge(input.tapShowTagsPage, input.didSelectEditTags)
        let updateVoteTitle = input.voteTitleDidChange
        let allCategories = Observable.of(FeedCategory.allCases)
        
        let selectedCategories = BehaviorRelay<[FeedCategory]>(value: dependenciesCategories)
        let originCategories = BehaviorRelay<[FeedCategory]>(value: dependenciesCategories)
        
        let allMBTIs = Observable.of(MBTIType.allCases)
        let selectedMBTIs = BehaviorRelay<[MBTIType]>(value: dependenciesMBTIs)
        let originMBTIs = BehaviorRelay<[MBTIType]>(value: dependenciesMBTIs)
        
        let hideTagsPage = PublishRelay<Void>()
        let removeVoteContent = PublishRelay<Void>()
        let removeTags = input.tapRemoveTags
        
        let uploadButtonEnabled = BehaviorRelay<Bool>(value: false)
        let showUploadPage: PublishRelay<Feed> = PublishRelay<Feed>()
        
        
        //MARK: Binds
        
        let titleRelay = BehaviorRelay<String>(value: dependenciesTitle)
        let contentRelay = BehaviorRelay<String>(value: dependenciesContentTitle)
        
        let voteTitleRelay = BehaviorRelay<String?>(value: dependenciesVoteTitle)
    
        let editedVoteContentList = BehaviorRelay<[String]>(value: voteContentList.value)
     
        input.titleDidChange
            .bind(to: titleRelay)
            .disposed(by: disposeBag)
        
        input.contentDidChange
            .bind(to: contentRelay)
            .disposed(by: disposeBag)
        
        input.didSelectImage
            .bind(to: selectedImages)
            .disposed(by: disposeBag)
        
        input.tapRemoveImage
            .bind { _ in
                Logger.printLog("이미지 삭제")
                selectedImages.accept([])
            }
            .disposed(by: disposeBag)
        
        input.tapRemoveAllVoteContnet
            .bind(to: removeVoteContent)
            .disposed(by: disposeBag)
        
        showTagsPage
            .bind { _ in
                selectedCategories.accept(originCategories.value)
                selectedMBTIs.accept(originMBTIs.value)
            }
            .disposed(by: disposeBag)
        
        input.tapAddVoteContent
            .bind { _ in
                var newVoteContents = editedVoteContentList.value
                newVoteContents.append("")
                voteContentList.accept(newVoteContents)
                editedVoteContentList.accept(newVoteContents)
            }
            .disposed(by: disposeBag)
        
        input.voteTitleDidChange
            .bind(to: voteTitleRelay)
            .disposed(by: disposeBag)
        
        input.voteContentDidChange
            .bind { voteKeyValue in
                var editVoteContents = editedVoteContentList.value
                editVoteContents[voteKeyValue.0] = voteKeyValue.1
                editedVoteContentList.accept(editVoteContents)
            }
            .disposed(by: disposeBag)
        
        input.tapRemoveVoteContent
            .bind { index in
                var newVoteContents = editedVoteContentList.value
                newVoteContents.remove(at: index)
                voteContentList.accept(newVoteContents)
                editedVoteContentList.accept(newVoteContents)
                if newVoteContents.count <= 0 {
                    removeVoteContent.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        removeVoteContent
            .bind { _ in
                let defaultVote: [String] = ["", ""]
                voteTitleRelay.accept(nil)
                voteContentList.accept(defaultVote)
                editedVoteContentList.accept(defaultVote)
            }
            .disposed(by: disposeBag)
        
        input.didSelectCategory
            .flatMap { category -> Observable<[FeedCategory]> in
                var selectedFeedCategories = selectedCategories.value
                if let firstIndex = selectedFeedCategories.firstIndex(where: { $0.rawValue == category.rawValue}) {
                    selectedFeedCategories.remove(at: firstIndex)
                } else {
                    selectedFeedCategories.append(category)
                }
                return Observable.of(selectedFeedCategories)
            }
            .bind(to: selectedCategories)
            .disposed(by: disposeBag)
        
   
        input.didSelectMBTI
            .flatMap { mbti -> Observable<[MBTIType]> in
                var selectedMBTIs = selectedMBTIs.value
                if let firstIndex = selectedMBTIs.firstIndex(where: { $0 == mbti}) {
                    selectedMBTIs.remove(at: firstIndex)
                } else {
                    selectedMBTIs.append(mbti)
                }
                return Observable.of(selectedMBTIs)
            }
            .bind(to: selectedMBTIs)
            .disposed(by: disposeBag)
        
     
        input.didSelectTags
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                originCategories.accept(selectedCategories.value)
                originMBTIs.accept(selectedMBTIs.value)
              
                var tagArray: [String] = []
                selectedCategories.value.forEach { tagArray.append($0.title) }
                selectedMBTIs.value.forEach { tagArray.append($0.emojiTitle) }
                
                if tagArray.count > 0 {
                    tagArray.append(self.viewMoreButtonTitle)
                }
        
                self.selectedTags.accept(tagArray)
                hideTagsPage.accept(())
            })
            .disposed(by: disposeBag)
        
        input.tapRemoveTags
            .bind { [weak self] _ in
                originMBTIs.accept([])
                selectedMBTIs.accept([])
                
                originCategories.accept([])
                selectedCategories.accept([])
                
                self?.selectedTags.accept([])
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.titleDidChange.asObservable(),
                                 input.contentDidChange.asObservable(),
                                 selectedTags.asObservable()) { (title, content, tags) -> Bool in
            
            return !title.isEmpty && !content.isEmpty &&
            selectedMBTIs.value.count > 0 && selectedCategories.value.count > 0
            
        }.bind(to: uploadButtonEnabled)
            .disposed(by: disposeBag)
        
        input.tapFeedUpload
            .flatMap { [unowned self] _ -> Single<NetworkResult<Feed>> in
                var taggedMBTIs: [String] = []
                var category: [String] = []
                
                selectedCategories.value.forEach { category.append($0.rawValue)}
                selectedMBTIs.value.forEach { taggedMBTIs.append($0.title)}
                
                var voteContentsString = ""
                
                for (index, elem) in editedVoteContentList.value.enumerated() {
                    voteContentsString.append(contentsOf: elem)
                    if index < editedVoteContentList.value.count - 1 && !elem.isEmpty {
                        voteContentsString.append(contentsOf: ",")
                    }
                }
                                                     
                let request = UploadFeedRequest(category: category,
                                                taggedMBTIs: taggedMBTIs,
                                                title: titleRelay.value,
                                                content: contentRelay.value,
                                                voteTitle: voteTitleRelay.value ?? nil,
                                                voteContents: voteContentsString == "" ? nil : voteContentsString)
                
                let images = selectedImages.value
                
                if let feed = dependencies.feed {
                    return EditFeed(feed: feed, request: request, images: images)
                } else {
                    return uploadFeed(request: request, images: images)
                }
            }
            .bind(onNext: { result in
                switch result {
                case .success(let feed):
                    Logger.printLog("게시글 업로드 성공: \(feed)")
                    showUploadPage.accept(feed)
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog("게시물 업로드 실패: \(errorResponse)")
                }
            })
            .disposed(by: disposeBag)
        
        //MARK: Output
        
        return Output(editedFeed: editedFeedRelay.asObservable(),
                      updateContent: updateContent.asObservable(),
    
                      selectedImages: selectedImages.asObservable(),
                      removeImage: removeImgae.asObservable(),
                      
//                      showVoteContent: showVoteContent.asObservable(),
                      updateVoteTitle: updateVoteTitle.asObservable(),
                      voteContentList: voteContentList.asObservable(),
                      removeVoteContent: removeVoteContent.asObservable(),
                      
                      showTagsPage: showTagsPage.asObservable(),
                      allCategories: allCategories.asObservable(),
                      selectedCategories: selectedCategories.asObservable(),
                      originFeedCategories: originCategories.asObservable(),
                      allMBTIs: allMBTIs.asObservable(),
                      selectedMBTIs: selectedMBTIs.asObservable(),
                      originMBTIs: originMBTIs.asObservable(),
                      selectedTags: selectedTags.asObservable(),
                      hideTagsPage: hideTagsPage.asObservable(),
                      removeTags: removeTags.asObservable(),
                      
                      uploadButtonEnabled: uploadButtonEnabled.asObservable(),
                      showUploadPage: showUploadPage.asObservable())
    }
    
    //MARK: - Helpers
    
    func categoryArray(category: [FeedCategory]) -> [String] {
        var categoryArray: [String] = []
        
        category.forEach { category in
            categoryArray.append(category.rawValue)
        }
        
        return categoryArray
    }
    
    //MARK: - API
    
    private func uploadFeed(request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>> {
        return dependencies.usecase.uploadFeed(request: request, images: images)
    }
    
    private func EditFeed(feed: Feed, request: UploadFeedRequest, images: [UIImage]) -> Single<NetworkResult<Feed>> {
        return dependencies.usecase.edityFeed(feed: feed, request: request, images: images)
    }
}
