//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Appinventiv on 13/11/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK:- Properties
    let duration = 0.25
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->Void)?
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let herbView = presenting ? toView :
            transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ?
            
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)
        
        herbView.alpha = presenting ? 0.1 : 1
        UIView.animate(withDuration: duration, animations: {
            herbView.transform = self.presenting ?
                CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            herbView.alpha = self.presenting ? 1 : 0.1
            if !self.presenting {
                self.dismissCompletion?()
            }
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}
