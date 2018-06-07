//
//  InterestListModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 12/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class InterestListModel {
    
    var category    : String
    var id          : String
    var subCategory : [SubCategoryModel]
    
    init(initForInterestList json: JSON) {
        
        self.subCategory    = [SubCategoryModel]()
        self.category       = json["category"].stringValue
        self.id             = json["id"].stringValue
        
        for tempJson in json["sub_category"].arrayValue {
            self.subCategory.append(SubCategoryModel(initForSubCategory: tempJson))
        }
    }
    
}


//MARK:- Response Type
//====================
/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Interest list fetched successfully";
    VALUE =     (
        {
            category = Sports;
            id = 1;
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
    },
        {
            category = Movies;
            id = 2;
            "sub_category" =             (
                {
                    "child_category" =                     (
                    );
                    id = 6;
                    name = Bollywood;
            },
                {
                    "child_category" =                     (
                    );
                    id = 7;
                    name = Hollywood;
            },
                {
                    "child_category" =                     (
                    );
                    id = 8;
                    name = Tollywood;
            }
            );
*/

