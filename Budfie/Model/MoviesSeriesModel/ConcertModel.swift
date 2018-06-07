//
//  ConcertModel.swift
//  Concert
//
//  Created by Appinventiv Technologies on 03/01/18.
//  Copyright © 2018 Appinventiv Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class ConcertModel {
    
    var concertId: String
    var concertName: String
    var concertDate: String
    var concertStartTime: String
    var concertEndTime: String
    var concertDuration: String
    var concertLocation: String
    var description: String
    var ticketLink: String
    var concertDay: String
    var concertImage: String
    
    
    init(initForConcertModel json: JSON) {
        self.concertId = json["event_id"].stringValue
        self.concertName = json["event_name"].stringValue
        self.concertDate = json["event_date"].stringValue
        self.concertDay  = json["event_day"].stringValue
        self.concertImage = json["event_image"].stringValue
        self.concertStartTime = json["event_time"].stringValue
        self.concertEndTime = json["event_end_time"].stringValue
        self.description = json["event_description"].stringValue
        self.ticketLink = json["ticket_link"].stringValue
        self.concertDuration = json["event_duration"].stringValue
        self.concertLocation = json["event_location"].stringValue
        
    }
    
}


/*
{
    "event_date" = "2018-01-04";
    "event_id" = 4d6a1c0f10b4e354fb752bb1ce9a895c;
    "event_image" = "https://lh3.googleusercontent.com/uY_NWnMCLHn3C1DxG-xDpC5-5T8K9Cd0RlBg-ObfSh1wWW3LioWwFxrzyCXTVEIkkojRDG9qg_SktipzhYLChMtW";
    "event_name" = "There Will Be Jokes 7th Edition - Stand Up Comedy Show - With Aman Deep,  Shaad Shafi,  Devesh Dixit";
    "event_time" = "20:00:00";
    "is_favourite" = 0;
},



{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Concert List has been fetched successfully",
    "VALUE": [
    {
    "event_id": "fe07cd733365318b3c2857fc18afb134",
    "event_image": "https://lh3.googleusercontent.com/xnrmiUMOlSXZ6PF3LifCjy18odAUp83oEAK03KHZ-S26o0N0E2uoknLVShfIFKJSHVbgBv-jCcBGJ7RPXd6PJ4xd",
    "event_name": "Product Management Certification Workshop",
    "event_date": "2018-01-03",
    "event_time": "09:00:00",
    "event_end_time": "18:00:00",
    "event_description": "At the end of the workshop you will be able to analyze market and competitive conditions and lay out product vision that is differentiated and delivers unique value based on customer demands. You will be able to involve activities from strategic to tactical and provide cross-functional leadershipbridging gaps within the company between different functions, most notably between engineering-oriented teams, sales and marketing, and support. \nOutcome of the workshop: \n \n Strategy \n   \n   Establish product vision and strategy \n   Clearly articulate the business value to the product team \n   Own the strategy behind the product along with its roadmap and must work with engineering to build what matters \n    \n Releases \n   \n   Execute product planning which teams will deliver and define the timeline \n   Owns release aspect of product, decide when (and when not) to create a master release \n    \n Ideation \n   \n   Own ideation -- the creative process of generating, developing, and curating new ideas \n    \n Features \n   \n   Define the features and requirements necessary to deliver a complete product to market and lead the product team to success \n    \n Go-to-market \n   \n   Responsibly make product decisions and lead resource for the rest of the organization when deep product expertise is required \n   Support and organize the activities that help to bring the product into target market and work directly with various stakeholders-- namely marketing, sales and support \n    \n Case Studies \n   \n   Covering Various Aspects of product management across Product Life Cycles \n   Purely Real World Business Problems in Technology Arena \n   Examples from Ecommerce, CRM, Consumer Electronics, Analytic, FinTech, Education, SaaS, Consumer App etc. \n    \n \nKey Takeaways: \n \n Ability to grasp the need of the customers and get those features built into the product \n Gather feedback from the market and incorporate them into the product roadmap \n Provide direction to the development team &amp; prioritize the features from the product roadmap to be developed \n Drive projects based on the product roadmap as well as commitment on deliverables to clients \n Present and demonstrate key features of the product to various prospects and clients \n Work on budget requirements for product development and marketing and ability to track &amp; work within budget \n Create a sales pipeline and then work on prospective clients \n \nLeadership Team: \nJoydeep: \n \n Serial Entrepreneur \n Commercialized Numerous Ideas \n 22 years of Proven Record including close to a&nbsp;decade of experience in Silicon valley \n History of Expertise in Client Acquisition &amp; Retention(GM, Toshiba &amp; Many) \n Multiple Patents Author \n Alumnus of NIT-Rourkela \n \nPinak: \n \n Senior Product Manager @ TechnoMedia \n 15 years of IT Experience including association with organizations like TCS, HCL, Silicon Valley funded start-up leading to acquisition, LG \n Mentored &amp; Devised Product Strategies for featured IT Start-ups \n Alumnus of IIM-Kozhikode &amp; NIT-Silchar \n"
}

*/
