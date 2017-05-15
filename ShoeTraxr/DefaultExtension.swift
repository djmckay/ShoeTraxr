//
//  DefaultExtension.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/13/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CoreData

extension DefaultShoe {
    
    convenience init() {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "DefaultShoe",
                                       in: (ModelController.sharedInstance.managedContext)!)
        
        self.init(entity: entityDescription!,
                  insertInto: ModelController.sharedInstance.managedContext)
        
    }
}
