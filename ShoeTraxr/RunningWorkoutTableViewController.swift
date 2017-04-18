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
    
    let kAddWorkoutReturnOKSegue = "addWorkoutOKSegue"
    let kAddWorkoutSegue  = "addWorkoutSegue"
    
    var distanceUnit = DistanceUnit.Miles
    var healthManager:HealthKitManager?
    var workouts = [HKWorkout]()
    
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
        
        healthManager?.readRunningWorkOuts(completion: { (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(error?.localizedDescription)")
                return;
            }
            else
            {
                print("Workouts read successfully!")
            }
            
            //Kkeep workouts and refresh tableview in main thread
            self.workouts = results as! [HKWorkout]
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
        })
        
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
        
        healthManager?.readRunningWorkOuts(completion: { (results, error) -> Void in
            if( error != nil )
            {
                print("Error reading workouts: \(error?.localizedDescription)")
                return;
            }
            else
            {
                print("Workouts read successfully!")
            }
            
            //Kkeep workouts and refresh tableview in main thread
            self.workouts = results as! [HKWorkout]
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
        })
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
        
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout  = workouts[indexPath.row]
        print(workout.uuid)
        print(workout.description)
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcellid", for: indexPath) 
        
        
        // 1. Get workout for the row. Cell text: Workout Date
        let workout  = workouts[indexPath.row]
        let startDate = dateFormatter.string(from: workout.startDate)
        cell.textLabel!.text = startDate
        
        // 2. Detail text: Duration - Distance
        // Duration
        var detailText = "Duration: " + durationFormatter.string(from: workout.duration)!
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
        // 3. Detail text: Energy Burned
        let energyBurned = workout.totalEnergyBurned?.doubleValue(for: HKUnit.joule())
        detailText += " Energy: " + energyFormatter.string(fromJoules: energyBurned!)
        cell.detailTextLabel?.text = detailText;
        
        return cell
    }
    
    
    
}
