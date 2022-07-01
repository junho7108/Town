import Foundation

extension String {
    func validNicknameCheck() -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^[가-힣ㄱ-ㅎa-zA-Z][가-힣ㄱ-ㅎa-zA-Z0-9]{1,12}$")
        return predicate.evaluate(with: self)
    }
    
    func toDate() -> Date? {
        let selfString = self
        var dateString: String = ""
        
        for (_, char) in selfString.enumerated() {
            if char == "." {
                dateString.append("Z")
                break
            }
            
            dateString.append(char)
        }
        
        let isoFormattoer = ISO8601DateFormatter()
        return isoFormattoer.date(from: dateString) ?? nil
    }
}
