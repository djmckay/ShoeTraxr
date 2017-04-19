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
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShoe  = shoes[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        print(selectedShoe.brand!)
        self.performSegue(withIdentifier: "selectShoeOK", sender: tableView)
    }
}
