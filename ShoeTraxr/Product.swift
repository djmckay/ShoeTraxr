//
//  Product.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 6/5/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation

class Product: Hashable {
    
    var name: String?
    var brand: Brand?
    
    init(_ name: String) {
        self.name = name
    }
    
    var hashValue : Int {
        get {
            return self.name!.hashValue
        }
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func <(lhs: Product, rhs: Product) -> Bool {
        return (lhs.name?.lowercased())! < (rhs.name?.lowercased())!
    }
    
}
