//
//  GreetingListModel.swift
//  Budfie
//
//  Created by appinventiv on 08/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class GreetingListModel {
    
    let greeting_id : String
    let title       : String
    let greeting    : String
    let share_id    : String
    let share_time  : String
    let share_by    : String
    let music       : String
    
    init(initWithListModel json: JSON) {
        
        greeting_id = json["greeting_id"].stringValue
        title       = json["title"].stringValue
        greeting    = json["greeting"].stringValue
        share_id    = json["share_id"].stringValue
        share_by    = json["share_by"].stringValue
        music       = json["music"].stringValue
        
        let dateFormat = DateFormat.shortDate.rawValue

        if let date = GreetingListModel.getDate(from: json["share_time"].stringValue, format: dateFormat) {
            let modifiedDateString = date.toString(dateFormat: dateFormat)
            share_time = modifiedDateString
        } else {
            share_time = json["share_time"].stringValue
        }
    }
    
    private class func getDate(from dateString: String, format: String/*, timeZone: TimeZone? = TimeZone(identifier: "UTC")*/) -> Date? {
        let dateformatter = Date.dateFormatter
        dateformatter.dateFormat = format
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        //dateformatter.timeZone = timeZone
        if let date = dateformatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    init(initWithGreeting greet: Greeting) {
        
        greeting_id = greet.id ?? ""
        title       = greet.greetingTitle ?? ""
        greeting    = greet.faceInHoleImageUrl ?? ""
        share_id    = ""
        share_time  = greet.dateString ?? ""
        share_by    = ""
        music       = greet.musicUrl ?? ""
    }
    
}
// @objc dynamic var dateString: String?
/*
 id = ;
 faceHoleImageUrl = https://s3.amazonaws.com/appinventiv-development/budfie/test/4.5.1_jamsebond.png;
 musicUrl = https://s3.amazonaws.com/appinventiv-development/melodyloops-preview-happy-trip-1m0s+(1).mp3;
 isDraft = 0;
 faceInHoleImageData = <(null) — 0 total bytes>;
 faceInHoleImageUrl = (null);
 greetingTitle = (null);
 greetingDescription = (null);
 descriptionViewX = 0;
 descriptionViewY = 0;
 descriptionViewRotation = 0;
 descriptionViewScaleX = 0;
 descriptionViewScaleY = 0;
 faceImageData = <(null) — 0 total bytes>;
 faceImageX = 0;
 faceImageY = 0;
 faceImageRotation = 0;
 faceImageScaleX = 0;
 faceImageScaleY = 0;
 greetingColor = (null);

*/

/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Greeting List fetched successfully",
    "VALUE": {
        "greeting_id": "14",
        "title": "Vfjg",
        "greeting": "https:\/\/s3.amazonaws.com\/appinventiv-development\/4\/ANDROID\/image_1518072878751",
        "share_id": "1",
        "share_time": "2018-02-08 06:57:58",
        "share_by": "Akash Jain"
    }
}
*/
/*
{
    greeting = "https://s3.amazonaws.com/appinventiv-development/iOS/1518868238.png";
    "greeting_id" = 89;
    music = "https://s3.amazonaws.com/appinventiv-development/melodyloops-preview-happy-trip-1m0s+(1).mp3";
    title = xdxgt;
}
*/

