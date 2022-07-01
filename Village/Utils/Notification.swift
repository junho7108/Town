import Foundation
import RxSwift

protocol NotificationCenterProtocol {
    var name: Notification.Name { get }
}

extension NotificationCenterProtocol {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(self.name).map { $0.object }
    }
    
    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: self.name, object: object, userInfo: nil)
    }
}

enum VillageNotificationCenter: NotificationCenterProtocol {
    case fetchFeed
    
    var name: Notification.Name {
        switch self {
        case .fetchFeed:
            return Notification.Name("fetchFeedNotification")
        }
    }
}
