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
    var brandSelected: Brand?
    var brandProductPickerCell: ProductPickerCell!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        ModelController.sharedInstance.fetchBrands { (brands, error) in
//            if let brands = brands, brands.count > 0 {
//                self.data = brands
//                self.data.append(Brand(""))
//                self.data.sort { (lhs, rhs) -> Bool in
//                    if lhs < rhs {
//                        return true
//                    }
//                    else {
//                        return false
//                    }
//                }
//                self.data.append(Brand("Other"))
//            }
//        }
    }

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
            brandSelected = data[row]
            DispatchQueue.main.async(execute: {
            self.brandProductPickerCell.addProducts(brand: self.brandSelected!)
            })
        }
    }
}

    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailTextLabel?.text = self.data[row].name!
        self.detailTextLabel?.textColor = UIColor.black
        brandSelected = data[row]
        DispatchQueue.main.async(execute: {
        self.brandProductPickerCell.addProducts(brand: self.brandSelected!)
        })
    }
    
    

}
