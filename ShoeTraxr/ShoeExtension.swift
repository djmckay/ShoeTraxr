//
//  ShoeExtension.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CoreData
import HealthKit

extension Shoe {
    
    
    var workoutData:[Workout] {
        get {
            var workoutData = [Workout]()
            let workouts = self.workouts
            for workoutSet in workouts! {
                let workout = workoutSet as! Workout
                workoutData.append(workout)
            }
            return workoutData
        }
    }
    
    var distanceLogged:Double {
        get {
            var distanceLogged: Double = 0.0
            let workouts = self.workouts
            for workoutSet in workouts! {
                let workout = workoutSet as! Workout
                distanceLogged += workout.distance
            }
            return distanceLogged
        }
    }
    
    var distanceLoggedFormatted:String {
        get {
            let distanceFormatter = LengthFormatter()
            var detailText = String()
            if self.distanceUnit == "Kilometers" {
                let distanceInKM = self.distanceLogged
                detailText += distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.kilometer)
            }
            else {
                let distanceInMiles = self.distanceLogged
                detailText += distanceFormatter.string(fromValue: distanceInMiles, unit: LengthFormatter.Unit.mile)
            }
            return detailText
        }
    }
    
    var distanceUnitType: DistanceUnit {
        if self.distanceUnit == "Kilometers" {
            return DistanceUnit.Kilometers
        }
        else {
            return DistanceUnit.Miles
        }
    }
    
    var distanceFormatted:String {
        get {
            let distanceFormatter = LengthFormatter()
            var detailText = String()
            if self.distanceUnit == "Kilometers" {
                let distanceInKM = self.distance
                detailText += distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.kilometer)
            }
            else {
                let distanceInMiles = self.distance
                detailText += distanceFormatter.string(fromValue: distanceInMiles, unit: LengthFormatter.Unit.mile)
            }
            
            return detailText
        }
    }
    
    var distanceRemainingFormatted:String {
        get {
            let distanceFormatter = LengthFormatter()
            var detailText = String()
            if self.distanceUnit == "Kilometers" {
                let distanceInKM = self.distance - self.distanceLogged
                detailText += distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.kilometer)
            }
            else {
                let distanceInMiles = self.distance - self.distanceLogged
                detailText += distanceFormatter.string(fromValue: distanceInMiles, unit: LengthFormatter.Unit.mile)
            }
            
            return detailText
        }
    }
    
    var percentRemaining: Int {
        let distanceRemaining = self.distance - self.distanceLogged
        let distancePercentRemaining = Int((distanceRemaining / self.distance) * 100)
        return distancePercentRemaining
    }
    
    func delete(completion: ( (Bool, NSError?) -> Void)!) {
        ModelController.sharedInstance.deleteShoe(shoe: self) { (status, error) in
            completion(status, error)
        }
    }
    
    func unRetire(completion: ( (Bool, NSError?) -> Void)!) {
        print("retire")
        ModelController.sharedInstance.unRetireShoe(shoe: self, completion: { (status, error) in
            self.retired = false
            self.retiredDate = nil
        })
        if completion != nil {
            completion(true, nil)
        }
    }
    
    func retire(completion: ( (Bool, NSError?) -> Void)!) {
        print("retire")
        ModelController.sharedInstance.retireShoe(shoe: self, completion: { (status, error) in
            self.retired = true
            self.retiredDate = Date() as NSDate
            self.defaultWorkout = nil
        })
        completion(true, nil)
    }
    
    convenience init() {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Shoe",
                                       in: (ModelController.sharedInstance.managedContext)!)
        
        self.init(entity: entityDescription!,
                        insertInto: ModelController.sharedInstance.managedContext)
        ModelController.sharedInstance.addShoe(shoe: self, completion: { (status, error) in
            
            
        })
    }
    
    func getTitle() -> String {
        
        var title = self.brand! + " " + self.model!
        if (self.uuid?.characters.count)! > 0 {
            title = self.uuid!
            
        }
        
        return title
    }
    
    func getHKWorkouts() -> [HKWorkout] {
        var hkWorkouts = [HKWorkout]()
        hkWorkouts.append(contentsOf: getWalkingHKWorkouts())
        hkWorkouts.append(contentsOf: getRunningHKWorkouts())
//        for workoutSet in workouts! {
//            for hkWorkout in ModelController.sharedInstance.runningHKWorkouts {
//                let workout = workoutSet as! Workout
//                if hkWorkout.uuid.uuidString == workout.uuid {
//                    hkWorkouts.append(hkWorkout)
//                }
//            }
//            for hkWorkout in ModelController.sharedInstance.walkingHKWorkouts {
//                let workout = workoutSet as! Workout
//                if hkWorkout.uuid.uuidString == workout.uuid {
//                    hkWorkouts.append(hkWorkout)
//                }
//            }
//        }
        return hkWorkouts
    }
    
    func getWalkingHKWorkouts() -> [HKWorkout] {
        var hkWorkouts = [HKWorkout]()
        for hkWorkout in ModelController.sharedInstance.walkingHKWorkouts {
            for workoutSet in workouts! {
                let workout = workoutSet as! Workout
                if hkWorkout.uuid.uuidString == workout.uuid {
                    hkWorkouts.append(hkWorkout)
                }
            }
        }
        return hkWorkouts
    }
    
    func getRunningHKWorkouts() -> [HKWorkout] {
        var hkWorkouts = [HKWorkout]()
        for hkWorkout in ModelController.sharedInstance.runningHKWorkouts {
            for workoutSet in workouts! {
                let workout = workoutSet as! Workout
                if hkWorkout.uuid.uuidString == workout.uuid {
                    hkWorkouts.append(hkWorkout)
                }
            }
        }
        return hkWorkouts
    }
    
    func getHKUnit() -> HKUnit {
        if self.distanceUnitType == .Kilometers {
            return HKUnit.meterUnit(with: HKMetricPrefix.kilo)
        }
        else {
            return  HKUnit.mile()
            
        }
    }
    
    func addWorkout(selectedWorkout: HKWorkout) -> Workout {
        var workout: Workout!
        if let existingWorkout = ModelController.sharedInstance.getWorkout(hkWorkout: selectedWorkout) {
            workout = existingWorkout
        } else {
            workout = Workout()
            workout.uuid = selectedWorkout.uuid.uuidString
        }
        
        
        if self.distanceUnitType == .Kilometers {
            workout.distance = (selectedWorkout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo)))!
        }
        else {
            workout.distance = (selectedWorkout.totalDistance?.doubleValue(for: HKUnit.mile()))!
            
        }
        
        self.addToWorkouts(workout)
        ModelController.sharedInstance.workouts.append(workout)
        return workout
    }
}
