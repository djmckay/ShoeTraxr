//
//  ShoeWorkoutTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/1/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit
import HealthKit


fileprivate enum SectionIdentifiers: Int  {
    case Running, Walking, Count
}

fileprivate enum DefaultWalkingSectionIdentifiers: Int  {
    case Walking, Running, Count
}

class ShoeWorkoutTableViewController: WorkoutTableViewController {
    var shoe: Shoe!
    var walkingWorkouts = [HKWorkout]()
    var runningWorkouts = [HKWorkout]()
    var walkingShoeDefaultType: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        if shoe != nil {
            
            self.title = shoe.getTitle()
            
            distanceUnit = shoe.distanceUnitType
            self.distanceUnitPicker.selectedSegmentIndex = shoe.distanceUnitType.rawValue
            if shoe.defaultWorkout?.type == Int16(HKWorkoutActivityType.walking.rawValue) {
                walkingShoeDefaultType = true
            }
            ModelController.sharedInstance.getRunningWorkouts { workouts in
                self.runningWorkouts = self.shoe.getRunningHKWorkouts()
                print(self.runningWorkouts.count)
                ModelController.sharedInstance.getWalkingWorkouts { workouts in
                    self.walkingWorkouts = self.shoe.getWalkingHKWorkouts()
                    print(self.walkingWorkouts.count)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
            
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionIdentifiers.Count.rawValue
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if walkingShoeDefaultType {
            switch section {
            case DefaultWalkingSectionIdentifiers.Running.rawValue:
                return "Running (\(runningWorkouts.count))"
                
            case DefaultWalkingSectionIdentifiers.Walking.rawValue:
                return "Walking (\(walkingWorkouts.count))"
            default:
                return "missing section \(section)"
            }
        } else {
            
            switch section {
            case SectionIdentifiers.Running.rawValue:
                return "Running (\(runningWorkouts.count))"
                
            case SectionIdentifiers.Walking.rawValue:
                return "Walking (\(walkingWorkouts.count))"
            default:
                return "missing section \(section)"
            }
        }
        
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footerText = String()
        
        var workouts: [HKWorkout]!
        
        if walkingShoeDefaultType {
            switch section {
            case DefaultWalkingSectionIdentifiers.Running.rawValue:
                workouts = runningWorkouts
                footerText += "Running Total: "
            case DefaultWalkingSectionIdentifiers.Walking.rawValue:
                workouts = walkingWorkouts
                footerText += "Walking Total: "
            default:
                break
            }
        } else {
            switch section {
            case SectionIdentifiers.Running.rawValue:
                workouts = runningWorkouts
                footerText += "Running Total: "
            case SectionIdentifiers.Walking.rawValue:
                workouts = walkingWorkouts
                footerText += "Walking Total: "
            default:
                break
            }
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
        if walkingShoeDefaultType {
            switch section {
            case DefaultWalkingSectionIdentifiers.Running.rawValue:
                return runningWorkouts.count
                
            case DefaultWalkingSectionIdentifiers.Walking.rawValue:
                return walkingWorkouts.count
            default:
                return 0
            }
            
        } else {
            switch section {
            case SectionIdentifiers.Running.rawValue:
                return runningWorkouts.count
                
            case SectionIdentifiers.Walking.rawValue:
                return walkingWorkouts.count
            default:
                return 0
            }
        }
        
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcellid", for: indexPath)
        
        
        // 1. Get workout for the row. Cell text: Workout Date
        var workout:HKWorkout!
        
        if walkingShoeDefaultType {
            switch indexPath.section {
            case DefaultWalkingSectionIdentifiers.Running.rawValue:
                workout = runningWorkouts[indexPath.row]
            case DefaultWalkingSectionIdentifiers.Walking.rawValue:
                workout = walkingWorkouts[indexPath.row]
            default:
                break
            }
        } else {
            switch indexPath.section {
            case SectionIdentifiers.Running.rawValue:
                workout = runningWorkouts[indexPath.row]
                
            case SectionIdentifiers.Walking.rawValue:
                workout = walkingWorkouts[indexPath.row]
            default:
                break
            }
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
