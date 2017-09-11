//
//  BrandCloudKitControllerDelegate.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 6/4/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CloudKit

class BrandCloudKitControllerDelegate: CloudKitControllerSyncDelegate {
    
    func delete(recordId: CKRecordID, database: CKDatabase) {
        
    }

    func update(record: CKRecord, database: CKDatabase) {
        
    }

//    func create(record: CKRecord, database: CKDatabase) -> BrandCK {
//        return BrandCK("Other")
//    }

    func subsribe(delegate: ModelDelegate, database: CKDatabase) {
        
    }

    
    func fetch(database: CKDatabase, _ completion: @escaping ([BrandCK]?, NSError?) -> ()) {
        self.fetchBrands(database: database) { (error) in
            completion(self.items, error)
        }
    }

    var items: [BrandCK] = []
    
    static var typeName: String = "Brand"
    
    typealias Item = BrandCK
    
    var delegate: ModelDelegate?
 
    private func fetchBrands(database: CKDatabase, _ completion: @escaping (NSError?) -> ()) {
        
        let query = CKQuery(recordType: BrandCloudKitControllerDelegate.typeName, predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { results, error in
            if (results?.count)! > 0 {
                self.items.removeAll(keepingCapacity: true)
            }
            for item in results! {
                let brand = BrandCK(record: item, database: database)
                self.items.append(brand)
            }
            print(error?.localizedDescription)
            completion(error as NSError?)
            
        }
    }
}
