//
//  ViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    let healthManager:HealthKitManager = HealthKitManager()
    
    
    func authorizeHealthKit()
    {
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
            }
            else
            {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowRunningWorkouts" {
                authorizeHealthKit()
                let runningWorkoutController = segue.destination as! RunningWorkoutTableViewController
                runningWorkoutController.healthManager = self.healthManager
            }
            if identifier == "ShowShoes" {
                authorizeHealthKit()
                let shoeController = segue.destination as! ShoeTableViewController
                shoeController.healthManager = self.healthManager
            }
        }
    }
}

