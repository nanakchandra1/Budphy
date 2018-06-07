//
//  ReverseCurvedView.swift
//  Budfie
//
//  Created by Aakash Srivastav on 23/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class ReverseCurvedView: UIView {
    
    public var backFillColor : UIColor = AppColors.themeLightBlueColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)

        let height = rect.height
        let width = rect.width
        let curveHeight = (CurvedNavigationView.curveHeight - 5)

        let expectedRadius: CGFloat = 4
        let numberOfArcs = Int(width/expectedRadius)
        let actualRadius = (expectedRadius + (width.truncatingRemainder(dividingBy: expectedRadius) / CGFloat(numberOfArcs)))

        let aPath = UIBezierPath()

        aPath.move(to: CGPoint(x: 0, y: height))
        aPath.addLine(to: CGPoint(x: 0, y: curveHeight))

        aPath.addCurve(to: CGPoint(x: width, y: curveHeight),
                       controlPoint1: CGPoint(x: ((width / 8) * 2.5), y: 0),
                       controlPoint2: CGPoint(x: ((width / 8) * 5.3), y: 0))

        aPath.addLine(to: CGPoint(x: width, y: (height - actualRadius)))

        var xCoordinate = width

        for _ in 0..<numberOfArcs {
            aPath.addArc(withCenter: CGPoint(x: (xCoordinate - actualRadius), y: (height - actualRadius)), radius: actualRadius, startAngle: 0.toRadians, endAngle: 180.toRadians, clockwise: true)
            xCoordinate -= (actualRadius * 2)
        }

        aPath.close()

        self.backFillColor.setFill()
        aPath.fill()
    }

}

extension Int {
    var toRadians: CGFloat { return (CGFloat(self) * CGFloat.pi / 180) }
    var toDegrees: CGFloat { return (CGFloat(self) * 180 / CGFloat.pi) }
}
