//
//  DefaultPickerCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/13/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit


class DefaultPickerCell: PickerCell {
    var data = ["None", "Running", "Walking", "Running+Walking"]
    var dataColor = [UIColor.white, UIColor.yellow, UIColor.cyan, UIColor(colorLiteralRed: 0, green: 0.6062946, blue: 0.752984, alpha: 1)]
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    override func select() {
        for row in 0..<data.count {
            if self.detailTextLabel?.text! == data[row] {
                pickerView.selectRow(row, inComponent: 0, animated: true)
                self.detailTextLabel?.textColor = self.dataColor[row]
            }
        }
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailTextLabel?.text = self.data[row]
        self.detailTextLabel?.textColor = self.dataColor[row]

    }


}
