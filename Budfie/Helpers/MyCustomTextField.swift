//
//  MyCustomTextField.swift
//  YoDwollaDemo
//
//  Created by appinventiv on 26/10/17.
//  Copyright © 2017 yogesh singh negi. All rights reserved.
//

import SkyFloatingLabelTextField

class MyCustomTextField: UITextField {
    
    @IBInspectable
    var isPasteAllowed: Bool = true

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print_debug("MyTextField canPerformAction")
        if !isPasteAllowed {
            UIMenuController.shared.isMenuVisible = false
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                print_debug("no paste")
                return false
            }
        }
        return super.canPerformAction(action, withSender:sender)
    }

}


class CustomForSkyFloating: SkyFloatingLabelTextField {
    
    
}
