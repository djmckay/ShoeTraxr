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
        // Do any additional setup after loading the view, typically from a nib.
        
        bannerView.adUnitID = "ca-app-pub-1011036572239562/3191605335"
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
        if let identifier = segue.identifier {
            if identifier == "ShowRunningWorkouts" {
                authorizeHealthKit()
                let runningWorkoutController = segue.destination as! RunningWorkoutTableViewController
                runningWorkoutController.healthManager = self.healthManager
                runningWorkoutController.type = healthManager.running
            }
            if identifier == "ShowWalkingWorkouts" {
                authorizeHealthKit()
                let runningWorkoutController = segue.destination as! RunningWorkoutTableViewController
                runningWorkoutController.healthManager = self.healthManager
                runningWorkoutController.type = healthManager.walking
            }
            if identifier == "ShowShoes" {
                authorizeHealthKit()
                let shoeController = segue.destination as! ShoeTableViewController
                shoeController.healthManager = self.healthManager
            }
        }
    }
}

