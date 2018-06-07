//
//  AppDevice.swift
//  CoffeeTDS
//
//  Created by appinventiv on 27/03/17.
//  Copyright © 2017 appinventiv. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    static var deviceID : String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "DummyDeviceID"
    }
    
    static var device_Token : String {
        return "12345678"
    }
    
    static let IsIPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let IsIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    
    //MARK: Print_Debug && simulator
   static var isIPhoneSimulator:Bool{
        
        var isSimulator = false
        #if arch(i386) || arch(x86_64)
            //simulator
            isSimulator = true
        #endif
        return isSimulator
    }
}
