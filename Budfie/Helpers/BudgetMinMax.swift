//
//  BudgetMinMax.swift
//  Budfie
//
//  Created by appinventiv on 31/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

enum BudgetMinMax : Int {
    
    /*
     let budgetList = ["10,000 to 20,000",
     "20,000 to 30,000",
     "30,000 to 40,000",
     "40,000 to 50,000",
     "50,000 to 1,00,000"]
     */
    
    case minMax1     = 0
    case minMax2     = 1
    case minMax3     = 2
    case minMax4     = 3
    case minMax5     = 4
    
    
    var min: String {
        
        switch self {
            
        case .minMax1    : return "10,000"
        case .minMax2    : return "20,000"
        case .minMax3    : return "30,000"
        case .minMax4    : return "40,000"
        case .minMax5    : return "50,000"
            
        }
    }
    
    var max: String {
        
        switch self {
            
        case .minMax1    : return "20,000"
        case .minMax2    : return "30,000"
        case .minMax3    : return "40,000"
        case .minMax4    : return "50,000"
        case .minMax5    : return "1,00,000"
            
        }
    }
    
}


