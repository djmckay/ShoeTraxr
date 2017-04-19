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
}
