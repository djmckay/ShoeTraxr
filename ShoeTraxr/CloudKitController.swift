//
//  CloudKitController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 6/4/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CloudKit

// Specify the protocol to be used by view controllers to handle notifications.
protocol ModelDelegate {
    func errorUpdating(_ error: NSError)
    func modelUpdated()
}

protocol CloudKitControllerSyncDelegate: CloudKitControllerSyncDataSource {
    associatedtype Item
    static var typeName: String { get set }
    var items: [Item] { get }
    
}

protocol CloudKitControllerSyncDataSource {
    associatedtype Item
    func fetch(database: CKDatabase, _ completion: @escaping (_ items: [Item]?, _ error: NSError?) -> ())
//    func create(record: CKRecord, database: CKDatabase) -> Item
    func update(record: CKRecord, database: CKDatabase)
    func delete(recordId: CKRecordID, database: CKDatabase)
    func subsribe(delegate: ModelDelegate, database: CKDatabase)
}


class CloudKitController {
    
    static let sharedInstance = CloudKitController()
    
    // Define databases.
    
    // Represents the default container specified in the iCloud section of the Capabilities tab for the project.
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    let sharedDB: CKDatabase
    
    // Define Delegates
    let brandDelegate = BrandCloudKitControllerDelegate()
    let productDelegate = ProductCloudKitControllerDelegate()
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
        
    }
    
    func fetchBrands(_ completion: @escaping (_ brands: [BrandCK]?, _ error: NSError?) -> () ) {
        brandDelegate.fetch(database: publicDB) { (brands, error) in
            completion(brands, error)
        }
        
    }
    
    func fetchProducts(brand: Brand, _ completion: @escaping (_ products: [ProductCK]?, _ error: NSError?) -> () ) {
        if let brand = brand as? BrandCK {
        self.productDelegate.fetchProducts(brand, completion: { (products, error) in
//            for product in products! {
//                product.brand = brand
//            }
//            brand.products = products!
            completion(products, error)
        })
        } else {
            completion([ProductCK](), nil)
        }
    }
}
