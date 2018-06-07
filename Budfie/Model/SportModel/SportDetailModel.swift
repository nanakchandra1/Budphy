//
//  SportDetailModel.swift
//  Budfie
//
//  Created by Aakash Srivastav on 23/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class SportDetail {

    let eventId: String
    let league: String
    let venue: String
    let localTeamName: String
    let localTeamImage: String
    let localTeamScore: String
    let visitorTeamName: String
    let visitorTeamImage: String
    let visitorTeamScore: String
    let eventDateString: String
    let eventTimeString: String
    var isFavourite: String
    let eventImage: String
    let share_url: String
    let gameDuration: Int

    let goals: [SoccerGoal]
    
    var soccerEventDate:String? {
        
        let date = self.eventDateString.toDate(dateFormat: "yyyy-MM-dd")
        let rdate = date?.toString(dateFormat: "dd MMMM yyyy")
        
        return rdate
    }
    
    var soccerEventTime:String? {
        
        let date = self.eventTimeString.toDate(dateFormat: "HH:mm:ss")
        let rdate = date?.toString(dateFormat: "hh:mm a")
        
        return "\(rdate ?? "")"
    }

    required init?(with json: JSON) {

        let id = json["event_id"].stringValue
        guard !id.isEmpty else {
            return nil
        }

        eventId             = id
        league              = json["league"].stringValue
        venue               = json["venue"].stringValue
        localTeamName       = json["local_team_name"].string ?? json["team_a"].stringValue
        localTeamImage      = json["local_team_image"].string ?? json["team_a_image"].stringValue
        localTeamScore      = json["localteam_score"].string ?? json["team_a_score"].stringValue
        visitorTeamName     = json["visitor_team_name"].string ?? json["team_b"].stringValue
        visitorTeamImage    = json["visitor_team_image"].string ?? json["team_b_image"].stringValue
        visitorTeamScore    = json["visitorteam_score"].string ?? json["team_b_score"].stringValue
        eventDateString     = json["event_date"].stringValue
        eventTimeString     = json["event_time"].stringValue
        isFavourite         = json["is_favourite"].stringValue
        share_url           = json["share_url"].stringValue
        gameDuration        = json["minute"].intValue
        goals               = SoccerGoal.models(from: json["goals"].arrayValue).sorted(by: {$0.minute < $1.minute})
        
        eventImage          = ""
    }
    
}

class SoccerGoal {

    let teamId      : String
    let playerName  : String
    let minute      : Int

    init(with json: JSON) {
        teamId      = json["team_id"].stringValue
        playerName  = json["player_name"].stringValue
        minute      = json["minute"].intValue
    }

    final class func models(from array: [JSON]) -> [SoccerGoal] {
        var goals = [SoccerGoal]()
        for json in array {
            let goal = SoccerGoal(with: json)
            goals.append(goal)
        }
        return goals
    }
}

/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Event details has been fetched successfully";
    VALUE =     {
        "event_details" =         {
            "event_date" = "2018-01-23";
            "event_id" = 1871899;
            "event_time" = "19:45:00";
            "is_favourite" = 0;
            league = Premiership;
            "local_team_image" = "https://cdn.sportmonks.com/images/soccer/teams/19/339.png";
            "local_team_name" = "Partick Thistle";
            "localteam_score" = 0;
            venue = "The Energy Check Stadium 80 Firhill Road Glasgow";
            "visitor_team_image" = "https://cdn.sportmonks.com/images/soccer/teams/21/53.png";
            "visitor_team_name" = Celtic;
            "visitorteam_score" = 0;
        };
    };
}
*/
