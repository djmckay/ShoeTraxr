//
//  ShoeTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

public enum ShoeTypes:Int {
    case Active=0, Retired=1
}

public class ShoeTableViewController: UITableViewController {

    var shoes = [Shoe]()
    var retiredShoes = [Shoe]()

    var modelController:ModelController?
    
    var distanceUnit = DistanceUnit.Miles
    var shoeType = ShoeTypes.Active
    var editShoe: Shoe!
    
    // MARK: - Formatters
    lazy var dateFormatter:DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter;
        
    }()

    let durationFormatter = DateComponentsFormatter()
    let energyFormatter = EnergyFormatter()
    let distanceFormatter = LengthFormatter()
    
    
    @IBAction func unitsChanged(sender:UISegmentedControl) {
        
        shoeType  = ShoeTypes(rawValue: sender.selectedSegmentIndex)!
        tableView.reloadData()
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        if modelController == nil {
            modelController = ModelController.sharedInstance
        }
        
        self.shoes = (modelController?.shoes)!
        self.retiredShoes = (modelController?.retiredShoes)!
        
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shoeType == .Active {
            return shoes.count
        }
        else {
            return retiredShoes.count
        }
        
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (shoeType == .Active) {
             editShoe = shoes[indexPath.row]
        }
        else {
            editShoe = retiredShoes[indexPath.row]
        }
        self.performSegue(withIdentifier: "editShoeDetails", sender: tableView)
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoecellid", for: indexPath)
        
        var shoe: Shoe!
        // 1. Get workout for the row. Cell text: Workout Date
        if shoeType == .Active {
            shoe  = shoes[indexPath.row]
        }
        else {
            shoe = retiredShoes[indexPath.row]
        }
        
        cell.textLabel!.text = shoe.brand! + " " + shoe.model!
        if (shoe.uuid?.characters.count)! > 0 {
            cell.textLabel!.text = shoe.uuid

        }
        
        var detailText = "Distance: "
        
        // Max
        // Distance in Km or miles depending on user selection
        
        if shoe.distanceUnit == "Kilometers" {
            
            var distanceInKM = shoe.distanceLogged
            detailText += distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.kilometer)
            detailText += " Max Distance: "

            distanceInKM = shoe.distance
            detailText += distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.kilometer)
        }
        else {
            var distanceInMiles = shoe.distanceLogged
            detailText += distanceFormatter.string(fromValue: distanceInMiles, unit: LengthFormatter.Unit.mile)
            detailText += " Max Distance: "

            distanceInMiles = shoe.distance
            detailText += distanceFormatter.string(fromValue: distanceInMiles, unit: LengthFormatter.Unit.mile)
            
        }
        cell.detailTextLabel?.text = detailText;

        cell.backgroundColor = UIColor.clear
        if shoe.distanceLogged >= shoe.distance {
            cell.backgroundColor = UIColor.red
        }
        

        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if (shoeType == .Active) {
            return "Retire"
        } else {
            return "Delete"
        }
    }
    
    
    override public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (shoeType == .Retired) {
            deleteShoe(retiredShoes[indexPath.row])
        } else {
            retireShoe(shoes[indexPath.row])
        }
        
    }

    func deleteShoe(_ shoe: Shoe) {
        shoe.delete { (status, error) in
            self.shoes = (self.modelController?.shoes)!
            self.retiredShoes = (self.modelController?.retiredShoes)!
            self.tableView.reloadData()
        }
    }
    
    func retireShoe(_ shoe: Shoe) {
        shoe.retire { (status, error) in
            self.shoes = (self.modelController?.shoes)!
            self.retiredShoes = (self.modelController?.retiredShoes)!
            self.tableView.reloadData()
        }
    }

    
    @IBAction func addShoe(_ sender: Any) {
        editShoe = nil
    }
    
    // MARK: - Segues
    @IBAction func unwindToSegue (_ segue : UIStoryboardSegue) {
        
        if( segue.identifier == "addShoeSave" )
        {

            if let addShoe:AddShoeTableViewController = segue.source as? AddShoeTableViewController {
                if editShoe == nil {
                    editShoe = Shoe()

                }
                editShoe.brand = addShoe.brand
                editShoe.model = addShoe.model
                editShoe.uuid = addShoe.nickname
                editShoe.distance = addShoe.distance
                editShoe.colorAvatarIndex = Int16(addShoe.colorAvatarIndex)
                editShoe.distanceUnit = "Miles"
                if addShoe.distanceUnit == .Kilometers {
                    editShoe.distanceUnit = "Kilometers"
                }

                editShoe.dateAdded = addShoe.date! as NSDate
                if editShoe.retired && editShoe.distance > editShoe.distanceLogged {
                    editShoe.unRetire(completion: nil)
                }
                self.shoes = (self.modelController?.shoes)!
                self.retiredShoes = (self.modelController?.retiredShoes)!
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                

            }
        }
        
        
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "editShoeDetails" {
                let navigation = segue.destination as! UINavigationController
                let editShoeDetails = navigation.viewControllers[0] as! AddShoeTableViewController
                editShoeDetails.editShoe = self.editShoe

            }
        }
    }
    
}
