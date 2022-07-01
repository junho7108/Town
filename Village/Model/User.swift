import Foundation

struct User: Codable {
    let id: Int
    let email: String
    var nickname: String
    var birthDateString: String
    var gender: Gender
    var mbti: MBTIType
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case nickname = "nickname"
        case birthDateString = "birth_date"
        case gender = "gender"
        case mbti = "mbti_indices"
    }
}
