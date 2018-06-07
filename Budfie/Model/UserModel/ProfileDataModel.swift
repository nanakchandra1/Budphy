//
//  ProfileDataModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 18/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileDataModel {
    
    var first_name          : String
    var last_name           : String
    var dob                 : String
    var image               : String
    var country_code        : String
    var phone_no            : String
    var gender              : String
    var avtar               : String
    var location            : String
    var lat                 : String
    var long                : String
    var subCategory         : [SubCategoryModel]
    
    init(initForProfileData json: JSON) {
        
        self.subCategory        = [SubCategoryModel]()
        self.first_name         = json["userDetails"]["first_name"].string ?? json["friendDetails"]["first_name"].stringValue
        self.last_name          = json["userDetails"]["last_name"].string ?? json["friendDetails"]["last_name"].stringValue
        self.dob                = json["userDetails"]["dob"].string ?? json["friendDetails"]["dob"].stringValue
        self.image              = json["userDetails"]["image"].string ?? json["friendDetails"]["image"].stringValue
        self.country_code       = json["userDetails"]["country_code"].string ?? json["friendDetails"]["country_code"].stringValue
        self.phone_no           = json["userDetails"]["phone_no"].string ?? json["friendDetails"]["phone_no"].stringValue
        self.gender             = json["userDetails"]["gender"].string ?? json["friendDetails"]["gender"].stringValue
        self.avtar              = json["userDetails"]["avtar"].string ?? json["friendDetails"]["avtar"].stringValue
        self.location           = json["userDetails"]["location"].string ?? json["friendDetails"]["location"].stringValue
        self.lat                = json["userDetails"]["latitude"].string ?? json["friendDetails"]["latitude"].stringValue
        self.long               = json["userDetails"]["longitude"].string ?? json["friendDetails"]["longitude"].stringValue
        
        for tempJson in json["sub_category"].arrayValue {
            self.subCategory.append(SubCategoryModel(initForSubCategory: tempJson))
        }
    }
    
}

// Friend's Profile
/*
friendDetails =         {
    avtar = 0;
    "country_code" = "+91";
    dob = "09 Feb 2018";
    "first_name" = "Akash Jain";
    gender = 0;
    image = "";
    "last_name" = "";
    "phone_no" = 8130374427;
};
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "User's details has been fetched successfully",
    "VALUE": {
        "friendDetails": {
            "first_name": "Aakash Srivastav",
            "last_name": "",
            "dob": "14 Aug 1993",
            "gender": "0",
            "image": "https://s3.amazonaws.com/appinventiv-development/iOS/1516729887.png",
            "country_code": "+91",
            "phone_no": "9716600581"
        },
        "sub_category": [
        {
        "id": "2",
        "name": "Football",
        "child_category": []
        },
        {
        "id": "1",
        "name": "Cricket",
        "child_category": []
        },
        {
        "id": "3",
        "name": "Badminton",
        "child_category": []
        },
        {
        "id": "6",
        "name": "Bollywood",
        "child_category": []
        },
        {
        "id": "8",
        "name": "Tollywood",
        "child_category": []
        },
        {
        "id": "11",
        "name": "Concerts",
        "child_category": []
        }
        ]
    }
}
*/

// Owner's Profile
/*
 
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "User'd details fetched successfully",
    "VALUE": {
        "userDetails": {
            "first_name": "Aishwarya",
            "last_name": "Aishwarya",
            "dob": "20 Dec 2017",
            "avtar": "0",
            "gender": "0",
            "image": "",
            "country_code": "+91",
            "phone_no": "9012153878"
        },
        "sub_category": [
        {
        "id": "8",
        "name": "Tollywood",
        "child_category": []
        },
        {
        "id": "16",
        "name": "Luxury",
        "child_category": []
        }
        ]
    }
}

{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "User'd details fetched successfully",
    "VALUE": {
        "first_name": "",
        "last_name": "",
        "dob": "",
        "image": "",
        "country_code": "+91",
        "phone_no": "9876699876"
    }
}
 
 */

