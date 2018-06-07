//
//  CustomNavegationView.swift
//  Budfie
//
//  Created by Ravi on 30/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit

@IBDesignable
class CustomNavegationView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setSlantView(frame: rect)
    }
    
    func setSlantView(frame:CGRect) {
        
        let clearPath = UIBezierPath()
        clearPath.move(to: CGPoint(x: 0, y: 5))
        clearPath.addLine(to: CGPoint(x: frame.width, y: frame.size.height))
        clearPath.addLine(to: CGPoint(x: 0.0, y: 0.0))
        clearPath.close()
        
        let bluePath = UIBezierPath()
        bluePath.move(to: CGPoint(x: 0.0, y: 5))
        bluePath.addLine(to: CGPoint(x: 0.0, y: frame.size.height+3.0))
        bluePath.addLine(to: CGPoint(x: frame.width + 5.0, y: frame.size.height+3.0))
        bluePath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = clearPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        self.layer.insertSublayer(shapeLayer, at: 0)
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = bluePath.cgPath
        shapeLayer1.fillColor = UIColor.red.cgColor
        self.layer.insertSublayer(shapeLayer1, at: 1)
    }
}
