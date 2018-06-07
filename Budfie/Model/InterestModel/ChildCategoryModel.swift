//
//  ChildCategoryModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 12/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChildCategoryModel {
    
    var name    : String
    var id      : String
    
    init(initForChildCategory json: JSON) {
        
        self.name  = json["name"].stringValue
        self.id    = json["id"].stringValue
    }
    
}




//MARK:- Response Type
//====================
/*
 
 "child_category" =                     (
 {
 id = 1;
 name = IPL;
 },
 {
 id = 2;
 name = BigBash;
 },
 {
 id = 3;
 name = "All International Matches";
 }
 );
 
 */


