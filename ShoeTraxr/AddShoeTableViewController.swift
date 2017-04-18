//
//  AddShoeTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

public class AddShoeTableViewController: UITableViewController {

    @IBOutlet weak var shoeDateCell: DatePickerCell!
    @IBOutlet weak var shoeBrandCell: TextCell!
    @IBOutlet weak var shoeModelCell: TextCell!
    @IBOutlet weak var shoeNicknameCell: TextCell!
    
    @IBOutlet weak var shoeMileageCell: NumberCell!
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoeDateCell.inputMode = .date
        shoeDateCell.updateDateTimeLabel()
        shoeMileageCell.doubleValue = 500.0
    }

    
    var distance:Double {
        get {
            return shoeMileageCell.doubleValue
        }
    }
    
    var brand:String {
        get {
            return shoeBrandCell.value
        }
    }
    
    var model:String {
        get {
            return shoeModelCell.value
        }
    }
    
    var nickname:String {
        get {
            return shoeNicknameCell.value
        }
    }
    
    var date:Date? {
        get {
            
            return shoeDateCell.date
        }
    }
}
