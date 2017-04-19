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
    
    let pickerView: UIPickerView
    
    convenience init() {
        
        let size = CGSize(width: 320, height: 216)
        let origin = CGPoint(x: 0, y: 0)
        let frame = CGRect(origin: origin, size: size)
        self.init()
        //self.init(frame: frame)
    }
    
//    override init(frame: CGRect) {
//        
//        pickerView = UIPickerView(frame: frame)
//        
//        super.init(frame: frame)
//        commonInit()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        
        pickerView = UIPickerView()
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: pickerView, attribute: .top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: pickerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: pickerView, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: pickerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        self.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
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
}
