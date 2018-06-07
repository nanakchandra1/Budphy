//
//  EditEventDetailsModel.swift
//  Budfie
//
//  Created by appinventiv on 22/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class EditEventDetailsModel {
    
    var eventName       : String
    var eventType       : String
    var eventDate       : String
    var eventTime       : String
    var eventLatitude   : String
    var eventLongitude  : String
    var eventImage      : String
    var eventLocation   : String
    var remindMe        : String
    var eventVideo      : String
    var greeting        : String
    var isFavourite     : String
    var url             : String
    var story           : String
    var city            : String
    var event_end_date  : String
    var event_end_time  : String
    var purchase_url    : String
    var day             : String
    var description     : String
    var duration        : String
    var genre           : String
    var eventAddress    : String
    var eventId         : String
    var avtar           : String
    var event_owner     : String
    var first_name      : String
    var greeting_id     : String
    var owner_image     : String
    var music           : String
    var share_url       : String
    var recurring_type  : String
    var invitees        = [FriendListModel]()
    var attendees       = [FriendListModel]()
    var eventOwner      = [FriendListModel]()
    
    let json            : JSON
    
    var moviereleaseDate:String?{
        
        let date = self.eventDate.toDate(dateFormat: "yyyy-MM-dd")
        let rdate = date?.toString(dateFormat: "MMM dd, yyyy")
        
        return rdate
    }
    
    var concertreleaseDate:String?{
        
        let date = self.eventDate.toDate(dateFormat: "yyyy-MM-dd")
        let rdate = date?.toString(dateFormat: "dd MMM yyyy")
        
        return rdate
    }
    
    var concertTime:String?{
        
        let date = self.eventTime.toDate(dateFormat: "HH:mm:ss")
        let rdate = date?.toString(dateFormat: "hh:mm a")
        
        return rdate
    }

    init(initForEventModel json: JSON) {
        self.json = json
        
        self.eventImage         = json["event_details"]["event_image"].stringValue
        self.eventName          = json["event_details"]["event_name"].stringValue
        self.eventType          = json["event_details"]["event_type"].stringValue
        self.eventDate          = json["event_details"]["event_date"].stringValue
        self.eventLocation      = json["event_details"]["event_location"].stringValue
        self.eventLatitude      = json["event_details"]["latitude"].stringValue
        self.eventLongitude     = json["event_details"]["longitude"].stringValue
        self.remindMe           = json["event_details"]["remind_me"].stringValue
        self.greeting           = json["event_details"]["greeting"].stringValue
        self.eventTime          = json["event_details"]["event_time"].stringValue
        self.eventVideo         = json["event_details"]["event_video"].stringValue
        self.url                = json["event_details"]["url"].stringValue
        self.isFavourite        = json["event_details"]["is_favourite"].stringValue
        self.story              = json["event_details"]["story"].stringValue
        self.city               = json["event_details"]["city"].stringValue
        self.event_end_date     = json["event_details"]["event_end_date"].stringValue
        self.event_end_time     = json["event_details"]["event_end_time"].stringValue
        self.purchase_url       = json["event_details"]["purchase_url"].stringValue
        self.description        = json["event_details"]["description"].stringValue.removingHtmlTags
        self.day                = ""
        self.genre              = ""
        self.duration           = json["event_details"]["duration"].stringValue
        self.eventAddress       = json["event_details"]["event_address"].stringValue
        self.eventId            = json["event_details"]["event_id"].stringValue
        self.avtar              = json["event_details"]["avtar"].stringValue
        self.event_owner        = json["event_details"]["event_owner"].stringValue
        self.first_name         = json["event_details"]["first_name"].stringValue
        self.greeting_id        = json["event_details"]["greeting_id"].stringValue
        self.owner_image        = json["event_details"]["image"].stringValue
        self.music              = (json["event_details"]["music"].string ?? json["event_details"]["music_id"].stringValue)
        self.share_url          = json["event_details"]["share_url"].stringValue
        self.recurring_type     = json["event_details"]["recurring_type"].stringValue
        
        if let date = self.eventDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
            self.day = date.toString(dateFormat: DateFormat.day.rawValue)
        }
        self.invitees   = [FriendListModel]()
        self.attendees  = [FriendListModel]()
        self.eventOwner = [FriendListModel]()
        
        self.eventOwner.append(FriendListModel(initWithEventDetails: JSON(json["event_details"])))
        
        //append(FriendListModel(initWithEventDetails: JSON(json["event_details"])))
        
        for temp in json["event_invitees"].arrayValue {
            self.invitees.append(FriendListModel(initForFriendList: temp))
        }
        
        for temp in json["event_attendees"].arrayValue {
            self.attendees.append(FriendListModel(initForFriendList: temp))
        }
        
        if let genre = json["event_details"]["genre"].array,!genre.isEmpty{
            
            for gen in genre {
                self.genre = self.genre + gen.stringValue + ","
            }
//            self.genre = genre[0]["genre"].stringValue
        }
        
        let startTime = json["event_details"]["event_time"].stringValue
        let endTime = json["event_details"]["event_end_time"].stringValue
        
        if let sTime = startTime.toDate(dateFormat: "HH:mm:ss"),
            let eTime = endTime.toDate(dateFormat: "HH:mm:ss") {
            
            let int = eTime.timeIntervalSince(sTime)
            let hours = int.hours
            let mins = int.minutes
            self.duration = "\(hours) h \(mins) min"
        }
    }
}


