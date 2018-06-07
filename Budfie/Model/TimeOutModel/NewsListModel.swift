//
//  NewsListModel.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsListModel {
    
    let title : String
    let description : String
    
    init(initWithNewsList json : JSON) {

        let unfilteredTitle = (json["title"].string ?? json["name"].stringValue)
        let unfilteredDesc = (json["description"].string ?? json["greeting"].stringValue)

        self.title = unfilteredTitle.removingHtmlTags
        self.description = unfilteredDesc.removingHtmlTags
    }
    
}

/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Greeting List fetched successfully";
    VALUE =     {
        cards =         (
            {
                greeting = "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5aab74d9ee8071521186009.gif";
                name = "Thank You";
        },
            {
                greeting = "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5aab74913dbc01521185937.gif";
                name = "Miss You";
        },
            {
                greeting = "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5aab7399586481521185689.gif";
                name = "Tope Secret";
        }
        );
    };
}
*/

/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "News List fetched successfully",
    "VALUE": {
        "title": "",
        "description": ""
    }
}

*/
