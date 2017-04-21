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
    var workouts = [HKWorkout]()

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
            
            if( completion != nil )
            {
                completion(success,nil)
            }
        }
    }
    
    func readRunningWorkOuts(completion: (([AnyObject]?, NSError?) -> Void)!) {
        
        // 1. Predicate to read only running workouts
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
        // 2. Order the workouts by date
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            self.workouts = results as! [HKWorkout]
            completion(results,error as NSError?)
        }
        // 4. Execute the query
        healthKitStore.execute(sampleQuery)
        
        
        
    }

    func readWalkingWorkouts(completion: (([AnyObject]?, NSError?) -> Void)!) {
         readWorkouts(type: HKWorkoutActivityType.walking, completion: completion)
        
    }

    private func readWorkouts(type: HKWorkoutActivityType, completion: (([AnyObject]?, NSError?) -> Void)!) {
        
        // 1. Predicate to read only running workouts
        let predicate =  HKQuery.predicateForWorkouts(with: type)
        // 2. Order the workouts by date
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            self.workouts = results as! [HKWorkout]
            completion(results,error as? NSError)
        }
        // 4. Execute the query
        healthKitStore.execute(sampleQuery)
        
        
    }
    
    func enableBackground(completion: @escaping (Bool, Error?) -> Swift.Void) {
        healthKitStore.enableBackgroundDelivery(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, frequency: .immediate) { (complete, error) in
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
        let predicate =  HKQuery.predicateForActivitySummary(with: dateComponents)
        
        // 3. Create the query
        //let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
        let query = HKActivitySummaryQuery(predicate: nil) { (query, summaries, error) in
            guard let summaries = summaries, summaries.count > 0
                else {
                    // No data returned. Perhaps check for error
                    completion(nil, error as! NSError)
                    return
            }
            // Handle the activity rings data here
            completion(summaries, nil)
            
        }
        healthKitStore.execute(query)

    }
}
