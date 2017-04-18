//
//  Shoe.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ShoeModel: Hashable {
    
    var persistObject: NSManagedObject!
    
    //var brand: String!
//    var model: String!
//    var uuid: String!
//    var date: Date!
//    var distance: Double = 0.0
    var workouts: [WorkoutModel]!
    
    
    var brand:String {
        
        get {
            return persistObject.value(forKeyPath: "brand") as! String
        }
        set(newBrand) {
            persistObject.setValue(newBrand, forKeyPath: "brand")

        }
    }
    
    var model:String {
        
        get {
            return persistObject.value(forKeyPath: "model") as! String
        }
        set(newBrand) {
            persistObject.setValue(newBrand, forKeyPath: "model")
            
        }
    }
    
    var uuid:String {
        
        get {
            return persistObject.value(forKeyPath: "uuid") as! String
        }
        set(newBrand) {
            persistObject.setValue(newBrand, forKeyPath: "uuid")
            
        }
    }
    
    var date:Date {
        
        get {
            return persistObject.value(forKeyPath: "dateAdded") as! Date
        }
        set(newBrand) {
            persistObject.setValue(newBrand, forKeyPath: "dateAdded")
            
        }
    }
    
    var distance:Double {
        
        get {
            return persistObject.value(forKeyPath: "maxMileage") as! Double
        }
        set(newBrand) {
            persistObject.setValue(newBrand, forKeyPath: "maxMileage")
            
        }
    }
    
    
    init(object: NSManagedObject) {
        persistObject = object
    }
    
    init() {
        
        if let appDelegate =
            UIApplication.shared.delegate as? AppDelegate {
            // 1
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let entity =
                NSEntityDescription.entity(forEntityName: "Shoe",
                                           in: managedContext)!
            
            persistObject = NSManagedObject(entity: entity,
                                           insertInto: managedContext)

        }
    }
    
    var hashValue : Int {
        get {
            return self.brand.appending(model).appending(uuid).hashValue
        }
    }
    
    static func ==(lhs: ShoeModel, rhs: ShoeModel) -> Bool {
        return lhs.brand == rhs.brand && lhs.model == rhs.model && lhs.uuid == rhs.uuid
    }
    
    func delete() {
        if let appDelegate =
            UIApplication.shared.delegate as? AppDelegate {
            // 1
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            managedContext.delete(persistObject)

    
        }
    }
}
