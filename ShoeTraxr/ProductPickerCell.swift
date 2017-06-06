//
//  ProductPickerCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 6/6/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit

class ProductPickerCell: PickerCell {
    var data = [Product]()
    var otherModelCell: TextCell!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        ModelController.sharedInstance.fetchBrands { (brands, error) in
//            if let brands = brands, brands.count > 0 {
//                self.data = brands
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
            if self.detailTextLabel?.text! == data[row].name {
                pickerView.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async(execute: {
        self.detailTextLabel?.text = self.data[row].name
        self.detailTextLabel?.textColor = UIColor.black
        })
        
    }
    
    func addProducts(brand: Brand) {
        
        ModelController.sharedInstance.fetchProducts(brand: brand, { (products, error) in
                if var products = products, products.count > 0 {
                    
                    products.sort { (lhs, rhs) -> Bool in
                        if lhs < rhs {
                            return true
                        }
                        else {
                            return false
                        }
                    }
                    products.append(Product("Other"))
                    
                    
                    self.data = products
                    DispatchQueue.main.async(execute: {
                        self.isHidden = false
                        self.select()
                    })
                } else {
                    self.data.removeAll()
                    DispatchQueue.main.async(execute: {

                    self.isHidden = true
                    self.detailTextLabel?.text = ""
                    })
            }
                
            })
    }
    
}
