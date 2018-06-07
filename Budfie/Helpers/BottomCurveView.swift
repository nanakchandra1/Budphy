//
//  BottomCurveView.swift
//  Budfie
//
//  Created by Aakash Srivastav on 16/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class BottomCurveView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let height = rect.height
        let width = rect.width
        let curveHeight = CurvedNavigationView.curveHeight

        let aPath = UIBezierPath()

        aPath.move(to: CGPoint(x: 0, y: height))

        aPath.addCurve(to: CGPoint(x: width, y: height),
                       controlPoint1: CGPoint(x: ((width / 8) * 2.5), y: (height - curveHeight)),
                       controlPoint2: CGPoint(x: ((width / 8) * 5.3), y: (height - curveHeight)))

        aPath.close()

        UIColor.white.setFill()
        aPath.fill()
    }
}
