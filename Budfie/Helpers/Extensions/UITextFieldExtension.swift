//
//  UITextFieldExtension.swift
//  WoshApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 . All rights reserved.
//


import Foundation
import UIKit

extension UITextField{
    
    ///Sets and gets if the textfield has secure text entry
    var isSecureText:Bool{
        get{
            return self.isSecureTextEntry
        }
        set{
            let font = self.font
            self.isSecureTextEntry = newValue
            if let text = self.text{
                self.text = ""
                self.text = text
            }
            self.font = nil
            self.font = font
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        }
    }
}
