import RxSwift
import RxCocoa

final class MoveVillageViewModel: ViewModelType {
    
    struct Input {
        let fetchUser: Observable<Void>
        let tapAllVilalge: Observable<Void>
        let tapVillage: Observable<MBTIType>
    }
    
    struct Output {
        let user: Observable<User>
        let villageSection: Observable<[VillageSection]>
        let showAllVilalge: Observable<[MBTIType]>
        let showVillage: Observable<MBTIType>
        let errorMessage: Observable<String>
        let activating: Observable<Bool>
    }
    
    struct Dependencies {
        let userUsecase: UserUsecase
    }
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        let userRelay = PublishRelay<User>()
        let villageSection = BehaviorRelay<[VillageSection]>(value: [VillageSection(items: MBTIType.allCases)])
        let showAllVilalge = PublishRelay<[MBTIType]>()
        let showVillage = input.tapVillage
        let errorMessage = PublishRelay<String>()
        let activating = BehaviorRelay<Bool>(value: false)
        
        input.fetchUser
            .do(onNext: { activating.accept(true)})
            .flatMap { [unowned self] in fetchUser() }
            .bind { [weak self] result in
                activating.accept(false)
                
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    userRelay.accept(user)
                    
                    let sortedMBTIs = self.sortMBTICasesByUser(userMBTI: user.mbti, allMBTICases: villageSection.value.first!.items)
                    villageSection.accept([VillageSection(items: sortedMBTIs)])
                    
                case .errorResponse(let errorResponse):
                    Logger.printLog(errorResponse)
                }
            }
            .disposed(by: disposeBag)
          
        input.tapAllVilalge
            .map { MBTIType.allCases }
            .bind(to: showAllVilalge)
            .disposed(by: disposeBag)
        
        return Output(user: userRelay.asObservable(),
                      villageSection: villageSection.asObservable(),
                      showAllVilalge: showAllVilalge.asObservable(),
                      showVillage: showVillage.asObservable(),
                      errorMessage: errorMessage.asObservable(),
                      activating: activating.asObservable())
    }
    
    private func fetchUser() -> Single<NetworkResult<User>> {
        return dependencies.userUsecase.fetchUser()
    }
    
    private func sortMBTICasesByUser(userMBTI: MBTIType, allMBTICases: [MBTIType]) -> [MBTIType] {
        var mbtis = allMBTICases
        
        if let firstIndex = mbtis.firstIndex(where: { $0 == userMBTI}) {
            mbtis.remove(at: firstIndex)
            mbtis.insert(userMBTI, at: 0)
            return mbtis
        }
        
        return []
    }
}
