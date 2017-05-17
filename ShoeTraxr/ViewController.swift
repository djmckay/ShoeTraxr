//
//  ViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/17/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit
import GoogleMobileAds
import HealthKit

class ViewController: UIViewController, GADBannerViewDelegate {


    let healthManager:HealthKitManager = HealthKitManager()
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var myShoesButton: UIButton!
    @IBOutlet weak var myRunsButton: UIButton!
    @IBOutlet weak var myWalksButton: UIButton!
//    @IBOutlet weak var circleGraph: RingGraph!

    
    func authorizeHealthKit()
    {
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
                self.healthManager.observeWorkOuts(completion: { (success, error) in
                    if( error != nil )
                    {
                        print("Error observing workouts: \(String(describing: error?.localizedDescription))")
                        return;
                    }
                    else
                    {
                        print("Workouts observed successfully!")
                    }
                })
                /*self.healthManager.observeWalkingWorkouts(completion: { (success, error) in
                    if( error != nil )
                    {
                        print("Error observing workouts: \(String(describing: error?.localizedDescription))")
                        return;
                    }
                    else
                    {
                        print("Walking Workouts observed successfully!")
                    }
                })*/
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
        NotificationManager.authorize { (granted, error) in
            if granted {
                print("notifications granted!")
            } else {
                print("notifications denied")
            }
        }
        
        
        authorizeHealthKit()
        

        // Do any additional setup after loading the view, typically from a nib.
//        myShoesButton.layer.cornerRadius = 10
//        myRunsButton.layer.cornerRadius = 10
//        myWalksButton.layer.cornerRadius = 10
        guard (bannerView != nil) else {
            return
        }
        bannerView.adUnitID = "ca-app-pub-1011036572239562/4571143334"
        bannerView.rootViewController = self
        bannerView.delegate = self as GADBannerViewDelegate
        
        let request = GADRequest()
        request.testDevices = ["90fc3240ee18c02d21731660481c9e7a"]
        
        bannerView.load(request)
        /*let backgroundTrackColor = UIColor(white: 0.15, alpha: 1.0)
        circleGraph.backgroundColor = UIColor.black
        circleGraph.arcBackgroundColor = backgroundTrackColor
        circleGraph.arcWidth = 10.0
        circleGraph.endArc = 0.75
        circleGraph.arcColor = UIColor.blue*/


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        ModelController.sharedInstance.healthManager = self.healthManager

        if  ModelController.sharedInstance.walkingDefault == nil {
            ModelController.sharedInstance.walkingDefault = DefaultShoe()
            ModelController.sharedInstance.walkingDefault?.type = Int16(HKWorkoutActivityType.walking.rawValue)
        }
        if  ModelController.sharedInstance.runningDefault == nil {
            ModelController.sharedInstance.runningDefault = DefaultShoe()
            ModelController.sharedInstance.runningDefault?.type = Int16(HKWorkoutActivityType.running.rawValue)
        }
        
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

