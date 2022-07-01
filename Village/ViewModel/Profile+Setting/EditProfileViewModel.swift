import RxSwift
import RxRelay

class EditProfileViewModel: ViewModelType {
    
    struct Input {
        var tapMBTIEnergy: Observable<MBTIEnergy>
        var tapMBTIInformation: Observable<MBTIInformation>
        var tapMBTIDecisions: Observable<MBTIDecisions>
        var tapMBTILifestyle: Observable<MBTILifestyle>
        
        var tapEditMBTI: Observable<Void>
        
        var tapEditNickname: Observable<String>
        var tapEditDate: Observable<String>
        var tapEditGender: Observable<Gender>
        var tapComplete: Observable<Void>
    }
    
    struct Output {
        var showMBTIBottomSheetPage: Observable<Void>
        
        var editedNickname: Observable<String>
        var editedMBTI: Observable<MBTIType>
        var editedDate: Observable<String>
        var editedGender: Observable<Gender>
        
        var editEnabled: Observable<Bool>
    }
    
    struct Dependencies {
        var user: User
    }
    
    //MARK: - Properties
    
    var disposeBag: DisposeBag = .init()
    
    let dependencies: Dependencies
    
    private lazy var user = BehaviorRelay<User>(value: dependencies.user)

    //MARK: - Lifecycles
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - Helpers
    
    func transform(input: Input) -> Output {
        
        let editedMBTI = BehaviorRelay<MBTIType>(value: user.value.mbti)
        
        let editEnabled = PublishSubject<Bool>()
        
        Observable.merge([
            input.tapMBTIEnergy.map { MBTIType(firstIndex: $0,
                                                                 secondIndex: editedMBTI.value.secondIndex,
                                                                 thirdIndex: editedMBTI.value.thirdIndex,
                                                                 lastIndex: editedMBTI.value.lastIndex)},
            
            input.tapMBTIInformation.map { MBTIType(firstIndex: editedMBTI.value.firstIndex,
                                                                      secondIndex: $0,
                                                                      thirdIndex: editedMBTI.value.thirdIndex,
                                                                      lastIndex: editedMBTI.value.lastIndex)},
            
            input.tapMBTIDecisions.map { MBTIType(firstIndex: editedMBTI.value.firstIndex,
                                                                    secondIndex: editedMBTI.value.secondIndex,
                                                                    thirdIndex: $0,
                                                                    lastIndex: editedMBTI.value.lastIndex)},
            
            input.tapMBTILifestyle.map { MBTIType(firstIndex: editedMBTI.value.firstIndex,
                                                                    secondIndex: editedMBTI.value.secondIndex,
                                                                    thirdIndex: editedMBTI.value.thirdIndex,
                                                                    lastIndex: $0)}
        ])
            .bind(to: editedMBTI)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.tapEditDate
                .map { [weak self] in $0 != self?.user.value.birthDateString }
                .startWith(false),
            input.tapEditGender
                .map { [weak self] in $0 != self?.user.value.gender }
                .startWith(false),
            
            input.tapEditNickname
                .map { [weak self] in $0 != self?.user.value.nickname }
                .startWith(false),
            
            editedMBTI
                .map { [weak self] in $0 != self?.user.value.mbti }
                .startWith(false)) { date, gender, nickname, mbti in
                    return date || gender || nickname || mbti
                }
                .bind(to: editEnabled)
                .disposed(by: disposeBag)
                
        
     
        
        return Output(showMBTIBottomSheetPage: input.tapEditMBTI.asObservable(),
                      editedNickname: input.tapEditNickname.asObservable(),
                      editedMBTI: editedMBTI.asObservable(),
                      editedDate: input.tapEditDate.asObservable(),
                      editedGender: input.tapEditGender.asObservable(),
                      editEnabled: editEnabled.asObservable())
    }
}
