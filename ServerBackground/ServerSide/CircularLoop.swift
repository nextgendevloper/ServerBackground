//
//  CircularLoop.swift
//  Example
//
//  Created by zmobile on 19/12/22.
//

import Foundation
import UIKit
import CoreGraphics
import Darwin


class CircularProgressBarView: UIView {
    
    
    let pi = 3.14
    var circleLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var circleValue:CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
      layer.addSublayer(circleLayer)
     layer.addSublayer(progressLayer)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)

    }
    
    
    
    
    override func draw(_ rect: CGRect) {
         super.draw(rect)
        layoutIfNeeded()
        createCircularPath()
    }

    
    func reCalculatedEndAngleInPercentage(value:CGFloat)->CGFloat{
        let maxAngle = ((2)*3.14)
        var newValue = (value*maxAngle)/100
        if circleValue == 0.0{
            progressLayer.fillColor = UIColor.white.cgColor
        }
        return newValue
    }
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2 ), radius: self.frame.width/2, startAngle: 0, endAngle: 6.28, clockwise: true)
            // circleLayer path defined to circularPath
           circleLayer.path = circularPath.cgPath
            // ui edits
            circleLayer.fillColor = UIColor.white.cgColor
            // added circleLayer to layer
       
        let circularPath2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2 ), radius: self.frame.width/2, startAngle: 0, endAngle: reCalculatedEndAngleInPercentage(value: circleValue), clockwise: false)
            // circularPath2.close()
            circularPath2.addLine(to: CGPoint(x: self.frame.width/2, y: self.frame.height/2 ))
            // progressLayer path defined to circularPath
            progressLayer.path = circularPath2.cgPath
            progressLayer.fillColor = UIColor.green.cgColor
        
        }
   
}
