//
//  OuterShadowView.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class OuterShadowView: UIView {

    lazy var innerView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()

        contentMode = .redraw
        addSubview(innerView)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let cornerRadius: CGFloat = 5

        innerView.frame = rect
        innerView.backgroundColor = .clear
        innerView.layer.cornerRadius = cornerRadius
        innerView.clipsToBounds = true

        let overallPath = UIBezierPath(rect: rect.insetBy(dx: -15, dy: -15))
        let croppingPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        overallPath.append(croppingPath)
        overallPath.usesEvenOddFillRule = true

        let cropLayer = CAShapeLayer()
        cropLayer.path = overallPath.cgPath
        cropLayer.fillRule = kCAFillRuleEvenOdd
        cropLayer.fillColor = UIColor.purple.cgColor
        cropLayer.opacity = 0.5
        layer.mask = cropLayer

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = cornerRadius
        layer.shadowPath = croppingPath.cgPath
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        layer.cornerRadius = cornerRadius
    }
}
