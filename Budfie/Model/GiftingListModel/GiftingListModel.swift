//
//  GiftingListModel.swift
//  Budfie
//
//  Created by appinventiv on 09/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class GiftingListModel {
    
    let title : String
    let image  : String
    let url    : String

    init(initWithGiftList json: JSON) {
        
        title   = json["title"].stringValue
        image   = json["image"].stringValue
        url     = json["url"].stringValue
    }
    
}

/*
"CODE": 200,
"APICODERESULT": "SUCCESS",
"MESSAGE": "Gift List fetched successfully",
"VALUE": {
    "gifts": [
    {
    "title": "TestTest",
    "image": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a963e79258e91519795833.png",
    "url": "https://stackoverflow.com/questions/22416719/dramatic-increase-in-server-response-time-is-this-related-to-the-size-of-databa"
    },
    {
    "title": "testTeetete",
    "image": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a9564d8f21581519740120.jpg",
    "url": "http://gitlab.appinvent.in/users/sign_in"
    },
    {
    "title": "testsetset",
    "image": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a95656ca7c8e1519740268.png",
    "url": "http://gitlab.appinvent.in/users/sign_in"
    }
    ]
}
}
*/
