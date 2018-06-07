//
//  SubCategoryModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 12/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubCategoryModel {
    
    var name            : String
    var id              : String
    var childCategory   : [ChildCategoryModel]
    
    init(initForSubCategory json: JSON) {
        
        self.childCategory  = [ChildCategoryModel]()
        self.name           = json["name"].stringValue
        self.id             = json["id"].stringValue
        
        for tempJson in json["child_category"].arrayValue {
            self.childCategory.append(ChildCategoryModel(initForChildCategory: tempJson))
        }
    }
    
}


//MARK:- Response Type
//====================
/*
 
 "sub_category" =             (
 {
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
 id = 1;
 name = Cricket;
 },
 {
 "child_category" =                     (
 );
 id = 2;
 name = Football;
 },
 {
 "child_category" =                     (
 );
 id = 3;
 name = Badminton;
 },
 {
 "child_category" =                     (
 );
 id = 4;
 name = "Formula 1 Racing";
 },
 {
 "child_category" =                     (
 );
 id = 5;
 name = Tennis;
 }
 );
 
 
 
 */

