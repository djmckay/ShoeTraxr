//
//  Brand.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/27/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation

class Brand: Hashable {
    
    var name: String?
    var website: String?
    
    init(_ name: String) {
        self.name = name
    }
    
    var hashValue : Int {
        get {
            return self.name!.hashValue
        }
    }
    
    static func ==(lhs: Brand, rhs: Brand) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func <(lhs: Brand, rhs: Brand) -> Bool {
        return (lhs.name?.lowercased())! < (rhs.name?.lowercased())!
    }

}
