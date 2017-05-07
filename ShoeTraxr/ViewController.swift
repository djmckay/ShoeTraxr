//
//  ViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {


    let healthManager:HealthKitManager = HealthKitManager()
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var myShoesButton: UIButton!
    @IBOutlet weak var myRunsButton: UIButton!
    @IBOutlet weak var myWalksButton: UIButton!
    
    
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
                    print("\(String(describing: error))")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()

        // Do any additional setup after loading the view, typically from a nib.
//        myShoesButton.layer.cornerRadius = 10
//        myRunsButton.layer.cornerRadius = 10
//        myWalksButton.layer.cornerRadius = 10
        bannerView.adUnitID = "ca-app-pub-1011036572239562/4571143334"
        bannerView.rootViewController = self
        bannerView.delegate = self as GADBannerViewDelegate
        
        let request = GADRequest()
        request.testDevices = ["90fc3240ee18c02d21731660481c9e7a"]
        
        bannerView.load(request)
        
//        ModelController.sharedInstance.getMostRecentRunningWorkout(completion: { (workout) in
//            if workout != nil {
//                print("send alert")
//                self.checkForRunAlert()
//                
//            }
//            else {
//                ModelController.sharedInstance.getMostRecentWalkingWorkout(completion: { (workout) in
//                    if workout != nil {
//                        print("send alert")
//                        self.checkForWalkAlert()
//
//                    }
//                })
//            }
//        })

    }
    
    func checkForWalkAlert() -> Void {
        let message = NSLocalizedString("Recent Walking Workout Found", comment: "Recent Walking Workout Found")
        let alertController = UIAlertController(title: "ShoeTraxR", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Alert Cancel button"), style: .cancel, handler: nil))

        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ShowWalkingWorkouts", sender: self)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkForRunAlert() -> Void {
        let message = NSLocalizedString("Recent Running Workout Found", comment: "Recent Running Workout Found")
        let alertController = UIAlertController(title: "ShoeTraxR", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ShowRunningWorkouts", sender: self)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        ModelController.sharedInstance.healthManager = self.healthManager

        if let identifier = segue.identifier {
            if identifier == "ShowRunningWorkouts" {
                let runningWorkoutController = segue.destination as! RunningWorkoutTableViewController
                runningWorkoutController.type = healthManager.running
            }
            if identifier == "ShowWalkingWorkouts" {
                let runningWorkoutController = segue.destination as! RunningWorkoutTableViewController
                runningWorkoutController.type = healthManager.walking
            }
            if identifier == "ShowShoes" {
                _ = segue.destination as! ShoeTableViewController
            }
        }
    }
}

