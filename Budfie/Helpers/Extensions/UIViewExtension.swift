//
//  UIViewExtention.swift
//  iHearU
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 . All rights reserved.
//
// BY - Yogesh Singh Negi - 4 DEC 2017

import Foundation
import UIKit

//MARK:- UIView Extension for drawing Bezier Curve in Navigation
//==============================================================
extension UIView {
    
    func curvView(){
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: 100))
        aPath.addCurve(to: CGPoint(x: UIScreen.main.bounds.width, y: 100), // ending point
            controlPoint1: CGPoint(x: (UIScreen.main.bounds.width / 8) * 2.5, y: 60),
            controlPoint2: CGPoint(x: (UIScreen.main.bounds.width / 8) * 5.3, y: 60))
        aPath.close()
        
        let square = CAShapeLayer()
        square.fillColor = UIColor.white.cgColor
        square.path = aPath.cgPath
        self.layer.addSublayer(square)
    }
    
    func curvHeaderView(height: CGFloat) {
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: height))
        aPath.addCurve(to: CGPoint(x: UIScreen.main.bounds.width, y: height), // ending point
            controlPoint1: CGPoint(x: (UIScreen.main.bounds.width / 8) * 2.5, y: height - 50),
            controlPoint2: CGPoint(x: (UIScreen.main.bounds.width / 8) * 5.3, y: height - 50))
        aPath.close()
        
        let square = CAShapeLayer()
        square.fillColor = UIColor.white.cgColor
        square.path = aPath.cgPath
        self.layer.insertSublayer(square, at: 0)
        
        //        let arcCenter = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.82)
        //        let circleRadius = UIScreen.main.bounds.width * 1.3
        //        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
        //
        //        let   semiCirleLayer = CAShapeLayer()
        //        semiCirleLayer.path = circlePath.cgPath
        //        semiCirleLayer.fillColor = UIColor.white.cgColor
        //        self.headerView.layer.addSublayer(semiCirleLayer)
        
        // Make the view color transparent
    }
    
    func curveNaviView(){

        let aPath = UIBezierPath()

        aPath.move(to: CGPoint(x: 0, y: 40))
        aPath.addCurve(to: CGPoint(x: UIScreen.main.bounds.width, y: 40), // ending point
            controlPoint1: CGPoint(x: (UIScreen.main.bounds.width / 8) * 2.5, y: 0),
            controlPoint2: CGPoint(x: (UIScreen.main.bounds.width / 8) * 5.3, y: 0))

        aPath.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y:0))
        aPath.addLine(to: CGPoint(x: 0, y: 0))
        aPath.addLine(to: CGPoint(x: 0, y: self.frame.maxY))

        aPath.close()
        let square = CAShapeLayer()
        square.fillColor = AppColors.themeBlueColor.cgColor
        square.path = aPath.cgPath

        self.layer.insertSublayer(square, at: 0)
        //self.layer.addSublayer(square1)

    }
    
//    func curveNaviView() {
//
//        let height = self.height
//        let width = self.width
//        backgroundColor = .white
//
//        let aPath = UIBezierPath()
//        aPath.move(to: CGPoint(x: 0, y: height))
//
//        aPath.addCurve(to: CGPoint(x: width, y: height), // ending point
//            controlPoint1: CGPoint(x: (width / 8) * 2.5, y: height - 50),
//            controlPoint2: CGPoint(x: (width / 8) * 5.3, y: height - 50))
//
//        aPath.close()
//        UIColor.white.setFill()
//    }

}

extension UIView {
    
    func roundCornersFromOneSide(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func layerGradient(left: UIColor = UIColor.red,right: UIColor = .yellow, start: CGPoint = CGPoint(x: 0, y: 0), end: CGPoint = CGPoint(x: 0, y: 1)) {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = start
        layer.endPoint = end
        
        layer.colors = [left.cgColor,UIColor.clear.cgColor,right.cgColor]
        
        self.layer.insertSublayer(layer, at: 0)
    }
    
}


class View: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.topLeft, .bottomLeft], radius: 10)
    }
}


extension UIView {
    
