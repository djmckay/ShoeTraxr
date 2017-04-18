//
//  WorkoutModel.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//


import Foundation

class WorkoutModel: Hashable {
    
    var uuid: String!
    
    
    var hashValue : Int {
        get {
            return self.uuid.hashValue
        }
    }
    
    static func ==(lhs: WorkoutModel, rhs: WorkoutModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
