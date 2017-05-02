//
//  ShoeWorkoutTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/1/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit
import HealthKit

class ShoeWorkoutTableViewController: WorkoutTableViewController {
    var shoe: Shoe!
    var walkingWorkouts = [HKWorkout]()
    var runningWorkouts = [HKWorkout]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if shoe != nil {
            self.walkingWorkouts = shoe.getWalkingHKWorkouts()
            self.runningWorkouts = shoe.getRunningHKWorkouts()
            
            self.title = shoe.getTitle()
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Walking (\(walkingWorkouts.count))"
        }
        else {
            return "Running (\(runningWorkouts.count))"
        }
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footerText = String()

        var workouts: [HKWorkout]!
        if section == 0 {
            workouts = walkingWorkouts
            footerText += "Walking Total: "

        }
        else {
            workouts = runningWorkouts
            footerText += "Running Total: "

        }
        var distanceInKM: Double = 0.0
        var distanceInMiles: Double = 0.0

        for workout in workouts {
            if distanceUnit == .Kilometers {
                distanceInKM += (workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo)))!
            }
            else {
                distanceInMiles += (workout.totalDistance?.doubleValue(for: HKUnit.mile()))!
                
            }
        }
        
        if distanceUnit == .Kilometers {
            footerText += distanceFormatter.string(fromValue: distanceInKM, unit: LengthFormatter.Unit.kilometer)
        }
        else {
            footerText += distanceFormatter.string(fromValue: distanceInMiles, unit: LengthFormatter.Unit.mile)
            
        }
         return footerText
        
    }

    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return walkingWorkouts.count
        }
        else {
            return runningWorkouts.count
        }
        
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcellid", for: indexPath)
        
        
        // 1. Get workout for the row. Cell text: Workout Date
        var workout:HKWorkout!
        if indexPath.section == 0 {
            workout = walkingWorkouts[indexPath.row]
        }
        else {
            workout = runningWorkouts[indexPath.row]
        }
        //let workout  = workouts[indexPath.row]
        let startDate = dateFormatter.string(from: workout.startDate)
        cell.textLabel!.text = startDate
        
        var detailText = String()

        // 2. Detail text: Duration - Distance
        
        // Distance in Km or miles depending on user selection
        
        detailText += " Distance: "
        
        if distanceUnit == .Kilometers {
            let distanceInKM = workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo))
            detailText += distanceFormatter.string(fromValue: distanceInKM!, unit: LengthFormatter.Unit.kilometer)
        }
        else {
            let distanceInMiles = workout.totalDistance?.doubleValue(for: HKUnit.mile())
            detailText += distanceFormatter.string(fromValue: distanceInMiles!, unit: LengthFormatter.Unit.mile)
            
        }
        
        // Duration
        detailText += " Duration: " + durationFormatter.string(from: workout.duration)!
        
        // 3. Detail text: Energy Burned
        //        let energyBurned = workout.totalEnergyBurned?.doubleValue(for: HKUnit.joule())
        //        detailText += " Energy: " + energyFormatter.string(fromJoules: energyBurned!)
        
        
        
        cell.detailTextLabel?.text = detailText
        
        cell.accessoryType = .none
        let shoeAvatar = cell.viewWithTag(1) as! UIImageView
        shoeAvatar.isHidden = true
        shoeAvatar.backgroundColor = UIColor.white

        if let workout = modelController.getWorkout(hkWorkout: workout) {
            shoeAvatar.isHidden = false
            if let shoe = workout.shoe {
                //detailText += " Shoe: " + shoe.getTitle()
                cell.detailTextLabel?.text = detailText
                shoeAvatar.backgroundColor = ModelController.colors[Int(shoe.colorAvatarIndex)]

            }
        }
        
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

}
