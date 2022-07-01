import Alamofire
import RxSwift

protocol UserRepositoryType: AnyObject {
    func fetchUser() -> Single<NetworkResult<User>>
    func accountWithdrawal()  -> Single<NetworkResult<Bool>>
}

class UserRepositoryImpl: UserRepositoryType {
    
    private let service: NetworkService
    
    init(service: NetworkService = NetworkService()) {
        self.service = service
    }
    
    func fetchUser() -> Single<NetworkResult<User>> {
        return service.loadSingle(request: UserRouter.fetchUser)
    }
    
    func accountWithdrawal() -> Single<NetworkResult<Bool>> {
        return service.delete(request: UserRouter.accountWithdrawal)
    }
}
