//
//  BrandPickerCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/25/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

class BrandPickerCell: PickerCell {
    var data = ModelController.sharedInstance.brands
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return data[row].name
    }
    
    override func select() {
        for row in 0..<data.count {
        if self.detailTextLabel?.text! == data[row].name! {
            pickerView.selectRow(row, inComponent: 0, animated: true)
        }
    }
}

    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailTextLabel?.text = data[row].name
    }
    
    

}
