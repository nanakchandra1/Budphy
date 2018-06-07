//
//  CricketDetailsModel.swift
//  Budfie
//
//  Created by appinventiv on 06/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class CricketDetailsModel {
    
    let description     : String
    let highest_run     : String
    let highest_wicket  : String
    let man_of_match    : String
    var match_date      : String
    let match_status    : String
    let match_time      : String
    let name            : String
    let season_name     : String
    let duration        : TimeInterval
    let related_name    : String
    var result          : String
    let team1           : String
    let team1_img       : String
    let team1_short_name: String
    let team2           : String
    let team2_img       : String
    let team2_short_name: String
    let toss            : String
    let type            : String
    let venue           : String
    var isFavourite     : String
    let share_url       : String
    var innings         = [InningsModel]()
    
    init(initWithInnings json: JSON) {
        
        for inning in json["innings"].arrayValue {
            self.innings.append(InningsModel(initWithInnings: inning))
        }
        
        self.description        = json["description"].stringValue.removingHtmlTags
        self.highest_run        = json["highest_run"].stringValue
        self.highest_wicket     = json["highest_wicket"].stringValue
        self.man_of_match       = json["man_of_match"].stringValue
        self.match_date         = json["match_date"].stringValue
        self.match_status       = json["match_status"].stringValue
        self.match_time         = json["match_time"].stringValue
        self.name               = json["name"].stringValue
        season_name             = json["season_name"].stringValue
        duration                = json["duration"].doubleValue
        self.related_name       = json["related_name"].stringValue

        self.result = json["result"].stringValue
        if result.isEmpty {
            self.result = json["toss"].stringValue
        }

        self.toss               = json["toss"].stringValue
        self.type               = json["type"].stringValue
        self.venue              = json["venue"].stringValue
        self.isFavourite        = json["is_favourite"].stringValue
        self.share_url          = json["share_url"].stringValue
        
        if let shortName = json["team1_short_name"].string,
            !innings.isEmpty, shortName == innings[0].team_short_name {
            self.team1              = json["team1"].stringValue
            self.team1_img          = json["team1_img"].stringValue
            self.team1_short_name   = json["team1_short_name"].stringValue
            self.team2              = json["team2"].stringValue
            self.team2_img          = json["team2_img"].stringValue
            self.team2_short_name   = json["team2_short_name"].stringValue
        } else {
            self.team2              = json["team1"].stringValue
            self.team2_img          = json["team1_img"].stringValue
            self.team2_short_name   = json["team1_short_name"].stringValue
            self.team1              = json["team2"].stringValue
            self.team1_img          = json["team2_img"].stringValue
            self.team1_short_name   = json["team2_short_name"].stringValue
        }
    }
    
}

// Match Status(1=notstarted,2=started,3=completed), type(1=t20,2=one-day,3=test)
// Cricket Response = 6 feb 2018
/*
{
    "event_details" =         {
        description = "On 06 February 2018, Afghanistan and Zimbabwe are playing International Cricket Match, which is held in Sharjah Cricket Association Stadium, Sharjah, UAE. Afghanistan vs Zimbabwe Match will begin at 15:00 GMT. Afghanistan vs Zimbabwe - 2nd T20 Match - Afghanistan vs Zimbabwe 2018.";
        "highest_run" = "Malcolm Waller";
        "highest_wicket" = "Malcolm Waller";
        innings =             (
        );
        "man_of_match" = "Malcolm Waller";
        "match_date" = "2018-02-06";
        "match_status" = notstarted;
        "match_time" = "20:30:00";
        name = "Afghanistan vs Zimbabwe";
        "related_name" = "2nd T20 Match";
        result = "";
        team1 = Afghanistan;
        "team1_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/afg";
        "team1_short_name" = AFG;
        team2 = Zimbabwe;
        "team2_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/zim";
        "team2_short_name" = ZIM;
        toss = "";
        type = t20;
        venue = "Sharjah Cricket Association Stadium, Sharjah, UAE";
    };
};
 

{
    "event_details" =         {
        description = "On 07 February 2018, South Africa and India are playing International Cricket Match, which is held in Newlands, Cape Town, South Africa. South Africa vs India Match will begin at 11:00 GMT. South Africa vs India - 3rd ODI Match - South Africa vs India 2017.";
        "highest_run" = "Imran Tahir";
        "highest_wicket" = "Imran Tahir";
        innings =             (
        );
        "man_of_match" = "Imran Tahir";
        "match_date" = "2018-02-07";
        "match_status" = notstarted;
        "match_time" = "16:30:00";
        name = "South Africa vs India";
        "related_name" = "3rd ODI Match";
        result = "";
        team1 = "South Africa";
        "team1_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/rsa";
        "team1_short_name" = RSA;
        team2 = India;
        "team2_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/ind";
        "team2_short_name" = IND;
        toss = "";
        type = "one-day";
        venue = "Newlands, Cape Town, South Africa";
    };
};
 

innings =             (
    {
        "team_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/hbh";
        "team_name" = "Hobart Hurricanes";
        "team_over" = "20.0";
        "team_run" = 177;
        "team_short_name" = HBH;
        "team_wicket" = 5;
        title = inning1;
},
    {
        "team_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/hbh";
        "team_name" = "Adelaide Strikers";
        "team_over" = "20.0";
        "team_run" = 202;
        "team_short_name" = ADS;
        "team_wicket" = 2;
        title = inning1;
},
    {
        "team_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/hbh";
        "team_name" = "Hobart Hurricanes";
        "team_over" = "";
        "team_run" = "";
        "team_short_name" = HBH;
        "team_wicket" = "";
        title = inning2;
},
    {
        "team_img" = "http://budfiedev.applaurels.com/Backend/public/public/Flags/hbh";
        "team_name" = "Adelaide Strikers";
        "team_over" = "";
        "team_run" = "";
        "team_short_name" = ADS;
        "team_wicket" = "";
        title = inning2;
}
);

*/
