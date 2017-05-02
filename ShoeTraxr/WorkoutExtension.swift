//
//  WorkoutExtension.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CoreData

extension Workout {
    
    override public var hashValue : Int {
        get {
            return (self.uuid?.hashValue)!
        }
    }
    
    static func ==(lhs: Workout, rhs: Workout) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func delete(completion: ( (Bool, NSError?) -> Void)!) {
        ModelController.sharedInstance.deleteWorkout(workout: self) { (status, error) in
            completion(status, error)
        }
    }
    
    convenience init() {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Workout",
                                       in: (ModelController.sharedInstance.managedContext)!)
        
        self.init(entity: entityDescription!,
                  insertInto: ModelController.sharedInstance.managedContext)
        ModelController.sharedInstance.addWorkout(workout: self, completion: { (status, error) in
            
        })
    }
    
}