/*
"event_details" =         {
    avtar = 0;
    "event_date" = "2018-02-14";
    "event_image" = "";
    "event_location" = "";
    "event_name" = Alsgzji;
    "event_owner" = 2;
    "event_time" = "04:00:00";
    "event_type" = 1;
    "first_name" = "Akash Jain";
    greeting = "";
    "greeting_id" = 0;
    image = "";
    latitude = 0;
    longitude = 0;
    music = "<null>";
    "remind_me" = "2018-02-14 03:30:00";

"event_details" =         {
    avtar = 0;
    "event_date" = "2018-02-09";
    "event_image" = "";
    "event_location" = "";
    "event_name" = trst;
    "event_owner" = 5;
    "event_time" = "00:00:00";
    "event_type" = 1;
    "first_name" = Yogesh;
    greeting = "";
    "greeting_id" = 0;
    image = "";
    latitude = 0;
    longitude = 0;
    "remind_me" = "2018-02-09 00:30:00";
};
*/
// Movies
/*
{
    "event_details" =         {
        duration = "2 hours 21 minutes";
        "event_date" = "2018-01-05";
        "event_image" = "http://t0.gstatic.com/images?q=tbn:ANd9GcQcNG4A1BpQUaLytskP89AuMCknrptdKnQQrBWidiTOVaMdlaLs";
        "event_name" = "Fukrey Returns";
        "event_type" = Hollywood;
        "event_video" = "";
        genre =             (
            {
                genre = Drama;
            }
        );
        "is_favourite" = 0;
        story = "Fukrey Returns picks up a year later from where it ended. Having enjoyed the spoils of war they had so audaciously waged, the Fukras are now at crossroads with their past, which is about to decide their future. Bent upon a merciless payback, Bholi Punjaban is back and all set to take the Fukras on a deadly ride! Even a city, as geographically varied as Delhi is not large enough for them to design a well-defined escape trajectory. Unaware of how they're being master minded by a certain head honcho, the Fukras are on the run again!! Are the four Fukras going to play out their cards carefully? Will Choocha's God gifted power come to their rescue?";
        url = "https://www.youtube.com/watch?v=f-UzOpuKOVY";
    };

*/
/*
{
    "event_details" =         {
        duration = "";
        "event_date" = "2018-01-18";
        "event_image" = "";
        "event_name" = abc;
        "event_type" = Bollywood;
        "event_video" = fasfdASF;
        genre =             (
        );
        "is_favourite" = 0;
        story = SADASdAD;
        url = "";
    };

*/


// Concert

