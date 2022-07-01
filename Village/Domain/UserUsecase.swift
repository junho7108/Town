import Foundation
import RxSwift

class UserUsecase {
    private let repository: UserRepositoryType
    
    init(repository: UserRepositoryType) {
        self.repository = repository
    }
    
    func fetchUser() -> Single<NetworkResult<User>> {
        return repository.fetchUser()
    }
    
    func accountWithdrawal() -> Single<NetworkResult<Bool>> {
        return repository.accountWithdrawal()
    }
}
