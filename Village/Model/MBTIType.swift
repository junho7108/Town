import UIKit
import Differentiator

enum MBTIEnergy: String, Codable {
    case E,I
}

enum MBTIInformation: String, Codable {
    case N,S
}

enum MBTIDecisions: String, Codable {
    case T,F
}

enum MBTILifestyle: String, Codable {
    case J,P
}

struct MBTIType: Codable, Equatable {
    var firstIndex: MBTIEnergy
    var secondIndex: MBTIInformation
    var thirdIndex: MBTIDecisions
    var lastIndex: MBTILifestyle
    
    enum CodingKeys: String, CodingKey {
        case firstIndex = "mbti_index_0"
        case secondIndex = "mbti_index_1"
        case thirdIndex = "mbti_index_2"
        case lastIndex = "mbti_index_3"
    }
}

extension MBTIType: IdentifiableType {
    var identity: String {
        return self.title
    }
}

extension MBTIType {
    
    static var allCases: [MBTIType] {
        return [
            MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
            MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
            MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
            MBTIType(firstIndex: .E, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
            
            MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .P),
            MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .F, lastIndex: .J),
            MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .P),
            MBTIType(firstIndex: .I, secondIndex: .N, thirdIndex: .T, lastIndex: .J),
            
            MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
            MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
            MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
            MBTIType(firstIndex: .E, secondIndex: .S, thirdIndex: .T, lastIndex: .J),
            
            MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .P),
            MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .P),
            MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .F, lastIndex: .J),
            MBTIType(firstIndex: .I, secondIndex: .S, thirdIndex: .T, lastIndex: .J)
        ]
    }
    
    var title: String {
        return "\(firstIndex.rawValue)\(secondIndex.rawValue)\(thirdIndex.rawValue)\(lastIndex.rawValue)"
    }
    
    var emojiTitle: String {
        switch firstIndex {
        case .E:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "😈 ENTJ"
                    case .P: return "🤓 ENTP"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "😇 ENFJ"
                    case .P: return "😍 ENFP"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "😐 ESTJ"
                    case .P: return "😎 ESTP"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "😙 ESFJ"
                    case .P: return "😝 ESFP"
                        
                    }
                }
            }
            
        case .I:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "🤔 INTJ"
                    case .P: return "🤖 INTP"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "☺️ INFJ"
                    case .P: return "😭 INFP"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "😶 ISTJ"
                    case .P: return "🙄 ISTP"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "☺️ISFJ"
                    case .P: return "🤗 ISFP"
                        
                    }
                }
            }
        }
    }
    
    var nickname: String {
        switch firstIndex {
        case .E:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "엔티제"
                    case .P: return "엔팁"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "엔프제"
                    case .P: return "엔프피"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "엣티제"
                    case .P: return "엣팁"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "엣프제"
                    case .P: return "엣프피"
                        
                    }
                }
            }
            
        case .I:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "인티제"
                    case .P: return "인팁"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "인프제"
                    case .P: return "인프피"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "잇티제"
                    case .P: return "잇팁"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "잇프제"
                    case .P: return "잇프피"
                        
                    }
                }
            }
        }
    }
    
    var nicknameSuffix: String {
        switch firstIndex {
        case .E:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "이야"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "야"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "이야"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "야"
                        
                    }
                }
            }
            
        case .I:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "이야"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "야"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "이야"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "야"
                    case .P: return "야"
                        
                    }
                }
            }
        }
    }
    
    var placeholder: String {
        switch firstIndex {
        case .E:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "과하게솔직한"
                    case .P: return "직진만하는"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "의리가넘치는"
                    case .P: return "초긍정적인"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "빈틈이없는"
                    case .P: return "관심받고싶은"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "계속떠드는"
                    case .P: return "에너지넘치는"
                        
                    }
                }
            }
            
        case .I:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "도전을즐기는"
                    case .P: return "표현이서툰"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "마음이따뜻한"
                    case .P: return "사랑받고싶은"
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return "혼자가편한"
                    case .P: return "척척박사인"
                    }
                case .F:
                    switch lastIndex {
                    case .J: return "인내심이많은"
                    case .P: return "집에만있는"
                        
                    }
                }
            }
        }
    }
    
    var mbtiColor: UIColor {
        switch firstIndex {
        case .E:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#2F63E8")
                    case .P: return UIColor(hex: "#913FE3")
                    }
                case .F:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#EBD619")
                    case .P: return UIColor(hex: "#EC8A2F")
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#42E9D5")
                    case .P: return UIColor(hex: "#DA3278")
                    }
                case .F:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#3EE53A")
                    case .P: return UIColor(hex: "#D63E35")
                        
                    }
                }
            }
            
        case .I:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#6187E8")
                    case .P: return UIColor(hex: "#B886EB")
                    }
                case .F:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#F2C759")
                    case .P: return UIColor(hex: "#ED995D")
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#8CE9DE")
                    case .P: return UIColor(hex: "#E47AA6")
                    }
                case .F:
                    switch lastIndex {
                    case .J: return UIColor(hex: "#8BEE89")
                    case .P: return UIColor(hex: "#EA807A")
                    }
                }
            }
        }
    }
    
    var profileImage: UIImage {
        switch firstIndex {
        case .E:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_entj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_entp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_enfj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_enfp").withRenderingMode(.alwaysOriginal)
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_estj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_estp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_esfj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_esfp").withRenderingMode(.alwaysOriginal)
                        
                    }
                }
            }
            
        case .I:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_intj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_intp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_infj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_infp").withRenderingMode(.alwaysOriginal)
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_istj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_istp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_isfj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_isfp").withRenderingMode(.alwaysOriginal)
                    }
                }
            }
        }
    }
    
    var characterImage: UIImage {
        switch firstIndex {
        case .E:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_entj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_entp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_enfj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_enfp").withRenderingMode(.alwaysOriginal)
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_estj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_estp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_esfj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_esfp").withRenderingMode(.alwaysOriginal)
                        
                    }
                }
            }
            
        case .I:
            switch secondIndex {
            case .N:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_intj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_intp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_infj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_infp").withRenderingMode(.alwaysOriginal)
                    }
                }
            case .S:
                switch thirdIndex {
                case .T:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_istj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_istp").withRenderingMode(.alwaysOriginal)
                    }
                case .F:
                    switch lastIndex {
                    case .J: return #imageLiteral(resourceName: "img_home_isfj").withRenderingMode(.alwaysOriginal)
                    case .P: return #imageLiteral(resourceName: "img_home_isfp").withRenderingMode(.alwaysOriginal)
                    }
                }
            }
        }
    }
}
