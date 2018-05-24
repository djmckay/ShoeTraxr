//
//  WorkoutTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/1/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutTableViewController: UITableViewController {

    var modelController:ModelController = ModelController.sharedInstance
    
    var type: HKWorkoutActivityType!
    
    var distanceUnit = DistanceUnit.Miles
    @IBOutlet weak var distanceUnitPicker: UISegmentedControl!
    var selectedWorkout: HKWorkout!
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func unitsChanged(sender:UISegmentedControl) {
        
        distanceUnit  = DistanceUnit(rawValue: sender.selectedSegmentIndex)!
        tableView.reloadData()
        
    }
}
