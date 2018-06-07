//
//  AppFonts.swift
//  DannApp
//
//  Created by Aakash Srivastav on 20/04/17.
//  Copyright © 2017 . All rights reserved.
//
// BY - Yogesh Singh Negi - 4 DEC 2017


import Foundation
import UIKit


enum AppFonts : String {
    
    case AvenirNext_BoldItalic          = "AvenirNext-BoldItalic"
    case AvenirNext_DemiBold            = "AvenirNext-DemiBold"
    case AvenirNext_DemiBoldItalic      = "AvenirNext-DemiBoldItalic"
    case AvenirNext_Heavy               = "AvenirNext-Heavy"
    case AvenirNext_HeavyItalic         = "AvenirNext-HeavyItalic"
    case AvenirNext_Italic              = "AvenirNext-Italic"
    case AvenirNext_Medium              = "AvenirNext-Medium"
    case AvenirNext_MediumItalic        = "AvenirNext-MediumItalic"
    case AvenirNext_Regular             = "AvenirNext-Regular"
    case AvenirNext_UltraLightItalic    = "AvenirNext-UltraLightItalic"
    case Comfortaa_Bold_0               = "Comfortaa-Bold"
    case Comfortaa_Light_0              = "Comfortaa-Light"
    case Comfortaa_Regular_0            = "Comfortaa-Regular"
    case MyriadPro_Regular              = "MyriadPro-Regular"
    case Bellerose_Light                = "Bellerose"
    case Funny_Cute                     = "Funny&Cute"
    
}


extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
    func withSize(_ iphone5: CGFloat,iphone6: CGFloat,iphone6p: CGFloat) -> UIFont {
        
        var fontSize:CGFloat = 0
        if screenWidth < 321 {
            fontSize = iphone5
        } else if screenWidth < 375 {
            fontSize = iphone6
        } else {
            fontSize = iphone6p
        }
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
