//
//  UserDefaultsManager.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 11/11/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    
    static let defaults: UserDefaults = UserDefaults.standard
    
    static fileprivate let numberOfRuns = "numberOfRuns"
    
    static var appRuns: Int {
        get {
            return defaults.integer(forKey: numberOfRuns)
        }
        set {
            defaults.set(newValue, forKey: numberOfRuns)
        }
    }
    
    static func incrementAppRuns() -> Int {
        self.appRuns += 1
        return self.appRuns
    }
    
}
