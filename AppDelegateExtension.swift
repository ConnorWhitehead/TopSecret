import UIKit
import CoreData
import IQKeyboardManagerSwift  
import UserNotifications 
import RealmSwift
extension AppDelegate {
    func delegateNotifications() {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Response : \(granted) -- and error : \(String(describing: error))")
        }
        notifCenter.delegate = self
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { 
        completionHandler([.alert, .badge, .sound])
        print(notification.request.content)
    }
}
