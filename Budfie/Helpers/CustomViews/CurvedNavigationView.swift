//
//  CurvedNavigationView.swift
//  Budfie
//
//  Created by appinventiv on 19/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class CurvedNavigationView: UIView {

    static var curveHeight: CGFloat = 40

    override func draw(_ rect: CGRect) {
        
        let height = rect.height
        let width = rect.width
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: height))
        aPath.addCurve(to: CGPoint(x: width, y: height),
                       controlPoint1: CGPoint(x: ((width / 8) * 2.5), y: (height - CurvedNavigationView.curveHeight)),
                       controlPoint2: CGPoint(x: ((width / 8) * 5.3), y: (height - CurvedNavigationView.curveHeight)))
        
        aPath.addLine(to: CGPoint(x: width, y: 0))
        aPath.addLine(to: CGPoint(x: 0, y: 0))
        aPath.addLine(to: CGPoint(x: 0, y: height))
        
        AppColors.themeBlueColor.setFill()
        aPath.fill()
    }
    
}

