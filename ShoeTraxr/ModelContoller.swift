//
//  ModelContoller.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ModelController: NSObject {

    var shoes = [Shoe]()
    var retiredShoes = [Shoe]()
    var workouts = [Workout]()

    var managedContext:NSManagedObjectContext!
    
    static let sharedInstance: ModelController = {
        let instance = ModelController()
        // setup code
        return instance
    }()
    
    override init() {
        super.init()
        // Create the data model.
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<Shoe>(entityName: "Shoe")
        let sectionSortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        

        //3
        do {
            fetchRequest.predicate = NSPredicate(format: "retired == false")
            shoes = try managedContext.fetch(fetchRequest)
            fetchRequest.predicate = NSPredicate(format: "retired == true")
            retiredShoes = try managedContext.fetch(fetchRequest)

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let workoutFetchRequest =
            NSFetchRequest<Workout>(entityName: "Workout")
        
        //3
        do {
            workouts = try managedContext.fetch(workoutFetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
          
        
    }
    
    func deleteShoe(shoe: Shoe, completion: ( (Bool, NSError?) -> Void)!) {
        managedContext.delete(shoe)
        
        retiredShoes.remove(at: retiredShoes.index(of: shoe)!)
        completion(true, nil)
    }
    
    func retireShoe(shoe: Shoe, completion: ( (Bool, NSError?) -> Void)!) {
        retiredShoes.append(shoe)
        shoes.remove(at: shoes.index(of: shoe)!)
        completion(true, nil)
    }
    
    func deleteWorkout(workout: Workout, completion: ( (Bool, NSError?) -> Void)!) {
        managedContext.delete(workout)
        
        shoes.remove(at: workouts.index(of: workout)!)
        completion(true, nil)
    }
    
    func addShoe(shoe: Shoe, completion: ( (Bool, NSError?) -> Void)!) {
            shoes.append(shoe)
            completion(true, nil)
    }
    
    func addWorkout(workout: Workout, completion: ( (Bool, NSError?) -> Void)!) {
        workouts.append(workout)
        completion(true, nil)
    }
    
}