/*
"event_details" =         {
    city = Delhi;
    description = "<p>Candle is not only used as the lighting source but is also an interesting element to enhance the beauty in life on various occasions.At&nbsp;<strong>CSDO,</strong>&nbsp;various courses are arranged to improve your skills and help you learn various skills. Here are experts who conduct a&nbsp;<strong>class</strong>&nbsp;to provide skills and shape new talents that will bring revolution in the&nbsp;<strong>Candle making</strong>&nbsp;industry. The raw material in the classes is provided by the institution. Thus, you just have to stay active and learn the techniques to introduce new ideas into results in making appealing candles. The elements covered in the course will be starting from the general introduction of the course, benefits, the raw material used, equipment required, various packaging styles, different shapes and sizes, various processes and even knowledge on setting you your own business. The trainers also lend their support to even contact the right supplier, enter the market and set up the industry operation at the initial stage.</p> \n<p>Syllabus</p> \n<p>How to make Plain candles</p> \n<p>How to make&nbsp;Angle Layered candles</p> \n<p>How to make Perfume candles</p> \n<p>How to make Layered candles</p> \n<p>How to make Floating candles</p> \n<p><b>One to one session fee is 3000/-</b><b><br /></b><b>Workshop fee is&nbsp;</b><b>Rs</b><b>&nbsp;2500/-</b><b><br /></b><b>Avail an early bird discount of Rs500/- by depositing your Fee before 4 Days Of Workshop Date.</b><b><br /></b><b>Limited seats !!!!!!</b></p>";
    "event_date" = "2018-01-05";
    "event_end_date" = "2018-01-05";
    "event_end_time" = "17:00:00";
    "event_id" = dc30eb4871bcd8d5812e84bcf7a360e8;
    "event_image" = "https://lh3.googleusercontent.com/pg-ABvOs7jFYhh2FGvVSF38m-9KsMkVr52tP1wanpVNCwIgCP10O4xtsf6pKPRZ90FLzyBPGd_sbFBTNQ1Cn0AIB";
    "event_name" = "Candle making classes in delhi";
    "event_time" = "14:00:00";
    "is_favourite" = 0;
    "purchase_url" = "https://www.eventshigh.com/detail/Delhi/dc30eb4871bcd8d5812e84bcf7a360e8-Candle-making-classes-in-delhi?src=eh-test";
};
*/

/*
{
    "event_details" =         {
        description = "&nbsp;A stand-up comedy show by three weird guys who have their life sorted out and clearly know what they want to do in their lives.&nbsp;Krishnendu Paul is a Bengali from Assam who is a misfit everywhere. He has been working since 2008 recession and has not come out of it since then. He stays in Gurgaon and has being trying his hand at comedy for more then a year. His failed attempt at being a stud and his boring corporate life inspired him to do comedy. He was doing comedy anyway. It's good to have a mic now.&nbsp;Milind Kapoor is an observant comedian, all of whose material comes from his life. He is a disgrace to Punjabi people.Yes he is a Vegetarian Punjabi ,a Half engineer (engineering dropout). Clearly a poor Kapoor. He left Mumbai and came to Delhi to pursue his dreams , seriously? Who does that ?Performed at various places like Mumbai, Delhi , Gurgaon (sorry gurugram), Chandigarh, Jaipur ,even greater Noida.Vaibhav Arora, a cute Punjabi guy, who doesn't do drugs during day time, comes from a typical Indian Joint family. He dropped CA to pursue BJMC, which is like leaving Aishwarya Rai for Rakhi Sawant. He developed a keen sense of observing people and his own life experiences, all of which have found its way into his comedy. Vaibhav is also a photographer.";
        "event_address" = "11-B. Baba Kharak Singh Marg, Next to RML Hospital Exit no. 5, New Delhi, Delhi 110001";
        "event_date" = "2018-01-06";
        "event_end_date" = "2018-01-06";
        "event_end_time" = "21:30:00";
        "event_id" = 856136b5778e62e08380e5dfd2558ba3;
        "event_image" = "https://lh3.googleusercontent.com/7x_xZLG5vh0YzkCWwPXfYXrhcIbq2_B8xeug-8NS5con_KrZIdYTUL3_SfTa7K626uIBg_G89nGQauUPlIjfLB4h";
        "event_name" = "The Humor Showcase - Hinglish stand up comedy  - With Krishnendu Paul, Vaibhav Arora, Milind Kapoor";
        "event_time" = "20:00:00";
        "is_favourite" = 0;
        latitude = "28.625779";
        longitude = "77.203341";
        "purchase_url" = "https://www.eventshigh.com/detail/Delhi/856136b5778e62e08380e5dfd2558ba3-The-Humor-Showcase-Hinglish-stand?src=eh-test";
    };
};
*/

/*

{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Event details fetched successfully";
    VALUE =     {
        "event_attendees" =         (
        );
        "event_details" =         {
            "event_date" = "2017-12-27";
            "event_image" = "";
            "event_location" = "";
            "event_name" = 0987654321;
            "event_time" = "09:17:00";
            "event_type" = 1;
            greeting = "";
            latitude = 0;
            longitude = 0;
            "remind_me" = "0000-00-00 00:00:00";
        };
        "event_invitees" =         (
            {
                "first_name" = Budfie;
                image = "";
                "last_name" = "";
        },
            {
                "first_name" = "Rohit Bhai";
                image = "";
                "last_name" = "";
        },
            {
                "first_name" = Yogesh;
                image = "https://lh5.googleusercontent.com/-xyAF7uJlsFM/AAAAAAAAAAI/AAAAAAAAAiU/ye7wRzDI5H4/s200/photo.jpg";
                "last_name" = Negi;
        }
        );
    };
}

*/
