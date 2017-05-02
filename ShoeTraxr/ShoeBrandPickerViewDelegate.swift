//
//  ShoeBrandPickerViewDataSource.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/25/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

class ShoeBrandPickerViewDelegate: PickerTextField {
    
    public override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    public override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 10
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "shoe brand \(row)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("shoe brand \(row)")
        self.text = "shoe brand \(row)"
    }
}
