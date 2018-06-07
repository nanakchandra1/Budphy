//
//  NewsColors.swift
//  Budfie
//
//  Created by appinventiv on 30/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

enum NewsColors : Int {
    
    case color1 = 1
    case color2 = 2
    case color3 = 3
    case color4 = 4
    case color5 = 5
    case color6 = 6
    case color7 = 7
    case color8 = 8
    case color9 = 9
    case color10 = 10
    
    var lightColor: UIColor {
        
        switch self {
            
        case .color1: return AppColors.lightColor1
        case .color2: return AppColors.lightColor2
        case .color3: return AppColors.lightColor3
        case .color4: return AppColors.lightColor4
        case .color5: return AppColors.lightColor5
        case .color6: return AppColors.lightColor6
        case .color7: return AppColors.lightColor1
        case .color8: return AppColors.lightColor2
        case .color9: return AppColors.lightColor3
        case .color10: return AppColors.lightColor4
            
        }
    }
    
    
    var darkColor: UIColor {
        
        switch self {
            
        case .color1: return AppColors.darkColor1
        case .color2: return AppColors.darkColor2
        case .color3: return AppColors.darkColor3
        case .color4: return AppColors.darkColor4
        case .color5: return AppColors.darkColor5
        case .color6: return AppColors.darkColor6
        case .color7: return AppColors.darkColor1
        case .color8: return AppColors.darkColor2
        case .color9: return AppColors.darkColor3
        case .color10: return AppColors.darkColor4
            
        }
    }
    
}

