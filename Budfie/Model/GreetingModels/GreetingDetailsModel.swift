//
//  GreetingDetailsModel.swift
//  Budfie
//
//  Created by appinventiv on 09/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class GreetingDetailsModel {
    
    let receiver_id: String
    let first_name: String
    let lst_name: String
    let image: String
    let avtar: String
    
    init(initWithGreetingDetails json: JSON) {
        
        receiver_id = json["sender_id"].string ?? json["receiver_id"].stringValue
        first_name = json["first_name"].stringValue
        lst_name = json["lst_name"].stringValue
        image = json["image"].stringValue
        avtar = json["avtar"].stringValue
    }
    
}


/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Greeting List fetched successfully",
    "VALUE": [
    {
    "receiver_id": "2",
    "first_name": "Akash Jain",
    "image": "",
    "avtar": "0"
    },
    {
    "receiver_id": "5",
    "first_name": "Yogesh",
    "image": "",
    "avtar": "0"
    }
    ]
}
*/
/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Greeting List fetched successfully";
    VALUE =     (
        {
            avtar = 0;
            "first_name" = Yogesh;
            image = "";
            "sender_id" = 5;
        }
    );
}
*/
