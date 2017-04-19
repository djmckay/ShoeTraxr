//
//  NumberCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit

class NumberCell: UITableViewCell {
    
    @IBOutlet var numberTextField:UITextField!
    
    var doubleValue:Double {
        
        get {
            let numberString:NSString = NSString(string:numberTextField.text!)
            return numberString.doubleValue;
        }
        set (newValue) {
            numberTextField.text = "\(newValue)"
        }
    }
    
    var integerValue:Int {
        
        get {
            let numberString:NSString = NSString(string:numberTextField.text!)
            return numberString.integerValue;
        }
        set (newValue) {
            numberTextField.text = "\(newValue)"
        }
    }
}
