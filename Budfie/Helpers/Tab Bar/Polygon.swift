//
//  Polygon.swift
//  beziarPath
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import CoreText

class Polygon: UIView {

    func setup(width:CGFloat,height : CGFloat,upDown:Bool) {
        
        // Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        if upDown{
              shapeLayer.path = createBezierPath(width: width, height: height).cgPath
        }else{
            shapeLayer.path = createBezierPath1(width: width, height: height).cgPath
        }
        
        
        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.position = CGPoint(x: 0, y: 0)
        
        // add the new layer to our custom view
        self.layer.addSublayer(shapeLayer)
    }
    func createBezierPath(width:CGFloat,height : CGFloat) -> UIBezierPath {
        let aPath = UIBezierPath()

        // Set the starting point of the shape.
        aPath.move(to: CGPoint(x:width/2, y: 0.0))
        aPath.addLine(to: CGPoint(x: width, y: height/3))
        aPath.addLine(to: CGPoint(x: (width - width/4), y: height))
        aPath.addLine(to: CGPoint(x:  width/4, y: height))
        aPath.addLine(to: CGPoint(x: 0.0, y: height/3))
        aPath.close()
        return aPath
    }

    func createBezierPath1(width:CGFloat,height : CGFloat) -> UIBezierPath {
        let aPath = UIBezierPath()
        
        // Set the starting point of the shape.
        aPath.move(to: CGPoint(x:  width/4, y: 0.0))
        aPath.addLine(to: CGPoint(x: (width - width/4), y: 0.0))
        aPath.addLine(to: CGPoint(x: width, y: height-height/3))
        aPath.addLine(to: CGPoint(x:width/2, y: height))
        aPath.addLine(to: CGPoint(x: 0.0, y: height-height/3))
        aPath.close()
        return aPath
    }


}
