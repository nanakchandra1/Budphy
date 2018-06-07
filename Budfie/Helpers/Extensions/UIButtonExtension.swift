//
//  UIButtonExtension.swift
//  Budfie
//
//  Created by  on 04/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//
// BY - Yogesh Singh Negi - 4 DEC 2017

import Foundation
import UIKit

extension UIButton {
    
//    @IBDesignable
//    class RightAlignedIconButton: UIButton {
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            semanticContentAttribute = .forceRightToLeft
//            contentHorizontalAlignment = .right
//            let availableSpace = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
//            let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
//            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
//        }
//    }
    
    func roundCommonButton(title: String) {
        
        self.setTitle(title, for: .normal)
        self.layer.borderWidth = 1
        self.backgroundColor = AppColors.whiteColor
        self.layer.borderColor = AppColors.themeBlueColor.cgColor
        self.layer.cornerRadius = 19.8
        self.setTitleColor(AppColors.themeBlueColor, for: .normal)
        self.clipsToBounds = true
    }
    
    func roundCommonButtonPositive(title: String) {
        
        self.setTitle(title, for: .normal)
        self.layer.borderWidth = 1
        self.backgroundColor = AppColors.themeBlueColor
        self.layer.borderColor = AppColors.whiteColor.cgColor
        self.layer.cornerRadius = 19.8
        self.setTitleColor(AppColors.whiteColor, for: .normal)
        self.clipsToBounds = true
    }
    
}
