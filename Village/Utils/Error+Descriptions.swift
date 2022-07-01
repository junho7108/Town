import Foundation

protocol ErrorResponse: Codable { }

struct VillageErrorResponse: ErrorResponse {
    let code: String
    let error: String
    
    func errorType() -> VillageError {
        let error = VillageError.init(rawValue: code)!
        return error
    }
}

enum VillageError: String, Error {
    case serverError = "-1"
    case failUploadFormData = "-2"
    case decodingFailError = "-3"
    case missingEmail = "VAE0003"
    case socialTokenAuthFail = "VAE0004"
    case emptyNickname = "VAE0005"
    case duplicateNickname = "VAE0006"
    case unregisteredUser = "VAE0007"
}

extension VillageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingEmail: return "토큰 정보에 이메일이 없습니다."
        case .socialTokenAuthFail: return "토큰 검증에 실패하였습니다."
        case .decodingFailError: return "디코딩에 실패하였습니다."
        case .emptyNickname: return "닉네임이 공백문자입니다."
        case .duplicateNickname: return "이미 사용중인 닉네임입니다."
        case .serverError: return "서버 에러입니다"
        case .unregisteredUser: return "등록되지 않은 사용자입니다."
        case .failUploadFormData: return "FormData 업로드 요청에 실패하였습니다."
        }
    }
}
