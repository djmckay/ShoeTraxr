//
//  ProductCloudKitControllerDelegate.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 6/5/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CloudKit

class ProductCloudKitControllerDelegate: CloudKitControllerSyncDelegate {
    
    func delete(recordId: CKRecordID, database: CKDatabase) {
        
    }
    
    func update(record: CKRecord, database: CKDatabase) {
        
    }
    
    //    func create(record: CKRecord, database: CKDatabase) -> BrandCK {
    //        return BrandCK("Other")
    //    }
    
    func subsribe(delegate: ModelDelegate, database: CKDatabase) {
        
    }
    
    
    func fetch(database: CKDatabase, _ completion: @escaping ([ProductCK]?, NSError?) -> ()) {
        self.fetchProducts(database: database) { (error) in
            completion(self.items, error)
        }
    }
    
    var items: [ProductCK] = []
    
    static var typeName: String = "Product"
    
    typealias Item = ProductCK
    
    var delegate: ModelDelegate?
    
    private func fetchProducts(database: CKDatabase, _ completion: @escaping (NSError?) -> ()) {
        
        let query = CKQuery(recordType: ProductCloudKitControllerDelegate.typeName, predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { results, error in
            if (results?.count)! > 0 {
                self.items.removeAll(keepingCapacity: true)
            }
            for item in results! {
                let brand = ProductCK(record: item, database: database)
                self.items.append(brand)
            }
            
            completion(error as NSError?)
            
        }
    }
    
    private func fetchBrand(_ product: ProductCK, completion:@escaping (_ brand: BrandCK?, _ error: NSError?) ->()) {
        
        let reference = product.record[BrandCloudKitControllerDelegate.typeName] as! CKReference
        product.database.fetch(withRecordID: reference.recordID) { (record, error) in
            let brand = BrandCK(record: record!, database: product.database)
            product.brand = brand
            completion(brand, error as NSError?)
            self.delegate?.modelUpdated()
            
        }
        
    }
    
    func fetchProducts(_ brand: BrandCK, completion:@escaping (_ author: [ProductCK]?, _ error: NSError?) ->()) {
        var productIds = [CKRecordID]()
        if let references = brand.record["products"] as? [CKReference] {
            for productReference in references {
                productIds.append(productReference.recordID)
            }
        }
        var products: [ProductCK] = []
        let fetchOperation = CKFetchRecordsOperation(recordIDs: productIds)
        fetchOperation.fetchRecordsCompletionBlock = {
            records, error in
            if error != nil {
                print("\(error!)")
            } else {
                for (recordId, record) in records! {
                    let product = ProductCK(record: record, database: brand.database)
                    products.append(product)
                    product.brand = brand
                }
                brand.products = products
                completion(products, error as NSError?)
                self.delegate?.modelUpdated()
            }
        }
        brand.database.add(fetchOperation)
        
    }
}
