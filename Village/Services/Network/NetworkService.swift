import Alamofire
import RxSwift
import Foundation

protocol NetworkServiceType {
    func loadSingle<T: Codable>(request: URLRequestConvertible) -> Single<NetworkResult<T>>
}

final class NetworkService: NetworkServiceType {
   
    private(set) var session: Session
    
    init(with session: Session = .default) {
        self.session = session
    }
    
    func delete(request: URLRequestConvertible) -> Single<NetworkResult<Bool>> {
        return Single.create { [unowned self] single in
            
            let request = session.request(request)
                .response { result in
                    let statusCode = result.response?.statusCode
                    
                    if let statusCode = statusCode {
                        if 200..<300 ~= statusCode {
                            single(.success(.success(true)))
                        } else {
                            single(.success(.errorResponse(.init(code: VillageError.decodingFailError.rawValue,
                                                                 error: VillageError.decodingFailError.localizedDescription))))
                        }
                    } else {
                        
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func loadSingle<E>(url: String, httpMethod: HTTPMethod) -> Single<NetworkResult<E>> where E: Decodable {
        return Single.create { [unowned self] single in
            let decoder = JSONDecoder()
         
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            let request = session.request(url, method: httpMethod)
                .responseDecodable(of: E.self, decoder: decoder) { result in
                
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
  
    func loadSingle<T>(request: URLRequestConvertible) -> Single<NetworkResult<T>> where T: Decodable {
        return Single.create { [unowned self] single in
            let decoder = JSONDecoder()
         
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            let request = session.request(request)
                .responseDecodable(of: T.self, decoder: decoder) { result in
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                     
                    case .failure(let error):
                        if let data = result.data,
                           let errorResponse = try? JSONDecoder().decode(VillageErrorResponse.self, from: data) {
                            single(.success(.errorResponse(errorResponse)))
                        } else {
                            single(.success(.errorResponse(.init(code: "-1", error: error.localizedDescription))))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
