//
//  AssignShoeWorkoutTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit

public class AssignShoeWorkoutTableViewController: ShoeTableViewController {
    var selectedShoe:Shoe!
    var workout:Workout!

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedShoe != nil {
            selectedShoe.removeFromWorkouts(workout)
        }
        selectedShoe  = shoes[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        print(selectedShoe.brand!)
        self.performSegue(withIdentifier: "selectShoeOK", sender: tableView)
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if selectedShoe != nil && selectedShoe == shoes[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }

}
