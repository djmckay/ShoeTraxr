//
//  AddShoeTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

public class AddShoeTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var shoeDateCell: DatePickerCell!
    @IBOutlet weak var shoeBrandCell: TextCell!
    @IBOutlet weak var shoeModelCell: TextCell!
    @IBOutlet weak var shoeNicknameCell: TextCell!
    
    @IBOutlet weak var shoeMileageCell: NumberCell!
    @IBOutlet weak var shoeDistanceUnit: UISegmentedControl!
    
    @IBOutlet weak var numberOfWorkouts: NumberCell!
    @IBOutlet weak var shoeDistanceLogged: TextCell!

    @IBOutlet weak var shoeBrandPickerCell: BrandPickerCell!
    
    @IBOutlet weak var shoeAvatarColorPIckerCell: ColorPickerCell!
    
    @IBOutlet weak var defaultPickerCell: DefaultPickerCell!
    @IBOutlet weak var brandProductPickerCell: ProductPickerCell!
    
    @IBOutlet weak var shoePercentRemaining: TextCell!
    var editShoe: Shoe!

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoeDateCell.inputMode = .date
        shoeDateCell.updateDateTimeLabel()
        //shoeMileageCell.doubleValue = 500.0
        self.shoeBrandPickerCell.detailTextLabel?.text = "Required"
        self.shoeAvatarColorPIckerCell.detailTextLabel?.text = ModelController.colorNames[0]
        self.shoeAvatarColorPIckerCell.detailTextLabel?.textColor = ModelController.colors[0]
//        self.brandProductPickerCell.isHidden = true
        self.shoeBrandPickerCell.brandProductPickerCell = self.brandProductPickerCell
        self.brandProductPickerCell.otherModelCell = self.shoeModelCell

        if let editShoe = editShoe {
            self.title = "Shoe Details"
            //self.shoeBrandCell.textField.text = editShoe.brand
            self.shoeBrandPickerCell.detailTextLabel?.text = editShoe.brand
            if editShoe.distanceUnit == "Kilometers" {
                self.shoeDistanceUnit.isEnabledForSegment(at: DistanceUnit.Kilometers.rawValue)
            }
            self.shoeBrandPickerCell.select()
            self.brandProductPickerCell.detailTextLabel?.text = editShoe.model
            self.shoeDistanceUnit.isEnabled = false
            self.shoeModelCell.textField.text = editShoe.model
            self.shoeNicknameCell.textField.text = editShoe.uuid
            self.shoeMileageCell.doubleValue = editShoe.distance
            self.shoeDateCell.date = editShoe.dateAdded! as Date
            self.numberOfWorkouts.integerValue = editShoe.workoutData.count
            self.shoeDistanceLogged.value = editShoe.distanceLoggedFormatted
            self.shoePercentRemaining.value = "\(editShoe.percentRemaining)%"
            self.shoeAvatarColorPIckerCell.detailTextLabel?.text = ModelController.colorNames[Int(editShoe.colorAvatarIndex)]
            self.shoeAvatarColorPIckerCell.detailTextLabel?.textColor = ModelController.colors[Int(editShoe.colorAvatarIndex)]
            if let defaultWorkout = editShoe.defaultWorkout {
                self.defaultPickerCell.detailTextLabel?.text = ModelController.defaultWorkoutTypes[Int(defaultWorkout.type)]
                self.defaultPickerCell.select()
            }
        }
        else {
            //adding new shoe don't need to show a few fields.
            self.numberOfWorkouts.contentView.isHidden = true
            self.shoeDistanceLogged.contentView.isHidden = true
            self.shoePercentRemaining.contentView.isHidden = true
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
    }

    var colorAvatarIndex: Int {
        get {
            return ModelController.colorNames.index(of: (shoeAvatarColorPIckerCell.detailTextLabel?.text)!)!
        }
    }
    
    var distance:Double {
        get {
            return shoeMileageCell.doubleValue
        }
    }
    
    var brand:String {
        get {
            //print(shoeBrandPickerCell.detailTextLabel?.text!)
            return (shoeBrandPickerCell.detailTextLabel?.text)!
            //return shoeBrandCell.value
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
    
    var defaultWorkout: DefaultShoe? {
        get {
            for type in ModelController.defaultWorkoutTypes {
                if self.defaultPickerCell.detailTextLabel?.text! == type.value {
                    
                    return ModelController.sharedInstance.defaultWorkout(forType: type.key)
                }
            }
            return nil
        }
    }
    
    var distanceUnit:DistanceUnit {
        get {
            let distanceUnitInput = DistanceUnit(rawValue: shoeDistanceUnit.selectedSegmentIndex)!
            return distanceUnitInput
        }
    }
    
    @IBAction func validateRequiredData(_ sender: Any) {
        if self.brand.characters.count == 0 || self.brand == "Required" {
            let alert = UIAlertController(title: "Required Data", message: "Brand is required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.popoverPresentationController?.sourceView = self.view
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if self.model.characters.count == 0 || self.model == "Required" {
            let alert = UIAlertController(title: "Required Data", message: "Model/Product Name is required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.popoverPresentationController?.sourceView = self.view
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if self.distance == 0 {
            let alert = UIAlertController(title: "Required Data", message: "Max Distance is required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.popoverPresentationController?.sourceView = self.view
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.performSegue(withIdentifier: "addShoeSave", sender: tableView)
            
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let identifier = segue.identifier {
            if identifier == "shoeWorkouts" {
                let shoeWorkouts = segue.destination as! ShoeWorkoutTableViewController
                shoeWorkouts.shoe = editShoe
            }
        }
    }
    
    func deleteShoe(_ shoe: Shoe) {
        editShoe.delete { (status, error) in
        }
    }
    
    func retireShoe(_ shoe: Shoe) {
        editShoe.retire { (status, error) in
        }
    }
    
}
