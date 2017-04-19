//
//  TextCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    
    @IBOutlet var textField:UITextField!
    
    var value:String {
        
        get {
            return textField.text!
        }
        set (newValue) {
            textField.text = "\(newValue)"
        }
    }
}