    //MARK:
    //MARK: GET WIDTH OF OBJECT
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    func roundCornerWith(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    //MARK:
    //MARK: SET CORNER ROUND
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    public func round() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = height/2
    }
    
    //MARK:
    //MARK: SET BORDER
    public func border(width: CGFloat, borderColor: UIColor ) {
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
    
    //MARK:
    //MARK: ADD SHADOW
    func dropShadow(width: CGFloat = 4.0, shadow: UIColor = UIColor(r: 211, g: 215, b: 221, alpha: 0.6)) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadow.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = width
    }
    
    func dropBottomShadow(shadow: UIColor = UIColor(r: 211, g: 215, b: 221, alpha: 0.6)) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadow.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 4.0
    }

    func addQualityShadow(ofColor color: UIColor = UIColor(red:0.07, green:0.47, blue:0.57, alpha:1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5, shadowPath: UIBezierPath? = nil) {

        addShadow(ofColor: color, radius: radius, offset: offset, opacity: opacity)
        layer.masksToBounds = false

        if let path = shadowPath {
            layer.shadowPath = path.cgPath
        } else {
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
            layer.shadowPath = path.cgPath
        }
    }

    public func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    var getTableViewCell : UITableViewCell? {
        
        var subviewClass = self
        
        while !(subviewClass is UITableViewCell) {
            
            guard let view = subviewClass.superview else { return nil }
            
            subviewClass = view
        }
        
        return subviewClass as? UITableViewCell
        
    }
    
    func tableViewIndexPath(tableView: UITableView) -> IndexPath? {
        
        if let cell = self.getTableViewCell {
            
            return tableView.indexPath(for: cell)
            
        }
        else {
            
            return nil
            
        }
        
    }
    
    var getCollectionViewCell : UICollectionViewCell? {
        
        var subviewClass = self
        
        while !(subviewClass is UICollectionViewCell){
            
            guard let view = subviewClass.superview else { return nil }
            
            subviewClass = view
        }
        
        return subviewClass as? UICollectionViewCell
        
    }
    
    func collectionViewIndexPath(_ collectionView: UICollectionView) -> IndexPath? {
        
        if let cell = self.getCollectionViewCell {
            
            return collectionView.indexPath(for: cell)
            
        }
        else {
            
            return nil
            
        }
        
    }
    
    func cellShadow() {
        self.layer.shadowOpacity    = 1
        self.layer.shadowColor      = UIColor.black.cgColor//AppColors.blackShadowColor.cgColor
        self.layer.shadowRadius     = 20
        self.layer.shadowOffset     = CGSize.zero
        self.layer.masksToBounds    = false
    }
    
    //    func addShadow(width: CGFloat) {
    //        self.layer.shadowOpacity = 4.0
    //        self.layer.shadowColor = UIColor(r: 27, g: 27, b: 27, alpha: 0.4).cgColor
    //        self.layer.shadowRadius = width
    //        self.layer.shadowOffset = CGSize.zero
    //        self.layer.masksToBounds = false
    //    }
    
}



// Mark: UIView extension to create traingle
extension UIView {
    
