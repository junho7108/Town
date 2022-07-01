import Foundation
import UIKit

//MARK: - MBTICase

extension MBTICase {
    func mbtiType() -> MBTIType {
        switch self {
        case .INTJ: return MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J)
        case .INTP: return MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P)
        case .ENTJ: return MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J)
        case .ENTP: return MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P)
        case .INFJ: return MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J)
        case .INFP: return MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P)
        case .ENFJ: return MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J)
        case .ENFP: return MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P)
        case .ISTJ: return MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J)
        case .ISFJ: return MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J)
        case .ESTJ: return MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J)
        case .ESFJ: return MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J)
        case .ISTP: return MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P)
        case .ISFP: return MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P)
        case .ESTP: return MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P)
        case .ESFP: return MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P)
        }
    }
    
    func emojiTitle() -> String {
        switch self {
        case .INTJ: return "🤔 INTJ"
        case .INTP: return "🤖 INTP"
        case .ENTJ: return "😈 ENTJ"
        case .ENTP: return "🤓 ENTP"
        case .INFJ: return "☺️ INFJ"
        case .INFP: return "😭 INFP"
        case .ENFJ: return "😇 ENFJ"
        case .ENFP: return "😍 ENFP"
        case .ISTJ: return "😶 ISTJ"
        case .ISFJ: return "☺️ ISFJ"
        case .ESTJ: return "😐 ESTJ"
        case .ESFJ: return "😙 ESFJ"
        case .ISTP: return "🙄 ISTP"
        case .ISFP: return " 🤗 ISFP"
        case .ESTP: return "😎 ESTP"
        case .ESFP: return "😝 ESFP"
        }
    }
}

//MARK: - FeedCategory

extension FeedCategory {
    var title: String {
        switch self {
        case .daily: return "☁️ 일상"
        case .hobby: return "🕹 취미"
        case .date: return "💞 연애"
        case .worry: return "💬 고민상담"
        case .shopping: return "🛍️ 쇼핑"
        case .finance: return "📈 재테크"
        case .friendship: return "🤝 친구"
        case .trip: return "✈️ 여행"
        case .diet: return "🥗 다이어트"
        case .question: return "❓ 질문"
        }
    }
}

//MARK: - VillageSettingOption

extension VillageSettingOption {
    var title: String {
        switch self {

        case .myFeed: return "✏️ 작성한 글"
//        case .myComments: return "📝 작성한 댓글"
        case .likedFeed: return "💗 좋아한 글"
        case .hiddenFeed: return "📦 숨겨진 글"
        case .savedFeed: return "📚 저장한 글 "
            
//        case .appVersion: return "🤖 버전정보"
//        case .notice: return "📌 공지사항"
//        case .FAQ: return "❓ 자주 묻는 질문"
//        case .bugInquiry: return "🐞 버그 또는 문의"
//        case .appEvaluate: return "🎁 앱 평가하기"
//        case .appShare: return "➗ 앱 공유하기"
      
        case .TOS: return "📃 서비스 이용약관 "
        case .privacyPoliccy: return "🛡 개인정보 보호약관"
        case .logout: return "😴 로그아웃"
        case .withdrawal: return "🚪 회원 탈퇴"
        }
    }
    
    var indexPath: IndexPath {
        switch self {
        case .myFeed: return IndexPath(row: 0, section: 0)
//        case .myComments: return IndexPath(row: 1, section: 0)
        case .likedFeed: return IndexPath(row: 1, section: 0)
        case .hiddenFeed: return IndexPath(row: 2, section: 0)
        case .savedFeed: return IndexPath(row: 3, section: 0)
//
//        case .appVersion: return IndexPath(row: 0, section: 1)
//        case .notice: return IndexPath(row: 1, section: 1)
//        case .FAQ: return IndexPath(row: 2, section: 1)
//        case .bugInquiry: return IndexPath(row: 3, section: 1)
//        case .appEvaluate: return IndexPath(row: 4, section: 1)
//        case .appShare: return IndexPath(row: 5, section: 1)
            
//        case .TOS: return IndexPath(row: 0, section: 2)
//        case .privacyPoliccy:  return IndexPath(row: 1, section: 2)
//
//        case .logout:  return IndexPath(row: 0, section: 3)
//        case .withdrawal:  return IndexPath(row: 1, section: 3)
            
            
        case .TOS: return IndexPath(row: 0, section: 1)
        case .privacyPoliccy:  return IndexPath(row: 1, section: 1)
            
        case .logout:  return IndexPath(row: 0, section: 2)
        case .withdrawal:  return IndexPath(row: 1, section: 2)
        }
    }
    
    static var sections: [[VillageSettingOption]] {
        return [
//            [.myFeed, .myComments, .likedFeed, .savedFeed],
//            [.appVersion, .notice, .FAQ, .bugInquiry, .appEvaluate, .appShare],
            [.myFeed, .likedFeed, .hiddenFeed, .savedFeed],
            [.TOS, .privacyPoliccy],
            [.logout, .withdrawal]
        ]
    }
}
