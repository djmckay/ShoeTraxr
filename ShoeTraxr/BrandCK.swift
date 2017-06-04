//
//  BrandCK.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 6/4/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import CloudKit

class BrandCK: Brand {
    
    var record: CKRecord!
    var database: CKDatabase!
    
    
    init(record: CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        if let brandName = record["name"] as? String {
            super.init(brandName)
            self.website =  record["website"] as? String
        }
        else {
            super.init("Other")

        }
    }
    
    
    
}
