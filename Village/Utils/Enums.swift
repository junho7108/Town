import CoreText
import RxDataSources

//MARK: - BackgroundColorType

enum BackgroundColorType {
    case white
    case grey
}

//MARK: - MBTI

enum MBTICase: String, Codable {
    case INTJ = "INTJ"
    case INTP = "INTP"
    case ENTJ = "ENTJ"
    case ENTP = "ENTP"
    case INFJ = "INFJ"
    case INFP = "INFP"
    case ENFJ = "ENFJ"
    case ENFP = "ENFP"
    case ISTJ = "ISTJ"
    case ISFJ = "ISFJ"
    case ESTJ = "ESTJ"
    case ESFJ = "ESFJ"
    case ISTP = "ISTP"
    case ISFP = "ISFP"
    case ESTP = "ESTP"
    case ESFP = "ESFP"
}

 
//MARK: - FeedCategory

enum FeedCategory: String, CaseIterable, Codable {
    case daily = "ct001"
    case hobby = "ct002"
    case date = "ct003"
    case worry = "ct004"
    case shopping = "ct005"
    case finance = "ct006"
    case friendship = "ct007"
    case trip = "ct008"
    case diet = "ct009"
    case question = "ct010"
    
    enum CodingKeys: String, CodingKey {
        case daily = "ct001"
        case hobby = "ct002"
        case date = "ct003"
        case worry = "ct004"
        case shopping = "ct005"
        case finance = "ct006"
        case friendship = "ct007"
        case trip = "ct008"
        case diet = "ct009"
        case question = "ct010"
    }
}

//MARK: - Gender

enum Gender: String, Codable {
    case male = "M", female = "F", none = "N"

    enum CodingKeys: String, CodingKey {
        case male = "M"
        case female = "F"
        case none = "N"
    }
}

//MARK: - VillageSettingOption

enum VillageSettingOption: Int, CaseIterable {
    case myFeed = 0, likedFeed, hiddenFeed, savedFeed
//    case appVersion, notice, FAQ, bugInquiry, appEvaluate, appShare
    case TOS, privacyPoliccy
    case logout, withdrawal
}

//MARK: - CommentType

enum CommentType {
    case comment
    case reply
}

//MARK: - NetworkResult

enum NetworkResult<T> {
    case success(T)
    case errorResponse(VillageErrorResponse)
}
