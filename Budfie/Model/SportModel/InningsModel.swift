//
//  InningsModel.swift
//  Budfie
//
//  Created by appinventiv on 06/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class InningsModel {
    
    let team_img                : String
    let team_name               : String
    let team_over               : String
    let team_run                : String
    let team_short_name         : String
    let team_wicket             : String
    let title                   : String
    
    let current_player1         : String
    let current_player1_balls   : String
    let current_player1_run     : String
    let current_player2         : String
    let current_player2_balls   : String
    let current_player2_run     : String
    let current_runs_rate       : String
    let req_runs_rate           : String
    let req_runs                : String
    let req_balls               : String
    
    init(initWithInnings json: JSON) {
        
        self.team_img       = json["team_img"].stringValue
        self.team_name      = json["team_name"].stringValue
        self.team_over      = json["team_over"].stringValue
        self.team_run       = json["team_run"].stringValue
        self.team_short_name = json["team_short_name"].stringValue
        self.team_wicket    = json["team_wicket"].stringValue
        self.title          = json["title"].stringValue
        
        self.current_player1        = json["current_player1"].stringValue
        self.current_player1_balls  = json["current_player1_balls"].stringValue
        self.current_player1_run    = json["current_player1_run"].stringValue
        self.current_player2        = json["current_player2"].stringValue
        self.current_player2_balls  = json["current_player2_balls"].stringValue
        self.current_player2_run    = json["current_player2_run"].stringValue
        self.current_runs_rate      = json["current_runs_rate"].stringValue
        self.req_runs_rate          = json["req_runs_rate"].stringValue
        self.req_runs               = json["req_runs"].stringValue
        self.req_balls              = json["req_balls"].stringValue
    }

    init() {

        team_img                = ""
        team_name               = ""
        team_over               = "0"
        team_run                = "0"
        team_short_name         = ""
        team_wicket             = "0"
        title                   = ""

        current_player1         = ""
        current_player1_balls   = "0"
        current_player1_run     = "0"
        current_player2         = ""
        current_player2_balls   = "0"
        current_player2_run     = "0"
        current_runs_rate       = "0.0"
        req_runs_rate           = "0.0"
        req_runs                = "0"
        req_balls               = "0"

    }

}

/*
innings =             (
    {
        "current_player1" = "";
        "current_player1_balls" = "";
        "current_player1_run" = "";
        "current_player2" = "";
        "current_player2_balls" = "";
        "current_player2_run" = "";
        "current_runs_rate" = "";
        "req_balls" = "";
        "req_runs" = "";
        "req_runs_rate" = "";
        "team_img" = "http://budfiedev.applaurels.com/public/Flags/afg.png";
        "team_name" = Afghanistan;
        "team_over" = "20.0";
        "team_run" = 158;
        "team_short_name" = AFG;
        "team_wicket" = 9;
        title = inning1;
},
    {
        "current_player1" = "";
        "current_player1_balls" = "";
        "current_player1_run" = "";
        "current_player2" = "";
        "current_player2_balls" = "";
        "current_player2_run" = "";
        "current_runs_rate" = "7.05";
        "req_balls" = "";
        "req_runs" = "";
        "req_runs_rate" = "";
        "team_img" = "http://budfiedev.applaurels.com/public/Flags/zim.png";
        "team_name" = Zimbabwe;
        "team_over" = "20.0";
        "team_run" = 141;
        "team_short_name" = ZIM;
        "team_wicket" = 5;
        title = inning1;
}
);
*/

/*
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
