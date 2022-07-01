import Foundation

extension Date {
    func toString(dateformatter: DateFormatter? = nil) -> String {
        if let dateformatter = dateformatter {
            return dateformatter.string(from: self)
        } else {
            let newDateForamtter = DateFormatter()
            newDateForamtter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return newDateForamtter.string(from: self)
        }
    }
}
