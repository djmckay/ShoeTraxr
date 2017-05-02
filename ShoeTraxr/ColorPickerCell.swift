//
//  ColorPickerCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/1/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

class ColorPickerCell: PickerCell {
        
    
    // Delegate/Datasource implementations
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return ModelController.colors.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ModelController.colorNames[row]
    }
    
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailTextLabel?.text = ModelController.colorNames[row]
        self.detailTextLabel?.textColor = ModelController.colors[row]
    }
 
    override func select() {
        for row in 0..<ModelController.colorNames.count {
            if self.detailTextLabel?.text! == ModelController.colorNames[row] {
                pickerView.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
}
