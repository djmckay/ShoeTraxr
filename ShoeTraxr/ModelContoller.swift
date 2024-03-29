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
    var walkingDefault: DefaultShoe?
    var runningDefault: DefaultShoe?
    fileprivate var walkingRunningDefault: DefaultShoe?
    fileprivate var walkingDefaultDB: DefaultShoe?
    fileprivate var runningDefaultDB: DefaultShoe?
    
    var runningHKWorkouts = [HKWorkout]()
    var walkingHKWorkouts = [HKWorkout]()
    var healthManager:HealthKitManager? /*{
        
        didSet {
            healthManager?.readRunningWorkOuts(completion: { (results, error) -> Void in
                if( error != nil )
                {
                    print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                    return;
                }
                else
                {
                    print("Running Workouts read successfully!")
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
                    print("Running Workouts read successfully!")
                }
                
                //Keep workouts and refresh tableview in main thread
                self.walkingHKWorkouts = results as! [HKWorkout]
                
            })
        }
    }*/

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
                             UIColor.darkGray,
                             UIColor.white]
    
    static var colorNames: [String] = ["Green",
                                "Red",
                                "Blue",
                                "Yellow",
                                "Purple",
                                "Black",
                                "Brown",
                                "Gray", "White"]

    static var defaultWorkoutTypes: [Int : String] = [Int(HKWorkoutActivityType.running.rawValue): "Running", Int(HKWorkoutActivityType.walking.rawValue): "Walking", Int(HKWorkoutActivityType.other.rawValue): "Running+Walking"]
    
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
                print("this can't be good")
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
            print("Workout count: \(workouts.count)")
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let defaultsFetchRequest =
            NSFetchRequest<DefaultShoe>(entityName: "DefaultShoe")
        
        //3
        do {
            let defaults = try managedContext.fetch(defaultsFetchRequest)
            print("default count: \(defaults.count)")
            
                for defaultWorkout in defaults {
                    print(defaultWorkout.shoe?.getTitle())
                    print(defaultWorkout.type)
                    if defaultWorkout.shoe == nil {
                        //delete
                        managedContext.delete(defaultWorkout)
                        print("delete invalid data, no shoe")
                    } else {
                    if defaultWorkout.type == Int16(HKWorkoutActivityType.walking.rawValue) {
                        //managedContext.delete(defaultWorkout)
//                        if defaultWorkout == nil {
//                            walkingDefault = defaultWorkout
//                        }
                        walkingDefault = defaultWorkout
                        walkingDefaultDB = defaultWorkout
                    }
                    else if defaultWorkout.type == Int16(HKWorkoutActivityType.running.rawValue) {
                        //managedContext.delete(defaultWorkout)
                        runningDefault = defaultWorkout
                        runningDefaultDB = defaultWorkout
                    }
                    
                    else if defaultWorkout.type == Int16(HKWorkoutActivityType.other.rawValue) {
                        //managedContext.delete(defaultWorkout)
                        runningDefault = defaultWorkout
                        walkingDefault = defaultWorkout
                        walkingRunningDefault = defaultWorkout
                    }
                    }

            }
            
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
        self.brands.append(Brand("Other"))        
        
        self.fetchBrands { (brands, error) in
            if let brands = brands, brands.count > 0 {
                self.brands = brands
                self.brands.append(Brand(""))
                self.brands.sort { (lhs, rhs) -> Bool in
                    if lhs < rhs {
                        return true
                    }
                    else {
                        return false
                    }
                }
                self.brands.append(Brand("Other"))
            }
        }
        
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
    
    func defaultWorkout(forType: Int) -> DefaultShoe? {
        if forType == Int(HKWorkoutActivityType.walking.rawValue) {
            if runningDefault?.type == Int16(HKWorkoutActivityType.other.rawValue) {
                runningDefault?.type = Int16(HKWorkoutActivityType.running.rawValue)
                walkingDefault = walkingDefaultDB
            }
            return walkingDefault
        } else if forType == Int(HKWorkoutActivityType.running.rawValue)  {
            if runningDefault?.type == Int16(HKWorkoutActivityType.other.rawValue) {
                runningDefault?.type = Int16(HKWorkoutActivityType.running.rawValue)
                walkingDefault = walkingDefaultDB
                walkingDefault?.shoe = runningDefault?.shoe
            }
            return runningDefault
        } else if forType == Int(HKWorkoutActivityType.other.rawValue) {
            runningDefault?.type = Int16(HKWorkoutActivityType.other.rawValue)
            if let walkingDefault = self.walkingDefault {
                walkingDefault.shoe?.defaultWorkout = nil
            }
            walkingDefault = runningDefault
            return runningDefault
        }
        else {
            return nil
        }
    }

    func getRunningWorkouts(completion: @escaping (_ workouts: [HKWorkout]) -> Void) {
        healthManager?.readRunningWorkOuts(completion: { (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                return;
            }
            else
            {
                print("Running Workouts read successfully!")
            }
            
            //Keep workouts and refresh tableview in main thread
            self.runningHKWorkouts = results as! [HKWorkout]
            completion(self.runningHKWorkouts)

        })
    }
    
    func getWalkingWorkouts(completion: @escaping (_ workouts: [HKWorkout]) -> Void) {
        healthManager?.readWalkingWorkouts(completion: { (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                return;
            }
            else
            {
                print("Walking Workouts read successfully!")
            }
            
            //Keep workouts and refresh tableview in main thread
            self.walkingHKWorkouts = results as! [HKWorkout]
            completion(self.walkingHKWorkouts)
        })
    }

    func getMostRecentRunningWorkout(completion: @escaping (_ result: HKWorkout?) -> Void) {
        healthManager?.readMostRecentRunningWorkOut(completion: { (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                return;
            }
            else
            {
                print(results?.count)
                print("Most Recent Running Workouts read successfully!")
            }
            
            //Keep workouts and refresh tableview in main thread
            //self.runningHKWorkouts = results as! [HKWorkout]
            if results?.count == 0 {
                completion(nil)
            }
            else if let workout = results?[0] as? HKWorkout{
                print(workout.uuid.uuidString)
                completion(workout)
            }
            else {
                completion(nil)
            }
            
        })
    }
    
    func getMostRecentWalkingWorkout(completion: @escaping (_ result: HKWorkout?) -> Void) {
        healthManager?.readMostRecentWalkingWorkout(completion: { (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                return;
            }
            else
            {
                print(results?.count)
                print("Most Recent Walking Workouts read successfully!")
            }
            
            //Keep workouts and refresh tableview in main thread
            //self.runningHKWorkouts = results as! [HKWorkout]
            if results?.count == 0 {
                completion(nil)
            }
            else if let workout = results?[0] as? HKWorkout {
                print(workout.uuid.uuidString)
                completion(workout)
            }
            else {
                completion(nil)
            }
            
        })
    }
    
    func fetchBrands(_ completion: @escaping (_ brands: [Brand]?, _ error: NSError?) -> ()) {
        
        CloudKitController.sharedInstance.fetchBrands() { (brands, error) in
            if let brands = brands, brands.count > 0 {
                self.brands = brands
            self.brands.sort { (lhs, rhs) -> Bool in
                if lhs < rhs {
                    return true
                }
                else {
                    return false
                }
            }
            }
            completion(brands, error)
        }
    }
    
    func fetchProducts(brand: Brand, _ completion: @escaping (_ brands: [Product]?, _ error: NSError?) -> ()) {
        CloudKitController.sharedInstance.fetchProducts(brand: brand) { (products, error) in
            completion(products, error)
        }
    }
}
