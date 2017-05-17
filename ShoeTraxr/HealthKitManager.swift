//
//  HealthKitManager.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    //var workouts = [HKWorkout]()

    let running = HKWorkoutActivityType.running
    let walking = HKWorkoutActivityType.walking
    
    
    func authorizeHealthKit(completion: ((_ success:Bool, _ error:NSError?) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            //HKObjectType.activitySummaryType(),
            HKObjectType.workoutType()
            )
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = Set<HKSampleType>()
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.jeanoelyse.ShoeTraxr.ShoeTraxr", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(false, error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) -> Void in
            ModelController.sharedInstance.healthManager = self

            if( completion != nil )
            {
                completion(success,nil)
            }
        }
    }
    
    func readRunningWorkOuts(completion: (([AnyObject]?, NSError?) -> Void)!) {
        readWorkouts(type: HKWorkoutActivityType.running, limit: 0, completion: completion)
        
    }

    func readWalkingWorkouts(completion: (([AnyObject]?, NSError?) -> Void)!) {
        readWorkouts(type: HKWorkoutActivityType.walking, limit: 0, completion: completion)
        
    }
    /*
    func observeRunningWorkOuts(completion: ((Bool, Error?) -> Void)!) {
        observeWorkouts(type: HKWorkoutActivityType.running, limit: 1, completion: completion)
        
    }
    
    func observeWalkingWorkouts(completion: ((Bool, Error?) -> Void)!) {
        observeWorkouts(type: HKWorkoutActivityType.walking, limit: 1, completion: completion)
        
    }
    */
    func observeWorkOuts(completion: ((Bool, Error?) -> Void)!) {
        /*disableBackground { (success, error) in
            if success {
                print("Disabled background delivery of workout changes changes")
            } else {
                if let theError = error{
                    print("Failed to enable background delivery. ")
                    print("Error = \(theError)")
                }
            }
        }*/
        observeWorkouts(type: HKWorkoutActivityType.running)
        observeWorkouts(type: HKWorkoutActivityType.walking)
        enableBackground() { (succeeded, error) in
            if succeeded{
                print("Enabled background delivery of workout changes changes")
            } else {
                if let theError = error{
                    print("Failed to enable background delivery. ")
                    print("Error = \(theError)")
                }
            }
            completion(succeeded, error)
        }

    }
    
    private func readWorkouts(type: HKWorkoutActivityType, limit: Int, completion: (([AnyObject]?, NSError?) -> Void)!) {
        
        // 1. Predicate to read only running workouts
        let predicate =  HKQuery.predicateForWorkouts(with: type)
        // 2. Order the workouts by date
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            //self.workouts = results as! [HKWorkout]
            completion(results,error as NSError?)
        }
        // 4. Execute the query
        healthKitStore.execute(sampleQuery)
        
        
    }
    /*
    private func observeWorkouts(type: HKWorkoutActivityType, limit: Int, completion: ((Bool, Error?) -> Void)!) {
        
        // 1. Predicate to read only running workouts
        let predicate =  HKQuery.predicateForWorkouts(with: type)
        // 2. Create the observer query
        let sampleQuery = HKObserverQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, updateHandler:
        { (query, completionHandler, error) -> Void in
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            //send notification?
            
            if type == HKWorkoutActivityType.running {
                ModelController.sharedInstance.getMostRecentRunningWorkout {workout in
                    if workout != nil && nil == ModelController.sharedInstance.getWorkout(hkWorkout: workout!) {
                        if let defaultShoe = ModelController.sharedInstance.runningDefault?.shoe {
                            _ = defaultShoe.addWorkout(selectedWorkout: workout!)
                            self.sendNotification(type: (workout?.workoutActivityType)!, shoe: defaultShoe)
                        }
                        else {
                            self.sendNotification(type: type)
                        }

                    }
                }
                
                
            } else if type == HKWorkoutActivityType.walking {
                ModelController.sharedInstance.getMostRecentWalkingWorkout {workout in
                    if workout != nil && nil == ModelController.sharedInstance.getWorkout(hkWorkout: workout!) {
                        if let defaultShoe = ModelController.sharedInstance.walkingDefault?.shoe {
                            defaultShoe.addWorkout(selectedWorkout: workout!)
                            self.sendNotification(type: type, shoe: defaultShoe)
                        }
                        else {
                            self.sendNotification(type: type)
                        }
                    }
                }
            }
            
            completionHandler()
        })
        // 3. Execute the query
        healthKitStore.execute(sampleQuery)
        // 4. Enable in background
        enableBackground(type: type) { (succeeded, error) in
            if succeeded{
                print("Enabled background delivery of \(type) changes")
            } else {
                if let theError = error{
                    print("Failed to enable background delivery. ")
                    print("Error = \(theError)")
                }
            }
            completion(succeeded, error)
        }
        
        
    }
 */
    
    private func observeWorkouts(type: HKWorkoutActivityType) {
        
        // 1. Predicate to read only running workouts
        let predicate =  HKQuery.predicateForWorkouts(with: type)
        // 2. Create the observer query
        let sampleQuery = HKObserverQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, updateHandler:
        { (query, completionHandler, error) -> Void in
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            //send notification?
            print(type.rawValue)
            if type == HKWorkoutActivityType.running {
                ModelController.sharedInstance.getMostRecentRunningWorkout {workout in
                    if workout != nil && nil == ModelController.sharedInstance.getWorkout(hkWorkout: workout!) {
                        if let defaultShoe = ModelController.sharedInstance.runningDefault?.shoe {
                            _ = defaultShoe.addWorkout(selectedWorkout: workout!)
                            self.sendNotification(type: (workout?.workoutActivityType)!, shoe: defaultShoe)
                        }
                        else {
                            self.sendNotification(type: (workout?.workoutActivityType)!)
                        }
                    }
                    completionHandler()
                }
            
            
                
            } else if type == HKWorkoutActivityType.walking {
                ModelController.sharedInstance.getMostRecentWalkingWorkout {workout in
                    if workout != nil && nil == ModelController.sharedInstance.getWorkout(hkWorkout: workout!) {
                        if let defaultShoe = ModelController.sharedInstance.walkingDefault?.shoe {
                            _ = defaultShoe.addWorkout(selectedWorkout: workout!)
                            self.sendNotification(type: (workout?.workoutActivityType)!, shoe: defaultShoe)
                        }
                        else {
                            self.sendNotification(type: (workout?.workoutActivityType)!)
                        }
                    }
                    completionHandler()
            
                }
            }
            
        })
        // 3. Execute the query
        healthKitStore.execute(sampleQuery)
        
        
    }
    
    func enableBackground(type: HKWorkoutActivityType, completion: @escaping (Bool, Error?) -> Swift.Void) {
        healthKitStore.enableBackgroundDelivery(for: HKObjectType.workoutType(), frequency: .immediate) { (complete, error) in
                completion(complete, error)
        }
    }
    
    func enableBackground(completion: @escaping (Bool, Error?) -> Swift.Void) {
        healthKitStore.enableBackgroundDelivery(for: HKObjectType.workoutType(), frequency: .immediate) { (complete, error) in
            completion(complete, error)
        }
    }
    
    func disableBackground(completion: @escaping (Bool, Error?) -> Swift.Void) {
        healthKitStore.disableAllBackgroundDelivery { (complete, error) in
            completion(complete, error)
        }
    }
    
    func readSummary(completion: (([HKActivitySummary]?, NSError?) -> Void)!) {
        
        let calendar = Calendar.autoupdatingCurrent
        
        var dateComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        
        // This line is required to make the whole thing work
        dateComponents.calendar = calendar
        
        // 1. Predicate to read todays summary
        //let predicate =  HKQuery.predicateForActivitySummary(with: dateComponents)
        
        // 3. Create the query
        //let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
        let query = HKActivitySummaryQuery(predicate: nil) { (query, summaries, error) in
            guard let summaries = summaries, summaries.count > 0
                else {
                    // No data returned. Perhaps check for error
                    completion(nil, error as NSError?)
                    return
            }
            // Handle the activity rings data here
            completion(summaries, nil)
            
        }
        healthKitStore.execute(query)

    }
    
    func readMostRecentRunningWorkOut(completion: (([AnyObject]?, NSError?) -> Void)!) {
        readWorkouts(type: HKWorkoutActivityType.running, limit: 1, completion: completion)
        
    }
    
    func readMostRecentWalkingWorkout(completion: (([AnyObject]?, NSError?) -> Void)!) {
        readWorkouts(type: HKWorkoutActivityType.walking, limit: 1, completion: completion)
        
    }
    
    private func sendNotification(type: HKWorkoutActivityType) {
        NotificationManager.sendNotification(type: type)
//        // 1
//        let content = UNMutableNotificationContent()
//        content.title = "ShoeTraxR"
//        var typeString = "walking"
//        if type == .running {
//            typeString = "running"
//        }
//        content.body = "New Workout added for \(typeString) needs shoe assigned."
//        content.sound = UNNotificationSound.default()
//        var currentBadge: Int = UIApplication.shared.applicationIconBadgeNumber
//        currentBadge += 1
//        content.badge = currentBadge as NSNumber
//        // 2
////        let imageName = "applelogo"
////        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
////        
////        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
////        
////        content.attachments = [attachment]
//        
//        // 3
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        
//        // 4
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func sendNotification(type: HKWorkoutActivityType, shoe: Shoe) {
        NotificationManager.sendNotification(type: type, shoe: shoe)
        // 1
//        let content = UNMutableNotificationContent()
//        content.title = "ShoeTraxR"
//        if shoe.distanceLogged >= shoe.distance {
//            content.body = "\(shoe.getTitle()) has reached limit \(shoe.distanceLoggedFormatted)."
//            var currentBadge: Int = UIApplication.shared.applicationIconBadgeNumber
//            currentBadge += 1
//            content.badge = currentBadge as NSNumber
//        } else {
//            var typeString = "walking"
//            if type == .running {
//                typeString = "running"
//            }
//            content.body = "\(shoe.getTitle()) used for new \(typeString) workout."
//        }
//        content.sound = UNNotificationSound.default()
//        
//        // 2
//        //        let imageName = "applelogo"
//        //        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
//        //
//        //        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
//        //
//        //        content.attachments = [attachment]
//        
//        // 3
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        
//        // 4
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    
}
