import Foundation

struct UserFeed: Codable {
    var id: Int
    var email: String
    var nickname: String
    var birthDate: String
    var gender: Gender
    var mbtiType: MBTIType
    var feeds: [Feed]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case nickname = "nickname"
        case birthDate = "birth_date"
        case gender = "gender"
        case mbtiType = "mbti_indices"
        case feeds = "posts"
    }
}
