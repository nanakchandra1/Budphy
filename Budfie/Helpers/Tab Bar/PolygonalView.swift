//
//  PolygonalView.swift
//  PolygonalViewDemo
//
//  Created by yogesh singh negi on 18/12/14.
//  Copyright (c) yogesh singh negi. All rights reserved.
//

import UIKit
/*
@IBDesignable class PolygonalView: UIView {
    
    @IBInspectable var sideNumber: Int = 4 {
        didSet {
            drawShape()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            drawShape()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 3 {
        didSet {
            drawShape()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.green {
        didSet {
            drawShape()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layoutIfNeeded()
        drawShape()
        
    }
    
    func drawShape() {
        
        let shapePath = UIBezierPath()
        let theta = CGFloat(2.0 * Double.pi / Double(sideNumber)) // The 'turn' at each corner
        let offset = CGFloat(Float(cornerRadius) * tanf(Float(theta) / 2.0)) // The point from witch to draw the rounded corners
        let squareWidth = min(frame.height, frame.width) // The width of the square
        
        // We calculate the length of a side of the polygon
        var length = squareWidth - CGFloat(borderWidth)
        //We make an axecption for the triangle so it's not too large
        if sideNumber < 4 {
            length /= 1.5
        }

        let sideLength = length * CGFloat(tanf(Float(theta) / 2.0))
        var point = CGPoint(x: squareWidth / 2.0 + sideLength / 2.0 - offset, y: squareWidth - (squareWidth - length) / 2.0)
        var angle = CGFloat(Double.pi)
        shapePath.move(to: point)
        
        // We draw the other sides and the rounded corners
        for _ in 0..<sideNumber{
            point = CGPoint(x: CGFloat(point.x) + (sideLength - offset * 2.0) * CGFloat(cosf(Float(angle))), y: CGFloat(point.y) + (sideLength - offset * 2.0) * CGFloat(sinf(Float(angle))))
            shapePath.addLine(to: point)
            let center = CGPoint(x: CGFloat(point.x) + CGFloat(cornerRadius) * CGFloat(cosf(Float(angle) + Float(Double.pi/2))), y: CGFloat(point.y) + CGFloat(cornerRadius) * CGFloat(sinf(Float(angle) + Float(Double.pi/2))))
            shapePath.addArc(withCenter: center, radius: CGFloat(cornerRadius), startAngle: angle - CGFloat(Double.pi/2), endAngle: angle + theta - CGFloat(Double.pi/2), clockwise: true)
            point = shapePath.currentPoint
            angle += theta
        }
        shapePath.close()
        
        // We apply the mask to the view
        let mask = CAShapeLayer()
        mask.path = shapePath.cgPath
        mask.lineWidth = borderWidth
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor
        layer.mask = mask
        
        // We draw the border according to the mask path
        let border = CAShapeLayer()
        border.path = shapePath.cgPath
        border.lineWidth = borderWidth;
        border.strokeColor = borderColor.cgColor;
        border.fillColor = UIColor.clear.cgColor;
        layer.addSublayer(border)
    }
}
*/

@IBDesignable
public class PolygonalView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        // Initialization code
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override public func prepareForInterfaceBuilder() {
        setup()
    }
    
    @IBInspectable public var sides: Int = 9 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5 {
        didSet {
            updateUI()
        }
    }
    public override func draw(_ rect: CGRect) {
       super.draw(rect)
        layoutIfNeeded()
        setup()
    }
    
    private func setup(){
        layoutIfNeeded()

        let path: UIBezierPath

        if sides == 0 {
            // Make circle
            path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width/2)
        } else {
            path = UIBezierPath(polygonIn: self.bounds, sides: sides, lineWidth: borderWidth, cornerRadius: cornerRadius)
        }

       // let path = UIBezierPath.roundedPolygonPathWithRect(self.bounds, lineWidth: borderWidth, sides: sides, cornerRadius: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.lineWidth       = borderWidth;
        maskLayer.strokeColor     = UIColor.clear.cgColor
        maskLayer.fillColor       = UIColor.white.cgColor
        self.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth       = borderWidth
        borderLayer.strokeColor     = borderColor.cgColor
        borderLayer.fillColor       = UIColor.clear.cgColor
        self.layer.addSublayer(borderLayer)
    }
    
    private func updateUI(){
        layoutIfNeeded()
        guard let layers = self.layer.sublayers else {
            return
        }
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        setup()
    }
    
}

extension UIBezierPath {
    
    /// Create UIBezierPath for regular polygon with rounded corners
    ///
    /// - parameter rect:            The CGRect of the square in which the path should be created.
    /// - parameter sides:           How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
    /// - parameter lineWidth:       The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square. Default value 1.
    /// - parameter cornerRadius:    The radius to be applied when rounding the corners. Default value 0.
    
    convenience init(polygonIn rect: CGRect, sides: Int, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        self.init()
        
        let theta = 2 * CGFloat.pi / CGFloat(sides)                        // how much to turn at every corner
        let offset = cornerRadius * tan(theta / 2)                  // offset from which to start rounding corners
        let squareWidth = min(rect.size.width, rect.size.height)    // width of the square
        
        // calculate the length of the sides of the polygon
        
        var length = squareWidth - lineWidth
        if sides % 4 != 0 {                                         // if not dealing with polygon which will be square with all sides ...
            length = length * cos(theta / 2) + offset / 2           // ... offset it inside a circle inside the square
        }
        let sideLength = length * tan(theta / 2)
        
        // start drawing at `point` in lower right corner, but center it
        
        var point = CGPoint(x: rect.origin.x + rect.size.width / 2 + sideLength / 2 - offset, y: rect.origin.y + rect.size.height / 2 + length / 2)
        var angle = CGFloat.pi
        move(to: point)
        
        // draw the sides and rounded corners of the polygon
        
        for _ in 0 ..< sides {
            point = CGPoint(x: point.x + (sideLength - offset * 2) * cos(angle), y: point.y + (sideLength - offset * 2) * sin(angle))
            addLine(to: point)
            
            let center = CGPoint(x: point.x + cornerRadius * cos(angle + .pi / 2), y: point.y + cornerRadius * sin(angle + .pi / 2))
            addArc(withCenter: center, radius: cornerRadius, startAngle: angle - .pi / 2, endAngle: angle + theta - .pi / 2, clockwise: true)
            
            point = currentPoint
            angle += theta
        }
        
        close()
        
        self.lineWidth = lineWidth           // in case we're going to use CoreGraphics to stroke path, rather than CAShapeLayer
        lineJoinStyle = .round
    }
    
}

