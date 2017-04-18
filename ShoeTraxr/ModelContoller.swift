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

    var dataObjects: [NSManagedObject] = []
    var shoes = [ShoeModel]()
    
    override init() {
        super.init()
        // Create the data model.
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Shoe")
//        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
//        let sortDescriptors = [sectionSortDescriptor]
//        fetchRequest.sortDescriptors = sortDescriptors
        //3
        do {
            dataObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for item in dataObjects {
            let shoe = ShoeModel(object: item)
            print(item.description)
//            shoe.brand = item.value(forKeyPath: "brand") as? String
//            shoe.model = item.value(forKeyPath: "model") as? String
//            shoe.uuid = item.value(forKeyPath: "uuid") as? String
            
            shoes.append(shoe)
        }
        
        
    }
    
    func deleteShoe(shoeModel: ShoeModel, completion: ( (Bool, NSError?) -> Void)!) {
        shoeModel.delete()
        shoes.remove(at: shoes.index(of: shoeModel)!)
        dataObjects.remove(at: dataObjects.index(of: shoeModel.persistObject)!)
        completion(true, nil)
    }
    
    func addShoe(shoeModel: ShoeModel, completion: ( (Bool, NSError?) -> Void)!) {
        
//        if let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate {
//            // 1
//            let managedContext =
//                appDelegate.persistentContainer.viewContext
//            
//            let entity =
//                NSEntityDescription.entity(forEntityName: "Shoe",
//                                           in: managedContext)!
//            
//            let shoeItem = NSManagedObject(entity: entity,
//                                                insertInto: managedContext)
//            
//            dataObjects.append(shoeItem)
//            shoeItem.setValue(shoeModel.brand, forKeyPath: "brand")
//            shoeItem.setValue(shoeModel.model, forKeyPath: "model")
//            shoeItem.setValue(shoeModel.uuid, forKeyPath: "uuid")
//            shoeItem.setValue(shoeModel.date, forKeyPath: "dateAdded")
//            shoeItem.setValue(shoeModel.distance, forKeyPath: "maxMileage")

            
            shoes.append(shoeModel)
            dataObjects.append(shoeModel.persistObject)
            completion(true, nil)
            
        //}
        
    }
    
}
