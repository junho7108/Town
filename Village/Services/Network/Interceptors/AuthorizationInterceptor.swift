import Alamofire

final class AuthorizationInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        if let userAuthorization = KeyChainManager.loadUserAuthorization() {
            request.headers.add(HTTPHeader(name: "Authorization", value: userAuthorization.accessToken))
            request.headers.add(HTTPHeader(name: "Refresh-Token", value: userAuthorization.refreshToken))
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
