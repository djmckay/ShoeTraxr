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
        var foundMatch: Bool = false
        for row in 0..<data.count {
            if self.detailTextLabel?.text! == data[row].name {
                foundMatch = true
                pickerView.selectRow(row, inComponent: 0, animated: true)
                DispatchQueue.main.async(execute: {
                if self.detailTextLabel?.text == "Other" {
                    self.otherModelCell.contentView.isHidden = false
                    if self.otherModelCell.textField.text == "Other" {
                        self.otherModelCell.textField.text = "Required"
                    }
                } else {
                    self.otherModelCell.contentView.isHidden = true
                }
                })
            }
        }
        if !foundMatch {
            self.detailTextLabel?.text = "Other"
        }
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async(execute: {
            if self.data.count > 0 {
                self.detailTextLabel?.text = self.data[row].name
                self.otherModelCell.textField.text = self.detailTextLabel?.text
                self.detailTextLabel?.textColor = UIColor.black
                if self.detailTextLabel?.text == "Other" {
                    self.otherModelCell.contentView.isHidden = false
                    if self.otherModelCell.textField.text == "Other" {
                        self.otherModelCell.textField.text = "Required"
                    }
                } else {
                    self.otherModelCell.contentView.isHidden = true
                }
            }
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
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //                    self.isHidden = true
                    self.data.removeAll()
                    self.data.append(Product("Other"))
                    self.detailTextLabel?.text = "Other"
                    
                })
            }
            DispatchQueue.main.async(execute: {
                self.pickerView.reloadAllComponents()
                self.select()

            })
        })
    }
    
}
