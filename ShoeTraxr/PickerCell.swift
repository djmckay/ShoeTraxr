//
//  PickerCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/19/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

class PickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    let toolBar = UIToolbar()

    let pickerView: UIPickerView
    
    
    required init?(coder aDecoder: NSCoder) {
        pickerView = UIPickerView()
        super.init(coder: aDecoder)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PickerCell.resignFirstResponder))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
    }
    
    open override var inputAccessoryView: UIView? {
        get {
            return toolBar
        }
    }

    open override var canBecomeFirstResponder : Bool {
        return true;
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if( selected ) {
            self.becomeFirstResponder()
            self.select()
        }
        
    }
    
    open override var inputView: UIView! {
        get {
            return pickerView
        }
    }
        
    // Delegate/Datasource implementations
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "row"
    }
    
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailTextLabel?.text = "row"
    }
    

    func select() {
    }
    
}
