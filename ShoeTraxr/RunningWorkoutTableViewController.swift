//
//  RunningWorkoutTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit
import HealthKit

public enum DistanceUnit:Int {
    case Miles=0, Kilometers=1
}

public class RunningWorkoutTableViewController: UITableViewController {
    var modelController:ModelController?

    var type: HKWorkoutActivityType!
    
    let kAddWorkoutReturnOKSegue = "addWorkoutOKSegue"
    let kAddWorkoutSegue  = "addWorkoutSegue"
    
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
    
    // MARK: - Class Implementation
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        if modelController == nil {
            modelController = ModelController.sharedInstance
        }
        
        if type == HKWorkoutActivityType.running {
            self.workouts = (modelController?.runningHKWorkouts)!
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })

        } else if type == HKWorkoutActivityType.walking {
            self.workouts = (modelController?.walkingHKWorkouts)!
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })

        }
        
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func unitsChanged(sender:UISegmentedControl) {
        
        distanceUnit  = DistanceUnit(rawValue: sender.selectedSegmentIndex)!
        tableView.reloadData()
        
    }
    
    public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
        
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWorkout  = workouts[indexPath.row]
        self.performSegue(withIdentifier: "assignShoe", sender: tableView)

    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if type == HKWorkoutActivityType.walking {
            return "Walking (\(workouts.count))"
        }
        else {
            return "Running (\(workouts.count))"
        }
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footerText = String()
        
        if type == HKWorkoutActivityType.walking {
            footerText += "Walking Total: "
            
        }
        else {
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
        detailText += " Distance: "
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
        shoeAvatar.backgroundColor = UIColor.white

        if let workout = modelController?.getWorkout(hkWorkout: workout) {
            if let shoe = workout.shoe {
                shoeAvatar.isHidden = false
                detailText += " Shoe: " + shoe.getTitle()
                cell.detailTextLabel?.text = detailText
                shoeAvatar.backgroundColor = ModelController.colors[Int(shoe.colorAvatarIndex)]

            }
            else {
                cell.accessoryType = .checkmark
            }
        }

        return cell
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "assignShoe" {
                let navigation = segue.destination as! UINavigationController
                let assignShoe = navigation.viewControllers[0] as! AssignShoeWorkoutTableViewController
                if let shoeLoggedWorkout = modelController?.getWorkout(hkWorkout: selectedWorkout) {
                    assignShoe.selectedShoe = shoeLoggedWorkout.shoe
                    assignShoe.workout = shoeLoggedWorkout
                }

            }
        }
    }
    
    // MARK: - Segues
    @IBAction func unwindToSegue (_ segue : UIStoryboardSegue) {
        
        if( segue.identifier == "selectShoeOK" )
        {
            
            if let assignShoe:AssignShoeWorkoutTableViewController = segue.source as? AssignShoeWorkoutTableViewController {
                var workout: Workout!
                if let existingWorkout = modelController?.getWorkout(hkWorkout: selectedWorkout) {
                    workout = existingWorkout
                } else {
                    workout = Workout()
                    workout.uuid = selectedWorkout.uuid.uuidString
                }

                
                if assignShoe.selectedShoe.distanceUnitType == .Kilometers {
                    workout.distance = (selectedWorkout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo)))!
                }
                else {
                    workout.distance = (selectedWorkout.totalDistance?.doubleValue(for: HKUnit.mile()))!
                    
                }

                assignShoe.selectedShoe.addToWorkouts(workout)
                modelController?.workouts.append(workout)
                DispatchQueue.main.async(execute: {
                    if assignShoe.selectedShoe.distanceLogged >= assignShoe.selectedShoe.distance {
                        let alert = UIAlertController(title: assignShoe.selectedShoe.getTitle(), message: "Shoe has exceeded allowed limit of \(assignShoe.selectedShoe.distanceFormatted).  Consider retiring.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.popoverPresentationController?.sourceView = self.view
                        
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Retire", style: UIAlertActionStyle.default, handler: { action in
                            assignShoe.selectedShoe.retire(completion: { (status, error) in
                                self.tableView.reloadData()
                            })
                        }))

                        self.present(alert, animated: true, completion: nil)
                    }
                    self.tableView.reloadData()
                })
                
            }
        }
    }
    
    
    
}