    enum Border {
        case left
        case right
        case top
        case bottom
    }

    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var right: CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var centerX: CGFloat{
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue,y: self.centerY) }
    }
    var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX,y: newValue) }
    }
    var origin: CGPoint {
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    var size: CGSize {
        set { self.frame.size = newValue }
        get { return self.frame.size }
    }
    
    ///Returns the parent view controller ( if any ) of the view
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    ///Adds the slope in view
    var addSlope:Void{
        
        // Make path to draw traingle
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        // Add path to the mask
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        
        self.layer.mask = mask
        
        // Adding shape to view's layer
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = path.cgPath
        shape.fillColor = UIColor.gray.cgColor
        
        self.layer.insertSublayer(shape, at: 1)
    }
    
//    ///Sets the corner radius of the view
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
    
//    ///Sets the border width of the view
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
    
//    ///Sets the border color of the view
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            let color = UIColor(cgColor: layer.borderColor!)
//            return color
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
    
    ///Sets the shadow color of the view
    @IBInspectable var shadowColor:UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    ///Sets the shadow opacity of the view
    @IBInspectable var shadowOpacity:Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    ///Sets the shadow offset of the view
    @IBInspectable var shadowOffset:CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    ///Sets the shadow radius of the view
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = shadowRadius
        }
    }
    
    ///Adds constraints from a view to other view
    func adjustConstraints(to view: UIView, attributes: (top: CGFloat, trailing: CGFloat, leading: CGFloat, bottom: CGFloat) = (0, 0, 0, 0)) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(
                item: self, attribute: .top, relatedBy: .equal,
                toItem: view, attribute: .top, multiplier: 1.0,
                constant: attributes.top
            ),
            NSLayoutConstraint(
                item: self, attribute: .trailing, relatedBy: .equal,
                toItem: view, attribute: .trailing, multiplier: 1.0,
                constant: attributes.trailing
            ),
            NSLayoutConstraint(
                item: self, attribute: .leading, relatedBy: .equal,
                toItem: view, attribute: .leading, multiplier: 1.0,
                constant: attributes.leading
            ),
            NSLayoutConstraint(
                item: self, attribute: .bottom, relatedBy: .equal,
                toItem: view, attribute: .bottom, multiplier: 1.0,
                constant: attributes.bottom
            )
        ]
    }
    
    ///Sets the circle shadow in the view
    func setCircleShadow(shadowRadius: CGFloat = 2,
                         shadowOpacity: Float = 0.3,
                         shadowColor: CGColor = UIColor.gray.cgColor,
                         shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
    
    ///Rounds the given corner based on the given radius
    func roundCorner(_ corner: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corner,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    ///Rounds all the corners of the view
    func roundCorners() {
        roundCorner(.allCorners, radius: self.bounds.width/2.0)
    }
    
    
    func setBorder(border: UIView.Border, weight: CGFloat, color: UIColor ) {
        
        let lineView = UIView()
        addSubview(lineView)
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        switch border {
            
        case .left:
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
            
        case .right:
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
            
        case .top:
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
            
        case .bottom:
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
        }
    }
    
}


/**
 A UIView extension that makes adding basic animations, like fades and bounces, simple.
 */
public extension UIView {
    
    /**
     Edge of the view's parent that the animation should involve
     - none: involves no edge
     - top: involves the top edge of the parent
     - bottom: involves the bottom edge of the parent
     - left: involves the left edge of the parent
     - right: involves the right edge of the parent
     */
    public enum SimpleAnimationEdge {
        case none
        case top
        case bottom
        case left
        case right
    }
    
    /**
     Fades this view in. This method can be chained with other animations to combine a fade with
     the other animation, for instance:
     ```
     view.fadeIn().slideIn(from: .left)
     ```
     - Parameters:
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func fadeIn(duration: TimeInterval = 0.25,
                                   delay: TimeInterval = 0,
                                   completion: ((Bool) -> Void)? = nil) -> UIView {
        isHidden = false
        alpha = 0
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Fades this view out. This method can be chained with other animations to combine a fade with
     the other animation, for instance:
     ```
     view.fadeOut().slideOut(to: .right)
     ```
     - Parameters:
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func fadeOut(duration: TimeInterval = 0.25,
                                    delay: TimeInterval = 0,
                                    completion: ((Bool) -> Void)? = nil) -> UIView {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseOut,
            animations: {
                self.alpha = 0
        }, completion: completion)
        return self
    }
    
    /**
     Fades the background color of a view from existing bg color to a specified color without using alpha values.
     
     - Parameters:
     - toColor: the final color you want to fade to
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func fadeColor(toColor: UIColor = UIColor.red,
                                      duration: TimeInterval = 0.25,
                                      delay: TimeInterval = 0,
                                      completion: ((Bool) -> Void)? = nil) -> UIView {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseIn,
            animations: {
                self.backgroundColor = toColor
        }, completion: completion)
        return self
    }
    
    /**
     Slides this view into position, from an edge of the parent (if "from" is set) or a fixed offset
     away from its position (if "x" and "y" are set).
     - Parameters:
     - from: edge of the parent view that should be used as the starting point of the animation
     - x: horizontal offset that should be used for the starting point of the animation
     - y: vertical offset that should be used for the starting point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func slideIn(from edge: SimpleAnimationEdge = .none,
                                    x: CGFloat = 0,
                                    y: CGFloat = 0,
                                    duration: TimeInterval = 0.4,
                                    delay: TimeInterval = 0,
                                    completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        isHidden = false
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 2,
            options: .curveEaseOut,
            animations: {
                self.transform = .identity
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Slides this view out of its position, toward an edge of the parent (if "to" is set) or a fixed
     offset away from its position (if "x" and "y" are set).
     - Parameters:
     - to: edge of the parent view that should be used as the ending point of the animation
     - x: horizontal offset that should be used for the ending point of the animation
     - y: vertical offset that should be used for the ending point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func slideOut(to edge: SimpleAnimationEdge = .none,
                                     x: CGFloat = 0,
                                     y: CGFloat = 0,
                                     duration: TimeInterval = 0.25,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        let endTransform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
                self.transform = endTransform
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view into position, with a bounce at the end, either from an edge of the parent (if
     "from" is set) or a fixed offset away from its position (if "x" and "y" are set).
     - Parameters:
     - from: edge of the parent view that should be used as the starting point of the animation
     - x: horizontal offset that should be used for the starting point of the animation
     - y: vertical offset that should be used for the starting point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func bounceIn(from edge: SimpleAnimationEdge = .none,
                                     x: CGFloat = 0,
                                     y: CGFloat = 0,
                                     duration: TimeInterval = 0.5,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        isHidden = false
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 0.58, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view out of its position, starting with a bounce. The view moves toward an edge of
     the parent (if "to" is set) or a fixed offset away from its position (if "x" and "y" are set).
     - Parameters:
     - to: edge of the parent view that should be used as the ending point of the animation
     - x: horizontal offset that should be used for the ending point of the animation
     - y: vertical offset that should be used for the ending point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func bounceOut(to edge: SimpleAnimationEdge = .none,
                                      x: CGFloat = 0,
                                      y: CGFloat = 0,
                                      duration: TimeInterval = 0.35,
                                      delay: TimeInterval = 0,
                                      completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        let delta = CGPoint(x: offset.x + x, y: offset.y + y)
        let endTransform = CGAffineTransform(translationX: delta.x, y: delta.y)
        let prepareTransform = CGAffineTransform(translationX: -delta.x * 0.2, y: -delta.y * 0.2)
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                    self.transform = endTransform
                }
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view into position, as though it were popping out of the screen.
     - Parameters:
     - fromScale: starting scale for the view, should be between 0 and 1
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func popIn(fromScale: CGFloat = 0.5,
                                  duration: TimeInterval = 0.5,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
        isHidden = false
        alpha = 0
        transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view out of position, as though it were withdrawing into the screen.
     - Parameters:
     - toScale: ending scale for the view, should be between 0 and 1
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func popOut(toScale: CGFloat = 0.5,
                                   duration: TimeInterval = 0.3,
                                   delay: TimeInterval = 0,
                                   completion: ((Bool) -> Void)? = nil) -> UIView {
        let endTransform = CGAffineTransform(scaleX: toScale, y: toScale)
        let prepareTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.transform = endTransform
                    self.alpha = 0
                }
        }, completion: completion)
        return self
    }
    
    /**
     Causes the view to hop, either toward a particular edge or out of the screen (if "toward" is
     .None).
     - Parameters:
     - toward: the edge to hop toward, or .None to hop out
     - amount: distance to hop, expressed as a fraction of the view's size
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func hop(toward edge: SimpleAnimationEdge = .none,
                                amount: CGFloat = 0.4,
                                duration: TimeInterval = 0.6,
                                delay: TimeInterval = 0,
                                completion: ((Bool) -> Void)? = nil) -> UIView {
        var dx: CGFloat = 0, dy: CGFloat = 0, ds: CGFloat = 0
        if edge == .none {
            ds = amount / 2
        } else if edge == .left || edge == .right {
            dx = (edge == .left ? -1 : 1) * self.bounds.size.width * amount;
            dy = 0
        } else {
            dx = 0
            dy = (edge == .top ? -1 : 1) * self.bounds.size.height * amount;
        }
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.28) {
                    let t = CGAffineTransform(translationX: dx, y: dy)
                    self.transform = t.scaledBy(x: 1 + ds, y: 1 + ds)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.28, relativeDuration: 0.28) {
                    self.transform = .identity
                }
                UIView.addKeyframe(withRelativeStartTime: 0.56, relativeDuration: 0.28) {
                    let t = CGAffineTransform(translationX: dx * 0.5, y: dy * 0.5)
                    self.transform = t.scaledBy(x: 1 + ds * 0.5, y: 1 + ds * 0.5)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.84, relativeDuration: 0.16) {
                    self.transform = .identity
                }
        }, completion: completion)
        return self
    }
    
    /**
     Causes the view to shake, either toward a particular edge or in all directions (if "toward" is
     .None).
     - Parameters:
     - toward: the edge to shake toward, or .None to shake in all directions
     - amount: distance to shake, expressed as a fraction of the view's size
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func shake(toward edge: SimpleAnimationEdge = .none,
                                  amount: CGFloat = 0.15,
                                  duration: TimeInterval = 0.6,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
        let steps = 8
        let timeStep = 1.0 / Double(steps)
        var dx: CGFloat, dy: CGFloat
        if edge == .left || edge == .right {
            dx = (edge == .left ? -1 : 1) * self.bounds.size.width * amount;
            dy = 0
        } else {
            dx = 0
            dy = (edge == .top ? -1 : 1) * self.bounds.size.height * amount;
        }
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                var start = 0.0
                for i in 0..<(steps - 1) {
                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                        self.transform = CGAffineTransform(translationX: dx, y: dy)
                    }
                    if (edge == .none && i % 2 == 0) {
                        swap(&dx, &dy)  // Change direction
                        dy *= -1
                    }
                    dx *= -0.85
                    dy *= -0.85
                    start += timeStep
                }
                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                    self.transform = .identity
                }
        }, completion: completion)
        return self
    }
    
    private func offsetFor(edge: SimpleAnimationEdge) -> CGPoint {
        if let parentSize = self.superview?.frame.size {
            switch edge {
            case .none: return CGPoint.zero
            case .top: return CGPoint(x: 0, y: -frame.maxY)
            case .bottom: return CGPoint(x: 0, y: parentSize.height - frame.minY)
            case .left: return CGPoint(x: -frame.maxX, y: 0)
            case .right: return CGPoint(x: parentSize.width - frame.minX, y: 0)
            }
        }
        return .zero
    }
}


extension UIView {
    
    var tableViewCell : UITableViewCell? {
        
        var subviewClass = self
        
        while !(subviewClass is UITableViewCell){
            
            guard let view = subviewClass.superview else { return nil }
            
            subviewClass = view
        }
        return subviewClass as? UITableViewCell
    }
    
    func tableViewIndexPath(_ tableView: UITableView) -> IndexPath? {
        
        if let cell = self.tableViewCell {
            
            return tableView.indexPath(for: cell)
            
        }
        return nil
    }
    
    var collectionViewCell : UICollectionViewCell? {
        
        var subviewClass = self
        
        while !(subviewClass is UICollectionViewCell){
            
            guard let view = subviewClass.superview else { return nil }
            
            subviewClass = view
        }
        
        return subviewClass as? UICollectionViewCell
    }

    @available(iOS 10.0, *)
    func asImage(frame: CGRect? = nil) -> UIImage {
        let toSnapFrame = (frame ?? bounds)
        let renderer = UIGraphicsImageRenderer(bounds: toSnapFrame)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    @available(iOS 9.0, *)
    func asImageIniOS9(frame: CGRect? = nil) -> UIImage {
        let toSnapFrame = (frame ?? bounds)
        UIGraphicsBeginImageContextWithOptions(toSnapFrame.size, isOpaque, 0.0)
        drawHierarchy(in: toSnapFrame, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
   
}

