//
//  NotificationManager.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/14/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import HealthKit
import UserNotifications
import UIKit

class NotificationManager {
    
    static func authorize(completionHandler: @escaping (Bool, Error?) -> Swift.Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("notifications granted!")
            } else {
                print("notifications denied")
            }
            completionHandler(granted, error)
        }
    }
    static func sendNotification(type: HKWorkoutActivityType, completion: @escaping () -> (Void)) {
        // 1
        let content = UNMutableNotificationContent()
        content.title = "New Workout Detected"
        var typeString = "walking"
        if type == .running {
            typeString = "running"
        }
        content.body = "New Workout added for \(typeString) needs shoe assigned."
        content.sound = UNNotificationSound.default()
        var currentBadge: Int = UIApplication.shared.applicationIconBadgeNumber
        currentBadge += 1
        content.badge = currentBadge as NSNumber
        // 2
        //        let imageName = "applelogo"
        //        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        //
        //        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        //
        //        content.attachments = [attachment]
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print(error!)
            }
            completion()
        })
    }
    
    static func sendNotification(type: HKWorkoutActivityType, shoe: Shoe, completion: @escaping () -> (Void)) {
        // 1
        let content = UNMutableNotificationContent()
        content.title = "New Workout Detected"
        
        var typeString = "walking"
        if type == .running {
            typeString = "running"
        }
        
        if shoe.distanceLogged >= shoe.distance {
            content.body = "\(shoe.getTitle()) used for new \(typeString) workout.  \(shoe.getTitle()) has reached limit \(shoe.distanceLoggedFormatted)."
            var currentBadge: Int = UIApplication.shared.applicationIconBadgeNumber
            currentBadge += 1
            content.badge = currentBadge as NSNumber
        } else {
            
            content.body = "\(shoe.getTitle()) used for new \(typeString) workout.  You have an estimated \(shoe.distanceRemainingFormatted) (\(shoe.percentRemaining)%) remaining on this shoe."
            if shoe.percentRemaining <= 10 {
                content.body += "  Time to visit the running store!"
            }
        }
        content.sound = UNNotificationSound.default()
        
        // 2
        //        let imageName = "applelogo"
        //        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        //
        //        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        //
        //        content.attachments = [attachment]
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print(error!)
            }
            completion()
        })
    }

}
