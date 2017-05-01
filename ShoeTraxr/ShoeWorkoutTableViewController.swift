//
//  ShoeWorkoutTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/1/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit

class ShoeWorkoutTableViewController: WorkoutTableViewController {
    var shoe: Shoe!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.workouts =  shoe.getHKWorkouts()
        self.title = shoe.getTitle()
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
