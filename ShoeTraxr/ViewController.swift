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
                self.healthManager.observeRunningWorkOuts(completion: { (success, error) in
                    if( error != nil )
                    {
                        print("Error observing workouts: \(String(describing: error?.localizedDescription))")
                        return;
                    }
                    else
                    {
                        print("Running Workouts observed successfully!")
                    }
                })
                self.healthManager.observeWalkingWorkouts(completion: { (success, error) in
                    if( error != nil )
                    {
                        print("Error observing workouts: \(String(describing: error?.localizedDescription))")
                        return;
                    }
                    else
                    {
                        print("Running Workouts observed successfully!")
                    }
                })
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

