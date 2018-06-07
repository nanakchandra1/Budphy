//
//  eHolidayPlannerModel.swift
//  Budfie
//
//  Created by appinventiv on 31/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

class HolidayPlannerModel {
    
    var fromDate    : String
    var toDate      : String
    var origin      : String
    var destination : String
    var adult       : String
    var kids        : String
    var stay        : String
    var rating      : String
    var isHomeStayHidden : Bool
    var isOrigin    : Bool
    
    init() {
        
        self.fromDate = ""
        self.toDate = ""
        self.origin = ""
        self.destination = ""
        self.kids = ""
        self.adult = ""
        self.rating = ""
        self.stay = ""
        self.isHomeStayHidden = false
        self.isOrigin = true
    }
}
