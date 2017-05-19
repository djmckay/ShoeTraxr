//
//  RingGraph.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/13/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit

class RingGraph: UIView {
    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    var arcWidth:CGFloat = 10.0
    var arcColor = UIColor.yellow
    var arcBackgroundColor = UIColor.black
    var viewMargin: CGFloat = 4.0
    
    var maxValue: Double = 0.0 {
        didSet {
            endArc = CGFloat(value / maxValue)
            
        }
    }

    var value: Double = 0.0 {
        didSet {
            endArc = CGFloat(value / maxValue)

        }
    }
    
    override func draw(_ rect: CGRect) {
        
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(Double.pi)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
        
        //find the centerpoint of the rect
        var centerPoint = CGPoint()
        centerPoint.x = rect.midX
        centerPoint.y = rect.midY
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if rect.width < rect.height{
            radius = (rect.width - arcWidth) / 2.0
        }else{
            radius = (rect.height - arcWidth) / 2.0
        }
        radius -= viewMargin
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        let colorspace = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        context!.setLineWidth(arcWidth)
        context?.setLineCap(.round)
        //make the circle background
        
        context!.setStrokeColor(arcBackgroundColor.cgColor)
        
        context?.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: true)
        //CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        context!.strokePath()
        
        //draw the arc
        context!.setStrokeColor(arcColor.cgColor)
        context!.setLineWidth(arcWidth * 0.8 )
        //CGContextSetLineWidth(context, arcWidth)
        context?.addArc(center: centerPoint, radius: radius, startAngle: end, endAngle: start, clockwise: true)
        //CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
        context!.strokePath()
        
    }
    
}
