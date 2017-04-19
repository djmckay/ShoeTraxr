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
    @IBOutlet weak var shoeDistanceUnit: UISegmentedControl!
    
    @IBOutlet weak var numberOfWorkouts: NumberCell!
    @IBOutlet weak var shoeDistanceLogged: TextCell!

    var editShoe: Shoe!

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoeDateCell.inputMode = .date
        shoeDateCell.updateDateTimeLabel()
        shoeMileageCell.doubleValue = 500.0
        
        if let editShoe = editShoe {
            self.title = "Shoe Details"
            self.shoeBrandCell.textField.text = editShoe.brand
            if editShoe.distanceUnit == "Kilometers" {
                self.shoeDistanceUnit.isEnabledForSegment(at: DistanceUnit.Kilometers.rawValue)
            }
            self.shoeDistanceUnit.isEnabled = false
            self.shoeModelCell.textField.text = editShoe.model
            self.shoeNicknameCell.textField.text = editShoe.uuid
            self.shoeMileageCell.doubleValue = editShoe.distance
            self.shoeDateCell.date = editShoe.dateAdded! as Date
            self.numberOfWorkouts.integerValue = editShoe.workoutData.count
            self.shoeDistanceLogged.value = editShoe.distanceLoggedFormatted
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
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
    
    var distanceUnit:DistanceUnit {
        get {
            let distanceUnitInput = DistanceUnit(rawValue: shoeDistanceUnit.selectedSegmentIndex)!
            return distanceUnitInput
        }
    }
    
    
}
