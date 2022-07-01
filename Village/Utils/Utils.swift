import UIKit

class Utils {
    static func version() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    static func mbtiNickname(user: User,
                             font: UIFont = .suitFont(size: 17, weight: .bold),
                             textColor: UIColor = .villageSky) -> NSAttributedString {
        let nickname = NSMutableAttributedString(string: "\(user.nickname) ", attributes: [.font: font])
        
        nickname.append(NSAttributedString(string: user.mbti.nickname, attributes: [.font: font,
                                                                                    .foregroundColor: textColor]))
        
        return nickname
    }
    
    static func nowDate() -> Date {
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let now = Date()
        let nowString = now.toString(dateformatter: nil)
        let nowDate = df.date(from: nowString)
        return nowDate!
    }
    
    static func timeInterval(startDate: Date) -> TimeInterval {
        return nowDate().timeIntervalSince(startDate)
    }
    
    static func timeStamp(timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval / 3600)
        let minutes = Int(timeInterval / 60)
        
        if hours < 1 {
            if minutes == 0 {
                return "방금"
            } else {
                return "\(minutes)분 전"
            }
        } else {
            return "\(hours)시간 전"
        }
    }
}

