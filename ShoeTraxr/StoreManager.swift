//
//  StoreManager.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 11/11/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import StoreKit

fileprivate let appRunsForReview = 5
class StoreManager {

    static func requestReview() {
        if UserDefaultsManager.appRuns % appRunsForReview == 0 {
            SKStoreReviewController.requestReview()
            UserDefaultsManager.appRuns = 0
        }
    }
}
