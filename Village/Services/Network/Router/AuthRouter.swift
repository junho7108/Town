import Foundation
import Alamofire

struct SignUpRequest: Encodable {
    var accessToken: String?
    var provider: SocialLoginType?
    var nickname: String?
    var birthDateString: String?
    var gender: Gender?

    var mbtiType: MBTIType?
    var mbtiEnergy: MBTIEnergy?
    var mbtiInformation: MBTIInformation?
    var mbtiDecisions: MBTIDecisions?
    var mbtiLifestyle: MBTILifestyle?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_Token"
        case provider = "provider"
        case nickname = "nickname"
        case birthDateString = "birth_date"
        case gender = "gender"
        case mbtiType = "mbti_type"
        case mbtiEnergy = "mbti_index_0"
        case mbtiInformation = "mbti_index_1"
        case mbtiDecisions = "mbti_index_2"
        case mbtiLifestyle = "mbti_index_3"
    }
}

enum AuthRouter {
    case signIn(accessToken: String, provider: SocialLoginType)
    case signUp(reqeust: SignUpRequest)
    case checkNickname(nickname: String)
}

extension AuthRouter: APIRouter {
    
    var baseURL: String {  return APIKey.baseURL }
    
    var endPoint: String {
        switch self {
        case .signIn: return "/accounts/social/signin/"
        case .signUp: return "/accounts/social/signup/"
        case .checkNickname: return "/accounts/nickname/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signIn, .signUp: return .post
        case .checkNickname: return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signIn, .signUp: return [
            "Content-Type": "application/json",
            "Cookie": ""
        ]
            
        default: return nil
        }
    }
    
    var body: Data?  {
        switch self {
        case .signIn(let accessToken, let provider):
            struct SignInRequest: Encodable {
                let accessToken: String
                let provider: String
                
                enum CodingKeys: String, CodingKey {
                    case accessToken = "access_token"
                    case provider = "provider"
                }
            }
        
            let request = SignInRequest(accessToken: accessToken, provider: provider.rawValue)
            return try? JSONEncoder().encode(request)
          
        case .signUp(let request):
            struct Body: Encodable {
                let access_token: String
                let provider: SocialLoginType
                let nickname: String
                let birth_date: String
                let gender: Gender
                let mbti_type: String
                let mbti_index_0: MBTIEnergy
                let mbti_index_1: MBTIInformation
                let mbti_index_2: MBTIDecisions
                let mbti_index_3: MBTILifestyle
            }
            
            let body = Body(access_token: request.accessToken!,
                                         provider: request.provider!,
                                         nickname: request.nickname!,
                                         birth_date: request.birthDateString!,
                                         gender: request.gender!,
                                         mbti_type: request.mbtiType!.title,
                                         mbti_index_0: request.mbtiEnergy!,
                                         mbti_index_1: request.mbtiInformation!,
                                         mbti_index_2: request.mbtiDecisions!,
                                         mbti_index_3: request.mbtiLifestyle!)
            
            return try? JSONEncoder().encode(body)
          
        default: return nil
        }
    }
    
    var queries: [String : String]?  {
        switch self {
        case .checkNickname(let nickname): return ["nickname": nickname]
        default: return nil
        }
    }
}
