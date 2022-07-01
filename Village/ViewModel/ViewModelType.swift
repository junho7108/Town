import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Dependencies
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
    
    init(dependencies: Dependencies)
}
