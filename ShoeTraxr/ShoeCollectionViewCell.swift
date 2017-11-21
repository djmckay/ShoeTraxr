//
//  ShoeCollectionViewCell.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/14/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit
import HealthKit

class ShoeCollectionViewCell: UICollectionViewCell {
 
    let orbitBlue = UIColor(colorLiteralRed: 0, green: 0.6062946, blue: 0.752984, alpha: 1)

    var ring: RingGraph = RingGraph()
    var shoe: Shoe!
    var longPressCallback: ((_ shoe: Shoe) -> Void)? {
        didSet {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ShoeCollectionViewCell.callback))
            longPress.minimumPressDuration = 0.5
            longPress.delaysTouchesBegan = true
            //longPress.delegate = self
            self.addGestureRecognizer(longPress)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func commonSetup() {
        self.backgroundColor = UIColor.black

        
        let backgroundTrackColor = UIColor(white: 0.5, alpha: 1.0)
        
        ring = self.viewWithTag(2)! as! RingGraph
//        ringView.addSubview(ring)
        //self.backgroundView = ring
         ring.backgroundColor = UIColor.black
         ring.arcBackgroundColor = backgroundTrackColor
         ring.arcWidth = 10.0
         ring.endArc = 0.75
        
         ring.arcColor = UIColor.blue
        
        ring.arcColor = UIColor(colorLiteralRed: 0, green: 0.478431, blue: 1, alpha: 1)
        
    }
    
    func callback() {
        longPressCallback!(shoe)
    }
    
    func setupShoe(shoe: Shoe) {
        //let endArc = CGFloat(shoe.distanceLogged / shoe.distance)
        ring.maxValue = shoe.distance
        for count in 0..<Int(shoe.distanceLogged) {
            ring.value = Double(count)
            //ring.endArc = CGFloat(count / Int(shoe.distance))
        }
        //ring.endArc = CGFloat(shoe.distanceLogged / shoe.distance)
        ring.value = shoe.distanceLogged

        ring.arcColor = ModelController.colors[Int(shoe.colorAvatarIndex)].withAlphaComponent(0.75)
        
        if ring.endArc > 1.0 {
            ring.arcColor = ring.arcColor.withAlphaComponent(1.0)
        }
        var shoeName = self.viewWithTag(1) as! UILabel
        var details = String()
        details += shoe.getTitle()
        shoeName.textColor = UIColor.white
        if shoe.defaultWorkout?.type == Int16(HKWorkoutActivityType.walking.rawValue) {
            shoeName.textColor = UIColor.cyan
        }
        else if shoe.defaultWorkout?.type == Int16(HKWorkoutActivityType.running.rawValue) {
            shoeName.textColor = UIColor.yellow
        }
        else if shoe.defaultWorkout?.type == Int16(HKWorkoutActivityType.other.rawValue) {
            shoeName.textColor = UIColor.gray
        }
        shoeName.text = details
        self.shoe = shoe
        
        //ring.arcColor = ModelController.colors[Int(shoe.colorAvatarIndex)]
    }
    
    
}
