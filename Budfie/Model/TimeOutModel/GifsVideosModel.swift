//
//  GifsVideosModel.swift
//  Budfie
//
//  Created by appinventiv on 14/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class GifsVideosModel {
    
    let url         : String
    let thumbnail   : String
    let type        : String
    
    init(initWithList json : JSON) {
        
        self.url        = json["url"].stringValue
        self.thumbnail  = json["thumbnail"].string ?? json["name"].stringValue
        self.type       = json["type"].stringValue
    }
    
}


/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Video List fetched successfully",
    "VALUE": [
    {
    "url": "https://www.youtube.com/watch?v=AG67Lu45QMQ",
    "thumbnail": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682c3159bf41516776497.jpg",
    "type": "1"
    },
    {
    "url": "https://www.youtube.com/watch?v=GEdP0AKP9e8",
    "thumbnail": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682a633385f1516776035.jpg",
    "type": "1"
    },
    {
    "name": "Flying",
    "url": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a700a468fb101517292102.gif",
    "type": "2"
    },
    {
    "name": "Loader",
    "url": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a6075152defb1516270869.gif",
    "type": "2"
    }
    ]
}
*/
