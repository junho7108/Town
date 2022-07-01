import UIKit

extension UIColor {
    
    convenience init(hex: String){
            let scanner = Scanner(string: hex) //문자 파서역할을 하는 클래스
            _ = scanner.scanString("#")  //scanString은 iOS13 부터 지원 #문자 제거
            
            var rgb: UInt64 = 0
            //문자열을 Int64 타입으로 변환해 rgb 변수에 저장. 변환 할 수 없다면 0 반환
            scanner.scanHexInt64(&rgb)
            
            let r = Double((rgb >> 16) & 0xFF) / 255.0 //좌측 문자열 2개 추출
            let g = Double((rgb >> 8) & 0xFF) / 255.0 // 중간 문자열 2개 추출
            let b = Double((rgb >> 0) & 0xFF) / 255.0 //우측 문자열 2개 추출
            self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        }
}

extension UIColor {
    static var grey100: UIColor {
            return UIColor(hex: "#F1F3F5")
        }
    
    static var grey200: UIColor {
        return UIColor(hex: "#DEE2E6")
    }
    
    static var grey300: UIColor {
        return UIColor(hex: "#ADB5BD")
    }
    
    static var grey400: UIColor {
        return UIColor(hex: "#CED4DA")
    }
    
    static var grey500: UIColor {
        return UIColor(hex: "#ADB5BD")
    }
  
    
    static var grey600: UIColor {
        return UIColor(hex: "#868E96")
    }
    
    static var grey700: UIColor {
        return UIColor(hex: "#495057")
    }
    
    static var grey800: UIColor {
        return UIColor(hex: "#343A40")
    }
}

extension UIColor {
    static var villageSky: UIColor {
        return UIColor(hex: "#33C4EF")
    }
    
    static var villageOrange: UIColor {
        return UIColor(hex: "#ED995D")
    }
}
