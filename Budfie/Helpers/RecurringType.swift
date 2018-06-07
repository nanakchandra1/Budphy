//
//  RecurringType.swift
//  Budfie
//
//  Created by appinventiv on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation


//(1=Daily,2=Weekly,3=Monthly,4=Yearly)

func getRecurringType(byIndex: String) -> String {
    
    switch byIndex {
    case "1":
        return "Daily"
    case "2":
        return "Weekly"
    case "3":
        return "Monthly"
    case "4":
        return "Yearly"
    default:
        return ""
    }
    
}

func getRecurringType(byName: String) -> String {
    
    switch byName {
    case "Daily":
        return "1"
    case "Weekly":
        return "2"
    case "Monthly":
        return "3"
    case "Yearly":
        return "4"
    default:
        return ""
    }
    
}

