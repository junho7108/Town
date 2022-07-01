import Alamofire

enum UserRouter {
    case fetchUser
    case accountWithdrawal
}

extension UserRouter: APIRouter {
    var baseURL: String {
        return APIKey.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .fetchUser: return "/accounts/users/me/"
        case .accountWithdrawal: return "/accounts/users/me/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchUser: return .get
        case .accountWithdrawal: return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchUser: return [
            "Content-Type": "application/json",
           ]
            
        default: return nil
        }
    }
    
    var body: Data? {
        switch self {
        default: return nil
        }
    }
    
    var queries: [String : String]? {
        switch self {
        default: return nil
        }
    }
}
