//
//  ShoeTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

public class ShoeTableViewController: UITableViewController {

    var shoes = [ShoeModel]()
    var modelController:ModelController?
    
    var distanceUnit = DistanceUnit.Miles

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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        if modelController == nil {
            modelController = ModelController()
        }
        
        self.shoes = (modelController?.shoes)!
        
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoes.count
        
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shoe  = shoes[indexPath.row]
        print(shoe.brand)
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoecellid", for: indexPath)
        
        
        // 1. Get workout for the row. Cell text: Workout Date
        let shoe  = shoes[indexPath.row]
        cell.textLabel!.text = shoe.brand
        // Max
        var detailText = "Distance: " + "?" //durationFormatter.string(from: workout.duration)!
        // Distance in Km or miles depending on user selection
        detailText += " Max Distance: \(shoe.distance)"
        cell.detailTextLabel?.text = detailText;

        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    
    override public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("called to delete")
        deleteShoe(shoes[indexPath.row])
        
        
    }

    func deleteShoe(_ shoe: ShoeModel) {
        modelController?.deleteShoe(shoeModel: shoe, completion: { (status, error) in
            self.shoes = (self.modelController?.shoes)!
            self.tableView.reloadData()

        })

    }
    
    @IBAction func addShoe(_ sender: Any) {
        
    }
    
    // MARK: - Segues
    @IBAction func unwindToSegue (_ segue : UIStoryboardSegue) {
        
        if( segue.identifier == "addShoeSave" )
        {
            print("save")

            if let addShoe:AddShoeTableViewController = segue.source as? AddShoeTableViewController {
                let shoe = ShoeModel()
                shoe.brand = addShoe.brand
                shoe.model = addShoe.model
                shoe.uuid = addShoe.nickname
                shoe.distance = addShoe.distance
                shoe.date = addShoe.date!
                modelController?.addShoe(shoeModel: shoe, completion: { (status, error) in
                    print(addShoe.brand)
                    print(addShoe.model)
                    print(self.dateFormatter.string(from: addShoe.date!))
                    print(addShoe.nickname)
                    print(addShoe.distance)
                    self.shoes = (self.modelController?.shoes)!
                    self.tableView.reloadData()
                })
                

            }
        }
        
    }

}
