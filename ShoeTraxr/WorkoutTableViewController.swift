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
    var workouts = [HKWorkout]()
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

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
        
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcellid", for: indexPath)
        
        
        // 1. Get workout for the row. Cell text: Workout Date
        let workout  = workouts[indexPath.row]
        let startDate = dateFormatter.string(from: workout.startDate)
        cell.textLabel!.text = startDate
        
        // 2. Detail text: Duration - Distance
        // Duration
        //var detailText = "Duration: " + durationFormatter.string(from: workout.duration)!
        // Distance in Km or miles depending on user selection
        var detailText = String()
        
        if workout.workoutActivityType == .running {
            detailText += " Ran "
            
        } else if workout.workoutActivityType == .walking {
            detailText += " Walked "
            
        }
        if distanceUnit == .Kilometers {
            let distanceInKM = workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo))
            detailText += distanceFormatter.string(fromValue: distanceInKM!, unit: LengthFormatter.Unit.kilometer)
        }
        else {
            let distanceInMiles = workout.totalDistance?.doubleValue(for: HKUnit.mile())
            detailText += distanceFormatter.string(fromValue: distanceInMiles!, unit: LengthFormatter.Unit.mile)
            
        }
        // 3. Detail text: Energy Burned
        //        let energyBurned = workout.totalEnergyBurned?.doubleValue(for: HKUnit.joule())
        //        detailText += " Energy: " + energyFormatter.string(fromJoules: energyBurned!)
        
        

        cell.detailTextLabel?.text = detailText
        
        cell.accessoryType = .none
        let shoeAvatar = cell.viewWithTag(1) as! UIImageView
        shoeAvatar.isHidden = true
        if let workout = modelController.getWorkout(hkWorkout: workout) {
            shoeAvatar.isHidden = false
            shoeAvatar.backgroundColor = UIColor.green
            if let shoe = workout.shoe {
                detailText += " Shoe: " + shoe.getTitle()
                cell.detailTextLabel?.text = detailText
            }
        }
        //        for shoeLoggedWorkout in (modelController?.workouts)! {
        //            if shoeLoggedWorkout.uuid == workout.uuid.uuidString {
        //               cell.accessoryType = .checkmark
        //                shoeAvatar.isHidden = false
        //                shoeAvatar.backgroundColor = UIColor.green
        //            }
        //        }
        return cell
    }

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
