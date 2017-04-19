//
//  ShoeExtension.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CoreData

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
            print(detailText)
            return detailText
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
    
    func delete(completion: ( (Bool, NSError?) -> Void)!) {
        ModelController.sharedInstance.deleteShoe(shoe: self) { (status, error) in
            completion(status, error)
        }
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
}
