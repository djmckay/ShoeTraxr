//
//  PickerTextField.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/21/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerView: UIPickerView
    
    
    required init?(coder aDecoder: NSCoder) {
        pickerView = UIPickerView()

        super.init(coder: aDecoder)
        pickerView.delegate = self
        //pickerView.dataSource = self
        self.inputView = pickerView
        
        
        
    }
        

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "row"
    }

    
}
