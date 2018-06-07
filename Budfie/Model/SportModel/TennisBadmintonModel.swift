//
//  TennisBadmintonModel.swift
//  Budfie
//
//  Created by appinventiv on 27/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class TennisBadmintonModel {
    
    let description: String
    var isFavourite: String
    let match_date: String
    let match_time: String
    let result: String
    let share_url: String
    
    let team1: TeamModel
    let team2: TeamModel
    
    let title: String
    var type: String
    let venue: String

    
    var eventCustomDate: String {
        
        var rdate = ""
        
        if let date = self.match_date.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
            rdate = date.toString(dateFormat: "EEEE, d MMMM")
        }
        return rdate
    }
    
    
    init(initWithModel json: JSON) {
        
        description = json["description"].stringValue
        isFavourite = json["is_favourite"].stringValue
        match_date = json["match_date"].stringValue
        match_time = json["match_time"].stringValue
        result = json["result"].stringValue
        share_url = json["share_url"].stringValue
        
        team1 = TeamModel(initWithModel: json["team1"])
        team2 = TeamModel(initWithModel: json["team2"])
        
        title = json["title"].stringValue
        venue = json["venue"].stringValue
        type = ""
        
        if json["type"].stringValue == "1" {
            type = "In Progress"
        } else if json["type"].stringValue == "2" {
            type = "Completed"
        } else if json["type"].stringValue == "3" {
            type = "Notstarted"
        }
        
    }
    
}

//type: 1=In-Progress,2=completed,3=notstarted
class TeamModel {
    
    let player1: String
    let player2: String
    let winning_set: String
    var score = [String]()
    
    init(initWithModel json: JSON) {
        
        player1 = json["player1"].stringValue
        player2 = json["player2"].stringValue
        winning_set = json["winning_set"].stringValue
        
        for s in json["score"].arrayValue {
            score.append(s.stringValue)
        }
    }
    
}




/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Event details has been fetched successfully";
    VALUE =     {
        "event_details" =         {
            description = "";
            "is_favourite" = 0;
            "match_date" = "2018-02-27";
            "match_time" = "11:21:00";
            result = Loss;
            "share_url" = "http://budfiedev.applaurels.com/share/event?type=6&id=2";
            team1 =             {
                player1 = Test11;
                player2 = Test12;
                score =                 (
                    11,
                    11
                );
                "winning_set" = 0;
            };
            team2 =             {
                player1 = Test21;
                player2 = Test22;
                score =                 (
                    11,
                    21
                );
                "winning_set" = 1;
            };
            title = Olympics;
            type = 2;
            venue = Wankhede;
        };
    };
}
*/

/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Event details has been fetched successfully";
    VALUE =     {
        "event_details" =         {
            description = "";
            "is_favourite" = 0;
            "match_date" = "2018-02-27";
            "match_time" = "11:21:00";
            result = Loss;
            "share_url" = "http://budfiedev.applaurels.com/share/event?type=7&id=2";
            team1 =             {
                player1 = Test11;
                player2 = Test12;
                score =                 (
                    11,
                    11
                );
                "winning_set" = 0;
            };
            team2 =             {
                player1 = Test21;
                player2 = Test22;
                score =                 (
                    11,
                    21
                );
                "winning_set" = 1;
            };
            title = Tennis2;
            type = 3;
            venue = Wankhede;
        };
    };
}

*/
