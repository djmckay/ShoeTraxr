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
import HealthKit

class ModelController: NSObject {

    var shoes = [Shoe]()
    var retiredShoes = [Shoe]()
    var workouts = [Workout]()
    var runningHKWorkouts = [HKWorkout]()
    var walkingHKWorkouts = [HKWorkout]()
    var healthManager:HealthKitManager? {
        
        didSet {
            healthManager?.readRunningWorkOuts(completion: { (results, error) -> Void in
                if( error != nil )
                {
                    print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                    return;
                }
                else
                {
                    print("Workouts read successfully!")
                }
                
                //Keep workouts and refresh tableview in main thread
                self.runningHKWorkouts = results as! [HKWorkout]
                
            })
            healthManager?.readWalkingWorkouts(completion: { (results, error) -> Void in
                if( error != nil )
                {
                    print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                    return;
                }
                else
                {
                    print("Workouts read successfully!")
                }
                
                //Keep workouts and refresh tableview in main thread
                self.walkingHKWorkouts = results as! [HKWorkout]
                
            })
        }
    }

    var brands: [Brand] = [Brand(""), Brand("adidas"),
                           Brand("Altra"),
                           Brand("ASICS"),
                           Brand("Brooks"),
                           Brand("Columbia"),
                           Brand("HOKA ONE ONE"),
                           Brand("INOV-8"),
                           Brand("La Sportiva"),
                           Brand("Merrell"),
                           Brand("Mizuno"),
                           Brand("New Balance"),
                           Brand("Newton"),
                           Brand("Nike"),
                           Brand("On"),
                           Brand("Pearl Izumi"),
                           Brand("Salming"),
                           Brand("Salomon"),
                           Brand("Saucony"),
                           Brand("Skechers"),
                           Brand("The North Face"),
                           Brand("Topo Athletic"),
                           Brand("Under Armour"),
                           Brand("Scott")

                           
    ]
    
    static var colors: [UIColor] = [UIColor.green,
                             UIColor.red,
                             UIColor.blue,
                             UIColor.yellow,
                             UIColor.purple,
                             UIColor.black,
                             UIColor.brown,
                             UIColor.gray]
    
    static var colorNames: [String] = ["Green",
                                "Red",
                                "Blue",
                                "Yellow",
                                "Purple",
                                "Black",
                                "Brown",
                                "Gray"]

    
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
            //print(workouts.count)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        brands.sort { (lhs, rhs) -> Bool in
            if lhs < rhs {
                return true
            }
            else {
                return false
            }
        }
        brands.append(Brand("Other"))
        
        
    }
    
    func deleteShoe(shoe: Shoe, completion: ( (Bool, NSError?) -> Void)!) {
        managedContext.delete(shoe)
        
        retiredShoes.remove(at: retiredShoes.index(of: shoe)!)
        completion(true, nil)
    }
    
    func unRetireShoe(shoe: Shoe, completion: ( (Bool, NSError?) -> Void)!) {
        shoes.append(shoe)
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
    
    func getWorkout(hkWorkout: HKWorkout) -> Workout? {
        var returnWorkout: Workout?
        for workout in (self.workouts) {
            if workout.uuid == hkWorkout.uuid.uuidString {
                returnWorkout = workout
                if workout.shoe != nil {
                    break
                }
            }
        }
        return returnWorkout
    }

    
}
