//
//  ProductCK.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 6/5/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation

import CloudKit

class ProductCK: Product {
    
    var record: CKRecord!
    var database: CKDatabase!
    
    
    init(record: CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        if let productName = record["name"] as? String {
            super.init(productName)
        }
        else {
            super.init("Other")
            
        }
    }
    
    
    
}
